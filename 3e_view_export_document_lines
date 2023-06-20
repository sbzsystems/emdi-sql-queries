CREATE OR ALTER VIEW CC_DOCUMENT_LINES(
    DOCUMENTID,
    LINEID,
    LINENUMBER,
    SUPPLIERAFM,
    PRODUCTID,
    PROD_DESCRIPTION,
    SKU,
    DELIVERY_MU,
    PRICE,
    DELIVERY_QTY,
    QTYBASEMU,
    NET_AMOUNT,
    ALLOW_PERCENT1,
    ALLOW_AMOUNT1,
    ALLOW_PERCENT2,
    ALLOW_AMOUNT2,
    ALLOW_PERCENT3,
    ALLOW_AMOUNT3,
    TOTAL_ALLOWS,
    ALLOWQTY,
    ALLOWCUSTOMER,
    ALLOWPAYMENTTYPE,
    TAXABLE_AMOUNT,
    VAT_PERCENT,
    VAT_AMOUNT,
    TOTALVALUE,
    CREATIONDATE,
    MODIFIEDDATE)
AS
select 

"pvlhseis"."Aa" DocumentID,
"grammes"."Aa" LineID,
"grammes"."Aa" LineNumber,
null SupplierAfm,
"grammes"."Eidos" ProductID,
"grammes"."PerigrafhEidoys" prod_description,
"grammes"."KvdikosEidoys" sku,
(select "monades"."Monades" from "monades" where "monades"."Aa"="grammes"."Monada") delivery_mu,
(case eid."Emf_timvn" when 2 then -1 when 0 then 0 else 1 end)*"grammes"."Timh" price,
(case eid."Emf_timvn" when 2 then -1 else 1 end)*"Posothta" delivery_qty,
(case eid."Emf_timvn" when 2 then -1 else 1 end)*"Posothta" QtyBaseMU,
null net_amount,
null allow_percent1,
null allow_amount1,
null allow_percent2,
null allow_amount2,
null allow_percent3,
null allow_amount3,
null total_allows,
null AllowQty,
null AllowCustomer,
null AllowPaymentType,
(case eid."Emf_timvn" when 2 then -1 when 0 then 0 else 1 end)*"grammes"."Posothta"*("grammes"."Timh"-((cast("grammes"."Timh"*"grammes"."Ekptvsh" as double precision))/100)) taxable_amount,
round("grammes"."fpa_",2) vat_percent,
"grammes"."Timh"*"grammes"."fpa_"/100 vat_amount,
(case eid."Emf_timvn" when 2 then -1 when 0 then 0 else 1 end)*"grammes"."Posothta"*("grammes"."Timh"-((cast("grammes"."Timh"*"grammes"."Ekptvsh" as double precision))/100)+

(("grammes"."Timh"-((cast("grammes"."Timh"*"grammes"."Ekptvsh" as double precision))/100))* "grammes"."fpa_"  /100)

) TotalValue,

null CreationDate,
null ModifiedDate


from "grammes", "pvlhseis"

left join "pelates" as pel on "pvlhseis"."Kvdikospelath"=pel."Aa"
left join "poleis" as pol on pol."Aa"=pel."Polh"
left join "eidhpar" as eid on eid."Aa"="pvlhseis"."Parastatiko"
 
where
"grammes"."Aapar"="pvlhseis"."Aa"  and
("pvlhseis"."Ariumospar">-1)
and ((eid."Xrevstiko" in (1,6) and eid."Emf_timvn"=1)
or (eid."Xrevstiko" in (0,5) and eid."Emf_timvn"=2))

and exists (select first 1 apoi."Aa" from "apouhkh" apoi where apoi."Aa"="grammes"."Eidos" and apoi."custom1"='3E')
--and "pvlhseis"."Parastatiko"=6
--and    ("pvlhseis"."Hmeromhnia" >= '4/1/2022 00:00:00' and "pvlhseis"."Hmeromhnia" <= '4/30/2022 23:59:59')
;
