/*
Overview and Steps

    Initialization:
        Define dd as the new document id.
        Define loy as the product code for receiving money.
        Define cpaym as the current payment id.

    Condition Checks:
        Check if the customer ID is not zero and the payment method is not credit.
        Ensure that the query's conditions return expected results.

    Updating or Inserting Document Lines:
        If a related sale exists, update the document line.
        If no related sale exists, create a new document and document line.

    Updating Totals for the New Document:
        Calculate and update totals for the document based on the inserted or updated lines.

    Updating Current Payment:
        Change the current payment method.
*/




EXECUTE BLOCK AS
declare dd int = 58; -- new document id    
declare loy varchar(10) = 'ΕΙΣ'; -- code of product for receive money
-- declare paym int = 1; -- new payment id
declare cpaym int = 10; -- current payment id   ΠΙΣΤΩΣΗ
begin        
                                                                       
    --IF CUSTOMER ID IS NOT 0 AND PAYMENT WAY NOT CREDIT
    if ((:cl>0)
    and
    ((select diak."Ejoflhuh" from "diakanonismos" diak,"pvlhseis" ppl where ppl."Plhrvmh"=diak."Aa" and ppl."Aa"=:aa)=1))
 
    THEN BEGIN
        
        if ((select count("pvlhseis"."Aa") from "pvlhseis" where "pvlhseis"."Aa"=(select pvl."Aa" from "pvlhseis" pvl where pvl."Sxetika" like '%&'||:aa))>0) then begin
            
            --UPDATE DOCUMENT LINE INCLUDED ONE PRODUCT WITH ID 'LOY'
            update "grammes" set
            "grammes"."Aa"=(select gen_id("gen_grammes_id", 1) as fname from RDB$DATABASE),
            "grammes"."Aapar"=(select pvl1."Aa" from "pvlhseis" pvl1 where pvl1."Sxetika" like '%&'||:aa),
            "grammes"."Eidos"=(select apo1."Aa" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
            "grammes"."KvdikosEidoys"=(select apo1."Kvdikos" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
            "grammes"."PerigrafhEidoys"=(select apo1."Perigrafh" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
            "grammes"."fpa_"=(select apo1."fpaT" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
            "grammes"."Posothta"=1,
            "grammes"."Monada"=(select apo1."Monada" from "apouhkh" apo1 where apo1."Kvdikos"=:loy),
            "grammes"."monada_"=(select "monades"."Monades" from "apouhkh" apo1 left join "monades" on "monades"."Aa"=apo1."Monada" where apo1."Kvdikos"=:loy),
            "grammes"."Timh"=   
            
                                                                           
 
            coalesce(
                (select ppl."synolo_" from "pvlhseis" ppl where ppl."Aa"=:aa)
            ,0)                                                                                   
            
            
                                                               
            ,
            "grammes"."Ekptvsh"=0,
            "grammes"."order"=0
            
            where "grammes"."Aapar"=(select pvl."Aa" from "pvlhseis" pvl where pvl."Sxetika" like '%&'||:aa)                                                                                     
            ;
            
            end else begin
            
                                                                                                           
            
            --CREATE NEW DOCUMENT WITH LINE ID
            insert into "pvlhseis" ("pvlhseis"."Aa", "pvlhseis"."Ariumospar","pvlhseis"."Kvdikospelath",
            "pvlhseis"."Hmeromhnia","pvlhseis"."Parastatiko","pvlhseis"."Sxetika" )
            values (
                (select gen_id("gen_pvlhseis_id", 1) as fname from RDB$DATABASE),
                (select eid1."Ariumos" from "eidhpar" eid1 where eid1."Aa"=:dd),
                (select pvl1."Kvdikospelath" from "pvlhseis" pvl1 where pvl1."Aa"=:aa),
                  
                                   
                                        
                                        
                                        
                                        
                (CASE WHEN
                    CAST((select
                    split_string( split_string(pvl1."Sxolio" ,' ',2) , '/', 3)||'-'||
                    split_string( split_string(pvl1."Sxolio" ,' ',2) , '/', 2)||'-'||
                    split_string( split_string(pvl1."Sxolio" ,' ',2) , '/', 1)
                    from "pvlhseis" pvl1 where pvl1."Aa"=:aa) AS TIMESTAMP) IS NULL THEN CURRENT_TIMESTAMP
                    ELSE                                        
                                                                                                                                                               
                    (select
                    split_string( split_string(pvl1."Sxolio" ,' ',2) , '/', 3)||'-'||
                    split_string( split_string(pvl1."Sxolio" ,' ',2) , '/', 2)||'-'||
                    split_string( split_string(pvl1."Sxolio" ,' ',2) , '/', 1)                                                                                                          
                    
                    ||' '||
                    EXTRACT(HOUR FROM dateadd(10 second to pvl1."Hmeromhnia"))||':'||
                    EXTRACT(MINUTE FROM dateadd(10 second to pvl1."Hmeromhnia"))||':'||
                    EXTRACT(SECOND FROM dateadd(10 second to pvl1."Hmeromhnia"))
                    
                    
                    from "pvlhseis" pvl1 where pvl1."Aa"=:aa)                    
                    END)
                                                                                                                                                    
                
                
                
                ,:dd,
                (select substring(eid2."Parastatiko" from 1 for 3)||' '||pvl2."Seira"||'#'||pvl2."Ariumospar" from "pvlhseis" pvl2
                    left join "eidhpar" eid2 on eid2."Aa"=pvl2."Parastatiko"
                where pvl2."Aa"=:aa)||' &'||:aa
 
            )
            ;
            
            
            --CREATE NEW DOCUMENT LINE INCLUDED ONE PRODUCT WITH ID 'LOY'
            insert into "grammes" ("grammes"."Aa","grammes"."Aapar","grammes"."Eidos","grammes"."KvdikosEidoys",
                "grammes"."PerigrafhEidoys","grammes"."fpa_","grammes"."Posothta","grammes"."Monada","grammes"."monada_",
                "grammes"."Timh","grammes"."Ekptvsh","grammes"."order"
            )
            values(
                (select gen_id("gen_grammes_id", 1) as fname from RDB$DATABASE),
                (select pvl1."Aa" from "pvlhseis" pvl1 where pvl1."Sxetika" like '%&'||:aa),
                
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

             --INCREMENT NUMBER TO DOCUMENT TYPE WITH LINE ID
            update "eidhpar" set "eidhpar"."Ariumos"="eidhpar"."Ariumos"+1 where "eidhpar"."Aa"= :dd
            ;                                                                                                                     
        end                            
 
 
 
                                                                                           
        
        --UPDATE NEW DOCUMENT ADDING TOTALS
        update "pvlhseis" pvm set                                 
        
        -- pvm."synolofpa_"=
        -- (select
        --     (((gra ."Posothta"* gra."Timh")* gra."fpa_"   )/100) from
        --     "grammes" gra where gra."Aapar"=pvm."Aa"               
        -- ),                                                                               
                        
        -- pvm."synolonpe_"=
        -- (select
        --     (((gra ."Posothta"* gra."Timh")* gra."fpa_"   )/100) from
        --     "grammes" gra where gra."Aapar"=pvm."Aa"
        -- ),
        
        pvm."synolo_"=
        (select (gra ."Posothta"* gra."Timh")
            +    (((gra ."Posothta"* gra."Timh")* gra."fpa_"   )/100) from
            "grammes" gra where gra."Aapar"=pvm."Aa"
        ),
        
        pvm."synoloposothtas_"=
        (select floor(gra ."Posothta") from                                                                                
            "grammes" gra where gra."Aapar"=pvm."Aa"
        ),

       pvm."synolofpa_"= (select (gra ."Posothta"* gra."Timh")
            +    (((gra ."Posothta"* gra."Timh")* gra."fpa_"   )/100) from
            "grammes" gra where gra."Aapar"=pvm."Aa"
        ),                                                  
       pvm."synolonpe_"= (select (gra ."Posothta"* gra."Timh")
            +    (((gra ."Posothta"* gra."Timh")* gra."fpa_"   )/100) from
            "grammes" gra where gra."Aapar"=pvm."Aa"
        ),
                                                                                                    
 
        --pvm."Plhrvmh"=:paym                                                           
        pvm."Plhrvmh"=(select pvi."Plhrvmh" from "pvlhseis" pvi where pvi."Aa"=:aa)      
                 
        
        ,                                                                                            
        pvm."ogkos_syn"=0,pvm."embado_syn"=0,pvm."baros_syn"=0,pvm."ajia_syn"=0,pvm."synolikopososto"=0,pvm."loipes_"=0
        where pvm."Aa"=(select pvl."Aa" from "pvlhseis" pvl where pvl."Sxetika" like '%&'||:aa)
        
        ;
        
        --change current payment
        update "pvlhseis" set "pvlhseis"."Plhrvmh"=:cpaym,      
        "Sxetiko"=(select pvl1."Aa" from "pvlhseis" pvl1 where pvl1."Sxetika" like '%&'||:aa)
        where "pvlhseis"."Aa"=:aa
            ;
        END                                                                                 
        END;                    
