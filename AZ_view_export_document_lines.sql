CREATE OR ALTER VIEW CC_DOCUMENT_AZ(
    DOCUMENT_NUMBER,
	DOCUMENT_SERIES,
	DOCUMENT_TYPE,
	DOCUMENT_DATE,
	DISTRIBUTOR_AFM,
	DISTRIBUTOR_COMPANY,
	CUSTOMER_ID,
	CUSTOMER_AFM,
	CUSTOMER_COMPANY,
	CUSTOMER_ADDRESS,
	CUSTOMER_ZIP_CODE,
	DELIVERY_ADDRESS,
	DELIVERY_ZIP_CODE,
	PRODUCT_ID,
	PRODUCT_DESCRIPTION,
	PRODUCT_QUANTITY,
	PRODUCT_UNIT,
	DOCUMENT_ID,
	DOCUMENT_LINE_ID,
	DATE_UPDATED,
	DISTRIBUTOR_ID)
AS
select

"pvlhseis"."Ariumospar" Document_Number,
"pvlhseis"."Seira" Document_Series,
eid."Parastatiko" Document_Type,
"pvlhseis"."Hmeromhnia" Document_Date,
'802339877' Distributor_Afm,
'L&B ΛΕΚΑΡΑΚΟΣ Σ. - ΒΟΥΛΕΛΗΣ Δ. O.Ε.' Distributor_Company,
pel."Aa" Customer_ID,
replace(pel."Afm",'EL','') Customer_Afm,
coalesce(case when pel."Epvnymia"='' then null else pel."Epvnymia" end,coalesce(pel."Onoma"||' ','')||coalesce(pel."Epiueto",'')) Customer_Company,
pel."Dieyuynsh"||' '||pel."Perioxh" Customer_Address,
pel."Tk" Customer_Zip_Code,
case when "pvlhseis"."Paradosh" is null then pel."Dieyuynsh" else (select "pelates"."Dieyuynsh" from "pelates" where "pelates"."Aa"="pvlhseis"."Paradosh") end Delivery_Address,
null Delivery_Zip_Code,
"grammes"."KvdikosEidoys" Product_ID,
"grammes"."PerigrafhEidoys" Product_Description,
"grammes"."Posothta" Product_Quantity,
(select "monades"."Monades" from "monades" where "monades"."Aa"="grammes"."Monada") Product_Unit,
"pvlhseis"."Aa" Document_ID,
"grammes"."Aa" Document_Line_ID,
"pvlhseis"."modified" DATE_UPDATED,
'ΑΖ' Distributor_ID

from "grammes", "pvlhseis"
left join "pelates" as pel
on pel."Aa"="pvlhseis"."Kvdikospelath"
left join "eidhpar" as eid
on eid."Aa"="pvlhseis"."Parastatiko"
 
where
"grammes"."Eidos" is not null and
"grammes"."Aapar"="pvlhseis"."Aa" and
("pvlhseis"."Ariumospar">-1)
and ((eid."Xrevstiko" in (1,6)  and eid."Emf_timvn"=1)
or (eid."Xrevstiko" in (0,5)  and eid."Emf_timvn"=2))
and exists (select first 1 apoi."Aa" from "apouhkh" apoi where apoi."Aa"="grammes"."Eidos" and apoi."custom1"='ATHINAIKH' and "grammes"."Aapar"="pvlhseis"."Aa")
;