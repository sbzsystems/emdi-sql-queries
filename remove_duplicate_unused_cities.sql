-- ============================================================================
-- 6. MERGE DUPLICATES (by name AND country) - Execute Block
-- ============================================================================
-- This EXECUTE BLOCK will merge duplicates by name AND country:
--   1. Keeping the city with the lowest Aa (oldest)
--   2. Updating all references in pelates.Polh
--   3. Deleting duplicate city records
--
-- WARNING: Run this in a transaction! Test on a backup first!
-- UNCOMMENT THE BLOCK BELOW TO EXECUTE THE MERGE OPERATION
--
 EXECUTE BLOCK
 AS
 DECLARE VARIABLE keep_id INTEGER;
 DECLARE VARIABLE dup_id INTEGER;
 DECLARE VARIABLE city_name VARCHAR(1000);
 DECLARE VARIABLE country_code VARCHAR(4);
 BEGIN

     DELETE FROM "poleis"
     WHERE "poleis"."Aa" NOT IN (SELECT DISTINCT "pelates"."Polh" FROM "pelates" WHERE "pelates"."Polh" IS NOT NULL)
     and "poleis"."Aa">476 ;


     FOR SELECT
             MIN(p1."Aa") AS keep_id,
             p2."Aa" AS dup_id,
             p1."Onomasia" AS city_name,
             p1."country" AS country_code
         FROM "poleis" p1
         INNER JOIN "poleis" p2
             ON UPPER(TRIM(p1."Onomasia")) = UPPER(TRIM(p2."Onomasia"))
             AND COALESCE(p1."country", '') = COALESCE(p2."country", '')
             AND p1."Aa" <> p2."Aa"
         WHERE p1."Onomasia" IS NOT NULL
           AND TRIM(p1."Onomasia") <> ''
         GROUP BY p2."Aa", p1."Onomasia", p1."country"
         INTO :keep_id, :dup_id, :city_name, :country_code
     DO BEGIN
         -- Update all references in pelates table
         UPDATE "pelates"
         SET "Polh" = :keep_id
         WHERE "Polh" = :dup_id;

         -- Delete the duplicate city
         DELETE FROM "poleis"
         WHERE "Aa" = :dup_id;
     END
 END
