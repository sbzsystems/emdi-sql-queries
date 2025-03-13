-- This script deletes all duplicate rows based on "Sxetika" and keeps only the latest
-- Keep only the latest document per "Sxetika" from the last 3 months and delete the rest
DELETE FROM "pvlhseis"
WHERE "pvlhseis"."Aa" NOT IN (
    SELECT MAX(p."Aa")
    FROM "pvlhseis" p
    WHERE p."Parastatiko" = 7
      AND p."Sxetika" IS NOT NULL
      AND p."Sxetika" <> ''
      AND p."Hmeromhnia" >= DATEADD(-90 DAY TO CURRENT_DATE)
    GROUP BY p."Sxetika"
)
AND "pvlhseis"."Parastatiko" = 7
AND "pvlhseis"."Sxetika" IS NOT NULL
AND "pvlhseis"."Sxetika" <> ''
AND "pvlhseis"."Hmeromhnia" >= DATEADD(-90 DAY TO CURRENT_DATE);

