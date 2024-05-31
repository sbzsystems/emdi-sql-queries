/*
This SQL performs the duplication of sales documents (pvlhseis) and associated lines (grammes) and movements (kinhseis). The script ensures the new documents and their lines are correctly created and updated, with the necessary changes in stock availability.
Variables

    newdocid and newdocid2: Integers representing new document IDs.
    fromtitle: A string used as a suffix for related document references.
    loy and loytwo: Codes representing products.
    multiplier: Determines if the document is for sales (1) or purchases (-1).
    paym: New payment ID.
    created_doc_id: Stores the ID of the created document.

Process Outline

    Updating Document Details from Packing List
        The script updates custom fields in the pvlhseis table based on associated eidhpar records and specific date formats.

    Stock Update and Old Document Line Deletion
        If a related document exists, the script updates stock levels, deletes old document lines from grammes and kinhseis tables, and inserts new document lines.

    Creating a New Document
        If no related document exists, a new document is created in the pvlhseis table, and a new document line is added to the grammes and kinhseis tables.

    Updating Stock Levels
        Adjusts stock availability based on the new document lines.

    Updating Related Document Fields
        Synchronizes various fields of the new document with the original document to ensure consistency.

    Handling a Second Document (newdocid2)
        Similar logic is applied to handle a second document type, ensuring all associated lines and stock updates are processed accordingly.
*/



-- doc -- 

-- COPY DOCUMENT     se confirmation
EXECUTE BLOCK AS
declare newdocid int = 125;
declare newdocid2 int = 126;
declare fromtitle varchar(1000) = '';   -- related document suffix
declare loy varchar(10) = 'conf'; -- code of product for receive money
declare loytwo varchar(10) = 'Cmr';
declare multiplier smallint = 1;        -- 1 sales  -1 purchases
declare paym int = 1; -- new payment id
declare created_doc_id int; -- new payment id

BEGIN
--STOIXEIA APO PACKING LIST   

UPDATE "pvlhseis"
SET "pvlhseis"."custom2" = (
  SELECT ppp."Parastatiko" || ' ' || ppp."Ariumos" || ' ' || ppp."Seira" || ' ' ||
         RIGHT('0' || EXTRACT(DAY FROM sss."Hmeromhnia"), 2) || '/' ||
         RIGHT('0' || EXTRACT(MONTH FROM sss."Hmeromhnia"), 2) || '/' ||
         RIGHT(EXTRACT(YEAR FROM sss."Hmeromhnia"), 2)
  FROM "eidhpar" ppp, "pvlhseis" sss
  WHERE ppp."Aa" = sss."Parastatiko"
  AND sss."Sxetiko" = :aa
)
WHERE "Aa" = :aa;
                    
