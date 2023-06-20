CREATE OR ALTER VIEW CC_PRODUCTS(
    PRODUCTID,
    SUPPLIERAFM,
    CREATIONDATE,
    MODIFIEDDATE,
    DISTRIBUTORAFM,
    SKU,
    PROD_DESCRIPTION,
    DELIVERY_MU,
    DELIVERY_MU2,
    DELIVERY_CAPACITY,
    SUPPLIER_SKU,
    EAN_CU)
AS
select
"grammes"."Eidos" ProductID,
null SupplierAfm,
(select "apouhkh"."Hmeromhnia" from "apouhkh" where "apouhkh"."Aa"="grammes"."Eidos") CreationDate,
(select "apouhkh"."modified" from "apouhkh" where "apouhkh"."Aa"="grammes"."Eidos") ModifiedDate,
'0000000' DistributorAfm,
max("grammes"."KvdikosEidoys") sku,
max("grammes"."PerigrafhEidoys") prod_description,
(select "monades"."Monades" from "monades" where "monades"."Aa"=max("grammes"."Monada")) delivery_mu,
null delivery_mu2,
null delivery_capacity,
null supplier_sku,
null EAN_cu


from "grammes", "pvlhseis"

left join "pelates" as pel on "pvlhseis"."Kvdikospelath"=pel."Aa"
left join "poleis" as pol on pol."Aa"=pel."Polh"
left join "eidhpar" as eid on eid."Aa"="pvlhseis"."Parastatiko"
 
where
"grammes"."Eidos" is not null and
"grammes"."Aapar"="pvlhseis"."Aa"  and
("pvlhseis"."Ariumospar">-1)
and ((eid."Xrevstiko" in (1,6) and eid."Emf_timvn"=1)
or (eid."Xrevstiko" in (0,5) and eid."Emf_timvn"=2))


and exists (select first 1 apoi."Aa" from "apouhkh" apoi where apoi."Aa"="grammes"."Eidos" and apoi."custom1"='3E')
group by "grammes"."Eidos"
;
