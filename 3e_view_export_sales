CREATE OR ALTER VIEW CC_DOCUMENT_HEADER(
    DOCUMENTID,
    REF_NUMBER,
    CREATIONDATE,
    MODIFIEDDATE,
    DISTRIBUTORAFM,
    GLN_RETAILER,
    AFM_RETAILER,
    NAME_RETAILER,
    ADDRESS_RETAILER,
    CITY_RETAILER,
    REGION_NAME_DELIVERY,
    ZIPCODE_RETAILER,
    MAIN_ACTIVITY,
    GLN_DELIVERYID,
    GLN_DELIVERY,
    ADDRESS_DELIVERY,
    CITY_DELIVERY,
    REGION_DELIVERY,
    ZIPCODE_DELIVERY,
    INV_TYPE,
    INV_SEC,
    INV_NUMBER,
    INV_DATE,
    CANCELATION,
    DOCUMENTID_CANCELING_INVOICE)
AS
select 
"pvlhseis"."Aa" DocumentID,

doc_abbreviation(eid."Parastatiko",coalesce( "pvlhseis"."Seira",'')||"Ariumospar") ref_number,
"pvlhseis"."Hmeromhnia" CreationDate,
"pvlhseis"."modified" ModifiedDate,
'000000000' DistributorAfm,
pel."Aa" GLN_retailer,
replace(pel."Afm",'EL','') afm_retailer,
coalesce(case when pel."Epvnymia"='' then null else pel."Epvnymia" end,coalesce(pel."Onoma"||' ','')||coalesce(pel."Epiueto",'')) name_retailer,
pel."Dieyuynsh" address_retailer,
pol."Onomasia" city_retailer,
pel."Perioxh" Region_Name_delivery,
pel."Tk" zipCode_retailer,
(select "epaggelmata"."Epaggelmata" from "epaggelmata" where "epaggelmata"."Aa"=pel."Epaggelma") Main_Activity,


case when "pvlhseis"."Paradosh" is null then "pvlhseis"."Kvdikospelath" else "pvlhseis"."Paradosh" end GLN_deliveryID,
case when "pvlhseis"."Paradosh" is null then pel."Aa" else (select "pelates"."Kvdikos" from "pelates" where "pelates"."Aa"="pvlhseis"."Paradosh") end GLN_delivery,
case when "pvlhseis"."Paradosh" is null then pel."Dieyuynsh" else (select "pelates"."Dieyuynsh" from "pelates" where "pelates"."Aa"="pvlhseis"."Paradosh") end address_delivery,


null city_delivery,
null region_delivery,
null zipCode_delivery,
eid."Parastatiko" inv_type,
"pvlhseis"."Seira" inv_sec,
"Ariumospar"  inv_number,
"pvlhseis"."Hmeromhnia" inv_date,
0 Cancelation,
null DocumentID_canceling_invoice

 
from "pvlhseis"
left join "pelates" as pel
on "pvlhseis"."Kvdikospelath"=pel."Aa"
left join "poleis" as pol
on pol."Aa"=pel."Polh"
left join "eidhpar" as eid
on eid."Aa"="pvlhseis"."Parastatiko"
 
where
("pvlhseis"."Ariumospar">-1)
and ((eid."Xrevstiko" in (1,6)  and eid."Emf_timvn"=1)
or (eid."Xrevstiko" in (0,5)  and eid."Emf_timvn"=2))


and exists (select first 1 apoi."Aa" from "apouhkh" apoi,"grammes" gri where apoi."Aa"=gri."Eidos" and apoi."custom1"='3E' and gri."Aapar"="pvlhseis"."Aa")
--and "pvlhseis"."Parastatiko"=6
--and    ("pvlhseis"."Hmeromhnia" >= '4/1/2022 00:00:00' and "pvlhseis"."Hmeromhnia" <= '4/30/2022 23:59:59')
;