-------------------------------------------------
-------------------------------------------------
 
    -- change newdocid based on customer code
    -- if ((select "pelates"."Kvdikos" from "pelates" where "pelates"."Aa"=:cl)='customer code') then newdocid=1;
 
    created_doc_id=(select pvl."Aa" from "pvlhseis" pvl where pvl."Sxetika" like '%&'||:aa||:fromtitle);
    if ((select count("pvlhseis"."Aa") from "pvlhseis" where "pvlhseis"."Aa"=:created_doc_id)>0) then begin
                          
                                                        
        -- UPDATE STOCK                                                                
        update "apouhkh" set "apouhkh"."Diauesimothta"="apouhkh"."Diauesimothta"+ 
        :multiplier*(select sum(grm."Posothta")                                                                                                                                               
        from "pvlhseis" pvm,"grammes" grm                                                                  
                                                                                                 
        where pvm."Aa"=:created_doc_id
        and grm."Aapar"=pvm."Aa"
        and "apouhkh"."Aa"=grm."Eidos")
 
        where "apouhkh"."Aa" in
        (select grm."Eidos" from "pvlhseis" pvm,"grammes" grm                                         
        where pvm."Aa"=:created_doc_id
        and grm."Aapar"=pvm."Aa")     
        ;     
        
        
        -- DELETE OLD DOCUMENT LINES
        delete from "grammes" 
        where "grammes"."Aapar"=:created_doc_id
        ;
        
        --DELETE OLD DOCUMENT LINES
        delete from "kinhseis" 
        where "kinhseis"."aapar"=:created_doc_id
        ;
    
        --CREATE NEW DOCUMENT LINE INCLUDED ONE PRODUCT WITH ID 'LOY'
            insert into "grammes" ("grammes"."Aa","grammes"."Aapar","grammes"."Eidos","grammes"."KvdikosEidoys",
                "grammes"."PerigrafhEidoys","grammes"."fpa_","grammes"."Posothta","grammes"."Monada","grammes"."monada_",
                "grammes"."Timh","grammes"."Ekptvsh","grammes"."order"
            )
            values(
                (select gen_id("gen_grammes_id", 1) as fname from RDB$DATABASE),
                :created_doc_id,                
                (select apo1."Aa" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
                (select apo1."Kvdikos" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
                (select apo1."Perigrafh" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
                (select apo1."fpaT" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
                                
                1  --quantity
                
                ,
                (select apo1."Monada" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
                (select "monades"."Monades" from "apouhkh" apo1 left join "monades" on "monades"."Aa"=apo1."Monada" where apo1."Kvdikos"=:loy),
                
                coalesce(
                (select ppl."synolo_" from "pvlhseis" ppl where ppl."Aa"=:aa)
            ,0)
                            
                ,
                0,0
            )
            
            ;
            
            
            insert into "kinhseis"("Grammh","Baros","aapar") 
            
            select gr2."Aa",kin."Baros",gr2."Aapar"
            from "grammes" gr1,"grammes" gr2,"kinhseis" kin
            where gr1."Aapar"=:aa
            and  gr2."Aapar"=:created_doc_id
             and gr1."PerigrafhEidoys"=gr2."PerigrafhEidoys"
            and gr1."Aa"=kin."Grammh" 
            order by gr1."Aa",gr2."Aa"    
 
                                  
            ; 
            

    end else begin
 
     
        -- CREATE NEW DOCUMENT
        insert into "pvlhseis" ("pvlhseis"."modified","pvlhseis"."Aa", "pvlhseis"."Ariumospar",
        "pvlhseis"."Hmeromhnia","pvlhseis"."Parastatiko","pvlhseis"."Sxetika")
        values ('Now',
        (select gen_id("gen_pvlhseis_id", 1) as fname from RDB$DATABASE),
        (select eid1."Ariumos" from "eidhpar" eid1 where eid1."Aa"=:newdocid),
        'NOW',
        :newdocid,
        (select substring(eid2."Parastatiko" from 1 for 3)||' '||pvl2."Seira"||'#'||pvl2."Ariumospar" from "pvlhseis" pvl2
        left join "eidhpar" eid2 on eid2."Aa"=pvl2."Parastatiko"
        where pvl2."Aa"=:aa)||' &'||:aa||:fromtitle
        )    
        ;
             
        -- INCREMENT NUMBER TO DOCUMENT TYPE
        update "eidhpar" set "eidhpar"."Ariumos"="eidhpar"."Ariumos"+1 where "eidhpar"."Aa"= :newdocid
        ;
        
        created_doc_id=(select pvl."Aa" from "pvlhseis" pvl where pvl."Sxetika" like '%&'||:aa||:fromtitle)
        ;
        
                                                          
        
--CREATE NEW DOCUMENT LINE INCLUDED ONE PRODUCT WITH ID 'LOY'
            insert into "grammes" ("grammes"."Aa","grammes"."Aapar","grammes"."Eidos","grammes"."KvdikosEidoys",
                "grammes"."PerigrafhEidoys","grammes"."fpa_","grammes"."Posothta","grammes"."Monada","grammes"."monada_",
                "grammes"."Timh","grammes"."Ekptvsh","grammes"."order"
            )
            values(
                (select gen_id("gen_grammes_id", 1) as fname from RDB$DATABASE),
                :created_doc_id,                
                (select apo1."Aa" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
                (select apo1."Kvdikos" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
                (select apo1."Perigrafh" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
                (select apo1."fpaT" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
                                
                1  --quantity
                
                ,
                (select apo1."Monada" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
                (select "monades"."Monades" from "apouhkh" apo1 left join "monades" on "monades"."Aa"=apo1."Monada" where apo1."Kvdikos"=:loy),
                
                coalesce(
                (select ppl."synolo_" from "pvlhseis" ppl where ppl."Aa"=:aa)
            ,0)
                            
                ,
                0,0
            )
            
            ;   

         
            insert into "kinhseis"("Grammh","Baros","aapar") 
            
            select gr2."Aa",kin."Baros",gr2."Aapar"
            from "grammes" gr1,"grammes" gr2,"kinhseis" kin
            where gr1."Aapar"=:aa
            and  gr2."Aapar"=:created_doc_id
            and gr1."PerigrafhEidoys"=gr2."PerigrafhEidoys"
            and gr1."Aa"=kin."Grammh" 
            order by gr1."Aa",gr2."Aa"    
            

            ; 
            
        
    end
 
                                
 -- UPDATE STOCK
        update "apouhkh" set "apouhkh"."Diauesimothta"="apouhkh"."Diauesimothta"-
        :multiplier*(select sum(grm."Posothta")
        from "pvlhseis" pvm,"grammes" grm
 
        where pvm."Aa"=:created_doc_id
        and grm."Aapar"=pvm."Aa"
        and "apouhkh"."Aa"=grm."Eidos")
 
        where "apouhkh"."Aa" in
        (select grm."Eidos" from "pvlhseis" pvm,"grammes" grm
        where pvm."Aa"=:created_doc_id
        and grm."Aapar"=pvm."Aa")                                                                                
        ;                                            
 
     
 
-- UPDATE related document
update "pvlhseis" pvm set
 
pvm."modified"='Now',
pvm."Sxetiko"=:created_doc_id
 
where pvm."Aa"=:aa
 
;
 


--UPDATE NEW DOCUMENT ADDING TOTALS
        update "pvlhseis" pvm set                                 
        
        pvm."synolofpa_"=(select(((gra ."Posothta"* gra."Timh")* gra."fpa_"   )/100) from"grammes" gra where gra."Aapar"=pvm."Aa"),
        
        pvm."synolonpe_"=(select(((gra ."Posothta"* gra."Timh")* gra."fpa_"   )/100) from"grammes" gra where gra."Aapar"=pvm."Aa"),
        
        pvm."synolo_"=(select (gra ."Posothta"* gra."Timh")+    (((gra ."Posothta"* gra."Timh")* gra."fpa_"   )/100) from"grammes" gra where gra."Aapar"=pvm."Aa"),
        
        pvm."synoloposothtas_"=(select floor(gra ."Posothta") from"grammes" gra where gra."Aapar"=pvm."Aa"),
        
    --    pvm."synolofpa_"=(select pvm2."synolofpa_" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
    --    pvm."synolonpe_"=(select pvm2."synolonpe_" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
    --    pvm."synolo_"=(select pvm2."synolo_" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
    --    pvm."synoloposothtas_"=(select pvm2."synoloposothtas_" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),

        
        pvm."Kvdikospelath"=(select pvm2."Kvdikospelath" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),  -- customer id
        pvm."Paradosh"=(select pvm2."Paradosh" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."assignor"=(select pvm2."assignor" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."Apostolh"=(select pvm2."Apostolh" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."Plhrvmh"=(select pvm2."Plhrvmh" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."Hmeromhnia"=(select pvm2."Hmeromhnia" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."Sxolio"=(select pvm2."Sxolio" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."Tropos"=(select pvm2."Tropos" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."Skopos"=(select pvm2."Skopos" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."Pinakida"=(select pvm2."Pinakida" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."custom1"=(select pvm2."custom1" from "pvlhseis" pvm2 where pvm2."Aa"=:aa), 
        
        pvm."custom2"=(select pvm2."custom2" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        
   --   pvm."custom4"=(select pvm2."Ariumospar"||' '||pvm2."Seira" from "pvlhseis" pvm2 where pvm2."Aa"=:aa)  , 
        pvm."custom4"=(select pvm2."Seira"||' '||pvm2."Ariumospar" from "pvlhseis" pvm2 where pvm2."Aa"=:aa)  , 
    --  pvm."custom3"=(select CAST(pvm2."Hmeromhnia" AS DATE) from "pvlhseis" pvm2 where pvm2."Aa"=:aa)  ,   
        pvm."custom3"=(SELECT 
  EXTRACT(DAY FROM pvm2."Hmeromhnia") || '/' ||
  EXTRACT(MONTH FROM pvm2."Hmeromhnia") || '/' ||
  RIGHT(EXTRACT(YEAR FROM pvm2."Hmeromhnia"), 4) AS FormattedDate
FROM "pvlhseis" pvm2
WHERE pvm2."Aa" = :aa
),
        
        pvm."Fortvsh"=(select pvm2."Fortvsh" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."voucher"=(select pvm2."voucher" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
        pvm."ogkos_syn"=0,
        pvm."embado_syn"=0,
        pvm."baros_syn"=0,
        pvm."ajia_syn"=0,
        pvm."synolikopososto"=0,
        pvm."loipes_"=0
        
        where pvm."Aa"=:created_doc_id
        
        ;
 

-- COPY DOCUMENT 2

-------------------------------------------------
-------------------------------------------------
 
    -- change newdocid2 based on customer code
    -- if ((select "pelates"."Kvdikos" from "pelates" where "pelates"."Aa"=:cl)='customer code') then newdocid2=1;
 
    created_doc_id=(select pvl."Aa" from "pvlhseis" pvl where pvl."Sxetika" like '%&T'||:aa||:fromtitle);
    if ((select count("pvlhseis"."Aa") from "pvlhseis" where "pvlhseis"."Aa"=:created_doc_id)>0) then begin
                          
                                                        
        -- UPDATE STOCK                                                                
        update "apouhkh" set "apouhkh"."Diauesimothta"="apouhkh"."Diauesimothta"+ 
        :multiplier*(select sum(grm."Posothta")
        from "pvlhseis" pvm,"grammes" grm                                                                  
                                                                                                 
        where pvm."Aa"=:created_doc_id
        and grm."Aapar"=pvm."Aa"
        and "apouhkh"."Aa"=grm."Eidos")
 
        where "apouhkh"."Aa" in
        (select grm."Eidos" from "pvlhseis" pvm,"grammes" grm                                         
        where pvm."Aa"=:created_doc_id
        and grm."Aapar"=pvm."Aa")     
        ;     
        
        
        -- DELETE OLD DOCUMENT LINES
        delete from "grammes" 
        where "grammes"."Aapar"=:created_doc_id
        ;
        
               -- DELETE OLD DOCUMENT LINES
        delete from "kinhseis" 
        where "kinhseis"."aapar"=:created_doc_id
        ;
        
    
        -- CREATE NEW DOCUMENT LINES
        insert into "grammes" ("grammes"."Aa","grammes"."Aapar","grammes"."Eidos","grammes"."KvdikosEidoys",
        "grammes"."PerigrafhEidoys","grammes"."fpa_","grammes"."Posothta","grammes"."Monada","grammes"."monada_",
        "grammes"."Timh","grammes"."Ekptvsh","grammes"."order"
        )
 
        select
        (select gen_id("gen_grammes_id", 1) as fname from RDB$DATABASE), 
        :created_doc_id,
        "apouhkh"."Aa","apouhkh"."Kvdikos",
        (case when "apouhkh"."Aa" is null then graa."PerigrafhEidoys" else "apouhkh"."Perigrafh" end),
        graa."fpa_",
        graa."Posothta",
        graa."Monada",graa."monada_",graa."Timh",graa."Ekptvsh",graa."order"
 
                                                                                                  
        from "pvlhseis" pvll,"grammes" graa
        left join "apouhkh" on "apouhkh"."Aa"= graa."Eidos"
        where pvll."Aa"=graa."Aapar"
        and pvll."Aa"=:aa
        -- and trim("apouhkh"."custom2")=:fromtitle
    
        ; 
          
            insert into "kinhseis"("Grammh","Baros","aapar") 
            
            select gr2."Aa",kin."Baros",gr2."Aapar"
            from "grammes" gr1,"grammes" gr2,"kinhseis" kin
            where gr1."Aapar"=:aa
            and  gr2."Aapar"=:created_doc_id
            and gr1."PerigrafhEidoys"=gr2."PerigrafhEidoys"
            and gr1."Aa"=kin."Grammh" 
            order by gr1."Aa",gr2."Aa"    
        
        ; 
                          
        
    end else begin
 
      
 
        -- CREATE NEW DOCUMENT
        insert into "pvlhseis" ("pvlhseis"."modified","pvlhseis"."Aa", "pvlhseis"."Ariumospar",
        "pvlhseis"."Hmeromhnia","pvlhseis"."Parastatiko","pvlhseis"."Sxetika")
        values ('Now',
        (select gen_id("gen_pvlhseis_id", 1) as fname from RDB$DATABASE),
        (select eid1."Ariumos" from "eidhpar" eid1 where eid1."Aa"=:newdocid2),
        'NOW',
        :newdocid2,
        (select substring(eid2."Parastatiko" from 1 for 3)||' '||pvl2."Seira"||'#'||pvl2."Ariumospar" from "pvlhseis" pvl2
        left join "eidhpar" eid2 on eid2."Aa"=pvl2."Parastatiko"
        where pvl2."Aa"=:aa)||' &T'||:aa||:fromtitle
        )    
        ;
             
        -- INCREMENT NUMBER TO DOCUMENT TYPE
        update "eidhpar" set "eidhpar"."Ariumos"="eidhpar"."Ariumos"+1 where "eidhpar"."Aa"= :newdocid2
        ;
                

        created_doc_id=(select pvl."Aa" from "pvlhseis" pvl where pvl."Sxetika" like '%&T'||:aa||:fromtitle) 
        ;
                
        -- CREATE NEW DOCUMENT LINES
        insert into "grammes" ("grammes"."Aa","grammes"."Aapar","grammes"."Eidos","grammes"."KvdikosEidoys",
        "grammes"."PerigrafhEidoys","grammes"."fpa_","grammes"."Posothta","grammes"."Monada","grammes"."monada_",
        "grammes"."Timh","grammes"."Ekptvsh","grammes"."order"
        )
 
        select
        (select gen_id("gen_grammes_id", 1) as fname from RDB$DATABASE), 
        :created_doc_id,
        "apouhkh"."Aa","apouhkh"."Kvdikos",
        (case when "apouhkh"."Aa" is null then graa."PerigrafhEidoys" else "apouhkh"."Perigrafh" end),
        graa."fpa_",
        graa."Posothta",
        graa."Monada",graa."monada_",graa."Timh",graa."Ekptvsh",graa."order"
                                                                                      
 
        from "pvlhseis" pvll,"grammes" graa
        left join "apouhkh" on "apouhkh"."Aa"= graa."Eidos"
        where pvll."Aa"=graa."Aapar"
        and pvll."Aa"=:aa
        -- and trim("apouhkh"."custom2")=:fromtitle
        ;              
     
    
            insert into "kinhseis"("Grammh","Baros","aapar") 
            
            select gr2."Aa",kin."Baros",gr2."Aapar"
            from "grammes" gr1,"grammes" gr2,"kinhseis" kin
            where gr1."Aapar"=:aa
            and  gr2."Aapar"=:created_doc_id
            and gr1."PerigrafhEidoys"=gr2."PerigrafhEidoys"
            and gr1."Aa"=kin."Grammh" 
            order by gr1."Aa",gr2."Aa"    
        
                 
        ;  
 
       
       
       
        
    end
 
                                       
                                       
                                       
 -- UPDATE STOCK
        update "apouhkh" set "apouhkh"."Diauesimothta"="apouhkh"."Diauesimothta"-
        :multiplier*(select sum(grm."Posothta")
        from "pvlhseis" pvm,"grammes" grm
 
        where pvm."Aa"=:created_doc_id
        and grm."Aapar"=pvm."Aa"
        and "apouhkh"."Aa"=grm."Eidos")
 
        where "apouhkh"."Aa" in
        (select grm."Eidos" from "pvlhseis" pvm,"grammes" grm
        where pvm."Aa"=:created_doc_id
        and grm."Aapar"=pvm."Aa")                                                                                
        ;                                            
 
     
 
-- UPDATE related document
update "pvlhseis" pvm set
 
pvm."modified"='Now',
pvm."Sxetiko"=:created_doc_id
 
where pvm."Aa"=:aa
 
;
 
-- UPDATE NEW DOCUMENT ADDING TOTALS
update "pvlhseis" pvm set
 
pvm."modified"='Now',
pvm."synolofpa_"=(select pvm2."synolofpa_" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."synolonpe_"=(select pvm2."synolonpe_" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."synolo_"=(select pvm2."synolo_" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."synoloposothtas_"=(select pvm2."synoloposothtas_" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."ogkos_syn"=(select pvm2."ogkos_syn" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."embado_syn"=(select pvm2."embado_syn" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."baros_syn"=(select pvm2."baros_syn" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."ajia_syn"=(select pvm2."ajia_syn" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."synolikopososto"=(select pvm2."synolikopososto" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."loipes_"=(select pvm2."loipes_" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."Plhrvmh"=(select pvm2."Plhrvmh" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."Hmeromhnia"=(select pvm2."Hmeromhnia" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."Sxolio"=(select pvm2."Sxolio" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."Tropos"=(select pvm2."Tropos" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."Skopos"=(select pvm2."Skopos" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."Kvdikospelath"=(select pvm2."Kvdikospelath" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),  -- customer id
pvm."Paradosh"=(select pvm2."Paradosh" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."assignor"=(select pvm2."assignor" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."Apostolh"=(select pvm2."Apostolh" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."custom1"=(select pvm2."custom1" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."custom2"=(select pvm2."custom2" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."Fortvsh"=(select pvm2."Fortvsh" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."voucher"=(select pvm2."voucher" from "pvlhseis" pvm2 where pvm2."Aa"=:aa),
pvm."Pinakida"=(select pvm2."Pinakida" from "pvlhseis" pvm2 where pvm2."Aa"=:aa)
-- ,pvm."Parastatiko"=:newdocid2
 
where pvm."Aa"=:created_doc_id

;
 
END;
 
-- doc-eof --   
