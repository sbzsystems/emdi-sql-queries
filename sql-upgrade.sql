-----------------------
----- SBZ systems -----
-- DB UPGRADE 12/2019 -
--------- UTF8 --------
-----------------------

ALTER CHARACTER SET UTF8 SET DEFAULT COLLATION UTF8;
ALTER TABLE "dikaivmata" ADD "limit_docs" VARCHAR(50);
	 
drop collation natural_order;
create collation natural_order for utf8 from unicode 'NUMERIC-SORT=1';

ALTER TABLE "relatedproducts" ADD "totalsaleprice" DP;
ALTER TABLE "relatedproducts" ADD "totalpurchaseprice" DP;

CREATE INDEX PELATES_IDX105 ON "pelates" COMPUTED BY ("pelates"."Epiueto"||"pelates"."Onoma"||"pelates"."Epvnymia");

CREATE INDEX RANTEVOU_IDX13 ON "rantevou" COMPUTED BY (cast("rantevou"."Ews" as date));
CREATE INDEX RANTEVOU_IDX14 ON "rantevou" COMPUTED BY (cast("rantevou"."maxtime" as date));
CREATE INDEX RANTEVOU_IDX15 ON "rantevou" COMPUTED BY (cast("rantevou"."mintime" as date));
CREATE INDEX RANTEVOU_IDX16 ON "rantevou" COMPUTED BY (cast("rantevou"."Hmeromhnia" as date));

alter table "rantevou" add "contact1" integer;
alter table "rantevou" add "contact2" integer;
alter table "rantevou" add "contact3" integer;
alter table "rantevou" add "contact4" integer;
alter table "rantevou" add "contact5" integer;
alter table "rantevou" add "contact6" integer;
alter table "rantevou" add "contact7" integer;
alter table "rantevou" add "contact8" integer;
alter table "rantevou" add "contact9" integer;
alter table "rantevou" add "contact10" integer;

CREATE INDEX RANTEVOU_IDX21 ON "rantevou" ("contact1");
CREATE INDEX RANTEVOU_IDX22 ON "rantevou" ("contact2");
CREATE INDEX RANTEVOU_IDX23 ON "rantevou" ("contact3");
CREATE INDEX RANTEVOU_IDX24 ON "rantevou" ("contact4");
CREATE INDEX RANTEVOU_IDX25 ON "rantevou" ("contact5");
CREATE INDEX RANTEVOU_IDX26 ON "rantevou" ("contact6");
CREATE INDEX RANTEVOU_IDX27 ON "rantevou" ("contact7");
CREATE INDEX RANTEVOU_IDX28 ON "rantevou" ("contact8");
CREATE INDEX RANTEVOU_IDX29 ON "rantevou" ("contact9");
CREATE INDEX RANTEVOU_IDX30 ON "rantevou" ("contact10");

ALTER TABLE "kinhseis" ALTER COLUMN "Merida" TYPE VARCHAR(30) CHARACTER SET UTF8;
ALTER TABLE "kinhseis" ALTER COLUMN "Stixos" TYPE VARCHAR(30) CHARACTER SET UTF8;
ALTER TABLE "pvlhseis" ALTER COLUMN "Sxolio" TYPE VARCHAR(150) CHARACTER SET UTF8;







alter table "apouhkh" add "custom21" varchar(30);
alter table "apouhkh" add "custom22" varchar(30);
alter table "apouhkh" add "custom23" varchar(30);
alter table "apouhkh" add "custom24" varchar(30);
alter table "apouhkh" add "custom25" varchar(30);
alter table "apouhkh" add "custom26" varchar(30);
alter table "apouhkh" add "custom27" varchar(30);
alter table "apouhkh" add "custom28" varchar(30);
alter table "apouhkh" add "custom29" varchar(30);
alter table "apouhkh" add "custom30" varchar(30);


