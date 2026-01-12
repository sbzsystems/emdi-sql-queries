DELETE FROM "poleis"
WHERE "poleis"."Aa" NOT IN (SELECT DISTINCT "pelates"."Polh" FROM "pelates" WHERE "pelates"."Polh" IS NOT NULL)
and "poleis"."Aa">476
