-- This script deletes duplicate rows in the "pvlhseis" table based on the "Sxetika" column.
-- It retains only the latest entry for each "Sxetika" within the last 3 months.
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