CREATE INDEX APOUHKH_IDX71 ON "apouhkh" ("custom21"); 
CREATE INDEX APOUHKH_IDX72 ON "apouhkh" ("custom22"); 
CREATE INDEX APOUHKH_IDX73 ON "apouhkh" ("custom23"); 
CREATE INDEX APOUHKH_IDX74 ON "apouhkh" ("custom24"); 
CREATE INDEX APOUHKH_IDX75 ON "apouhkh" ("custom25"); 
CREATE INDEX APOUHKH_IDX76 ON "apouhkh" ("custom26"); 
CREATE INDEX APOUHKH_IDX77 ON "apouhkh" ("custom27"); 
CREATE INDEX APOUHKH_IDX78 ON "apouhkh" ("custom28"); 
CREATE INDEX APOUHKH_IDX79 ON "apouhkh" ("custom29"); 
CREATE INDEX APOUHKH_IDX80 ON "apouhkh" ("custom30"); 

CREATE DESCENDING INDEX APOUHKH_IDX81 ON "apouhkh" ("custom21"); 
CREATE DESCENDING INDEX APOUHKH_IDX82 ON "apouhkh" ("custom22"); 
CREATE DESCENDING INDEX APOUHKH_IDX83 ON "apouhkh" ("custom23"); 
CREATE DESCENDING INDEX APOUHKH_IDX84 ON "apouhkh" ("custom24"); 
CREATE DESCENDING INDEX APOUHKH_IDX85 ON "apouhkh" ("custom25"); 
CREATE DESCENDING INDEX APOUHKH_IDX86 ON "apouhkh" ("custom26"); 
CREATE DESCENDING INDEX APOUHKH_IDX87 ON "apouhkh" ("custom27"); 
CREATE DESCENDING INDEX APOUHKH_IDX88 ON "apouhkh" ("custom28"); 
CREATE DESCENDING INDEX APOUHKH_IDX89 ON "apouhkh" ("custom29"); 
CREATE DESCENDING INDEX APOUHKH_IDX90 ON "apouhkh" ("custom30"); 


ALTER TABLE "pvlhseis" ALTER COLUMN "ypografh" TYPE VARCHAR(400);


--ALTER TABLE "fpa" DROP "kvdikoseisrovn";
--ALTER TABLE "fpa" DROP "kvdikosekrovn";





-- MY DATA invoiceType    8.1 Είδη παραστατικών
ALTER TABLE "eidhpar" ADD "tax_docs" VARCHAR(12) CHARACTER SET UTF8; 
ALTER TABLE "eidhpar" ALTER COLUMN "tax_docs" TYPE VARCHAR(12);

-- MY DATA invoiceDetails vatCategory    8.2 Κατηγορία Φ.Π.Α.    9 δεκαδικά στο φπα
ALTER TABLE "fpa" ADD "tax_vat" SMALLINT;

-- MY DATA paymentMethodDetails type    8.12 Τρόποι Πληρωμής
ALTER TABLE "diakanonismos" ADD "tax_payment" SMALLINT;

-- MY DATA incomeClassification classificationType    8.9 Κωδικός Τύπου Χαρακτηρισμού Εσόδων
ALTER TABLE "eidhpar" ADD "tax_type" VARCHAR(10) CHARACTER SET UTF8;
ALTER TABLE "fpa" ADD "tax_type_revenues" VARCHAR(40) CHARACTER SET UTF8;
ALTER TABLE "fpa" ADD "tax_type_expenses" VARCHAR(40) CHARACTER SET UTF8;
ALTER TABLE "fpa" ALTER COLUMN "tax_type_revenues" TYPE VARCHAR(40);
ALTER TABLE "fpa" ALTER COLUMN "tax_type_expenses" TYPE VARCHAR(40);


-- MY DATA incomeClassification classificationCategory    8.8 Κωδικός Κατηγορίας Χαρακτηρισμού Εσόδων
ALTER TABLE "eidhpar" ADD "tax_category" VARCHAR(12) CHARACTER SET UTF8;

-- MY DATA invoiceUid 40 invoiceMark long
-- ALTER TABLE "pvlhseis" ADD "invoiceUid" VARCHAR(40) CHARACTER SET UTF8;
ALTER TABLE "pvlhseis" ADD "invoiceMark" BIGINT;
-- CREATE INDEX PVLHSEIS_IDX63 ON "pvlhseis" ("invoiceUid");
CREATE INDEX PVLHSEIS_IDX64 ON "pvlhseis" ("invoiceMark");

