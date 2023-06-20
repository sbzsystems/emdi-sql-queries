CREATE OR ALTER VIEW CC_CUSTOMERS(
    CUSTOMERID,
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
    RECCATEGORY1,
    RECCATEGORY2,
    RECCATEGORY3)
AS
select

pel."Aa" CustomerID,
pel."Hmeromhnia" CreationDate,
pel."modified" ModifiedDate,
'000000000' DistributorAfm,
pel."Aa" GLN_retailer,
replace(pel."Afm",'EL','') afm_retailer,
coalesce(case when pel."Epvnymia"='' then null else pel."Epvnymia" end,coalesce(pel."Onoma"||' ','')||coalesce(pel."Epiueto",'')) name_retailer,
pel."Dieyuynsh" address_retailer,
pol."Onomasia" city_retailer,
pel."Perioxh" Region_Name_delivery,
pel."Tk" zipCode_retailer,
(select "epaggelmata"."Epaggelmata" from "epaggelmata" where "epaggelmata"."Aa"=pel."Epaggelma") Main_Activity,
null recCategory1,
null recCategory2,
null recCategory3

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

group by pel."Aa",pel."Hmeromhnia",pel."modified",pel."Afm",pel."Epvnymia",pel."Onoma",pel."Epiueto",pel."Dieyuynsh",pol."Onomasia",pel."Perioxh",pel."Tk",pel."Epaggelma",pel."Kvdikos"
;