-- DROP INDEX PVLHSEIS_IDX63;
-- DROP INDEX PVLHSEIS_IDX64;
-- ALTER TABLE "pvlhseis" DROP "invoiceUid";
-- ALTER TABLE "pvlhseis" DROP "invoiceMark";

ALTER TABLE "fpa" ADD "title" VARCHAR(50) CHARACTER SET UTF8;

ALTER TABLE "tropos" ALTER COLUMN "senderid" TYPE VARCHAR(50);

ALTER TABLE "poleis" ADD "country" VARCHAR(4) CHARACTER SET UTF8;

ALTER TABLE "pvlhseis" ALTER COLUMN "custom1" TYPE VARCHAR(30);
ALTER TABLE "pvlhseis" ALTER COLUMN "custom2" TYPE VARCHAR(30);




ALTER TABLE "grammes" ALTER COLUMN "KvdikosEidoys" TYPE VARCHAR(50);
-- ALTER TABLE "grammes" ALTER COLUMN "PerigrafhEidoys" TYPE VARCHAR(150);

ALTER TABLE "apouhkh" ALTER COLUMN "Kvdikos" TYPE VARCHAR(50);
-- ALTER TABLE "apouhkh" ALTER COLUMN "Perigrafh" TYPE VARCHAR(150);


-- MY DATA incomeClassification classificationType    8.9 Κωδικός Τύπου Χαρακτηρισμού Εσόδων
-- alter table "apouhkh" add "tax_type" VARCHAR(10) CHARACTER SET UTF8;
-- alter table "apouhkh" add "accountingnumber" varchar(30);
-- alter table "apouhkh" add "accountingcode" smallint;



CREATE INDEX POLEIS_IDX2 ON "poleis" ("country");


 



ALTER TABLE "pvlhseis" ALTER COLUMN "Sxolio" TYPE VARCHAR(400);
ALTER TABLE "tropos" ALTER COLUMN "Titlos" TYPE VARCHAR(50);
ALTER TABLE "pelates" ALTER COLUMN "Email" TYPE VARCHAR(100);
ALTER TABLE "apouhkh" ALTER COLUMN "Omada" TYPE INTEGER;
ALTER TABLE "eidhpar" ALTER COLUMN "specialfieldstitles" TYPE VARCHAR(100) CHARACTER SET UTF8;

-- 28/04/2022

ALTER TABLE "pvlhseis" add "custom3" varchar(30);
ALTER TABLE "pvlhseis" add "custom4" varchar(30);
ALTER TABLE "pvlhseis" add "custom5" varchar(30);


alter table "apouhkh" add "custom31" varchar(30);
alter table "apouhkh" add "custom32" varchar(30);
alter table "apouhkh" add "custom33" varchar(30);
alter table "apouhkh" add "custom34" varchar(30);
alter table "apouhkh" add "custom35" varchar(30);
alter table "apouhkh" add "custom36" varchar(30);
alter table "apouhkh" add "custom37" varchar(30);
alter table "apouhkh" add "custom38" varchar(30);
alter table "apouhkh" add "custom39" varchar(30);
alter table "apouhkh" add "custom40" varchar(30);
alter table "apouhkh" add "custom41" varchar(30);
alter table "apouhkh" add "custom42" varchar(30);
alter table "apouhkh" add "custom43" varchar(30);
alter table "apouhkh" add "custom44" varchar(30);
alter table "apouhkh" add "custom45" varchar(30);
alter table "apouhkh" add "custom46" varchar(30);
alter table "apouhkh" add "custom47" varchar(30);
alter table "apouhkh" add "custom48" varchar(30);
alter table "apouhkh" add "custom49" varchar(30);
alter table "apouhkh" add "custom50" varchar(30);


CREATE INDEX APOUHKH_IDX91 ON "apouhkh" ("custom31"); 
CREATE INDEX APOUHKH_IDX92 ON "apouhkh" ("custom32"); 
CREATE INDEX APOUHKH_IDX93 ON "apouhkh" ("custom33"); 
CREATE INDEX APOUHKH_IDX94 ON "apouhkh" ("custom34"); 
CREATE INDEX APOUHKH_IDX95 ON "apouhkh" ("custom35"); 
CREATE INDEX APOUHKH_IDX96 ON "apouhkh" ("custom36"); 
CREATE INDEX APOUHKH_IDX97 ON "apouhkh" ("custom37"); 
CREATE INDEX APOUHKH_IDX98 ON "apouhkh" ("custom38"); 
CREATE INDEX APOUHKH_IDX99 ON "apouhkh" ("custom39"); 
CREATE INDEX APOUHKH_IDX100 ON "apouhkh" ("custom40"); 
CREATE INDEX APOUHKH_IDX101 ON "apouhkh" ("custom41"); 
CREATE INDEX APOUHKH_IDX102 ON "apouhkh" ("custom42"); 
CREATE INDEX APOUHKH_IDX103 ON "apouhkh" ("custom43"); 
CREATE INDEX APOUHKH_IDX104 ON "apouhkh" ("custom44"); 
CREATE INDEX APOUHKH_IDX105 ON "apouhkh" ("custom45"); 
CREATE INDEX APOUHKH_IDX106 ON "apouhkh" ("custom46"); 
CREATE INDEX APOUHKH_IDX107 ON "apouhkh" ("custom47"); 
CREATE INDEX APOUHKH_IDX108 ON "apouhkh" ("custom48"); 
CREATE INDEX APOUHKH_IDX109 ON "apouhkh" ("custom49"); 
CREATE INDEX APOUHKH_IDX110 ON "apouhkh" ("custom50"); 


CREATE DESCENDING INDEX APOUHKH_IDX111 ON "apouhkh" ("custom31"); 
CREATE DESCENDING INDEX APOUHKH_IDX112 ON "apouhkh" ("custom32"); 
CREATE DESCENDING INDEX APOUHKH_IDX113 ON "apouhkh" ("custom33"); 
CREATE DESCENDING INDEX APOUHKH_IDX114 ON "apouhkh" ("custom34"); 
CREATE DESCENDING INDEX APOUHKH_IDX115 ON "apouhkh" ("custom35"); 
CREATE DESCENDING INDEX APOUHKH_IDX116 ON "apouhkh" ("custom36"); 
CREATE DESCENDING INDEX APOUHKH_IDX117 ON "apouhkh" ("custom37"); 
CREATE DESCENDING INDEX APOUHKH_IDX118 ON "apouhkh" ("custom38"); 
CREATE DESCENDING INDEX APOUHKH_IDX119 ON "apouhkh" ("custom39"); 
CREATE DESCENDING INDEX APOUHKH_IDX120 ON "apouhkh" ("custom40"); 
CREATE DESCENDING INDEX APOUHKH_IDX121 ON "apouhkh" ("custom41"); 
CREATE DESCENDING INDEX APOUHKH_IDX122 ON "apouhkh" ("custom42"); 
CREATE DESCENDING INDEX APOUHKH_IDX123 ON "apouhkh" ("custom43"); 
CREATE DESCENDING INDEX APOUHKH_IDX124 ON "apouhkh" ("custom44"); 
CREATE DESCENDING INDEX APOUHKH_IDX125 ON "apouhkh" ("custom45"); 
CREATE DESCENDING INDEX APOUHKH_IDX126 ON "apouhkh" ("custom46"); 
CREATE DESCENDING INDEX APOUHKH_IDX127 ON "apouhkh" ("custom47"); 
CREATE DESCENDING INDEX APOUHKH_IDX128 ON "apouhkh" ("custom48"); 
CREATE DESCENDING INDEX APOUHKH_IDX129 ON "apouhkh" ("custom49"); 
CREATE DESCENDING INDEX APOUHKH_IDX130 ON "apouhkh" ("custom50"); 

-- 01/11/2023
 ALTER TABLE "settings" ALTER COLUMN "key" TYPE VARCHAR(200); 
 ALTER TABLE "dikaivmata" ALTER COLUMN "limit_docs" TYPE VARCHAR(100); 
 ALTER TABLE "custom_buttons" ALTER COLUMN "link" TYPE VARCHAR(300); 

-- 10/05/2024
ALTER TABLE "diakanonismos" ADD "tameio" INTEGER;
ALTER TABLE "pvlhseis" ADD "b2g" varchar(100);
ALTER TABLE "fpa" ADD "order" INTEGER;
ALTER TABLE "tropos" ADD "order" INTEGER;
ALTER TABLE "skopos" ADD "order" INTEGER;
