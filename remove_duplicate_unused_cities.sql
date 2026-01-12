-- ============================================================================
-- 6. REMOVE UNUSED AND MERGE DUPLICATES CITIES (by name AND country)
-- ============================================================================
EXECUTE BLOCK
AS
DECLARE VARIABLE keep_id INTEGER;
DECLARE VARIABLE dup_id INTEGER;
BEGIN

    -- 1. Delete unused cities
    DELETE FROM "poleis"
    WHERE "Aa" NOT IN (
        SELECT DISTINCT "pelates"."Polh"
        FROM "pelates"
        WHERE "pelates"."Polh" IS NOT NULL
    )
    AND "Aa" > 476;

    -- 2. For each duplicated city group
    FOR
        SELECT
            MIN(p1."Aa") AS keep_id,
            p2."Aa" AS dup_id
        FROM "poleis" p1
        JOIN "poleis" p2
          ON UPPER(TRIM(p1."Onomasia")) = UPPER(TRIM(p2."Onomasia"))
         AND COALESCE(p1."country", '') = COALESCE(p2."country", '')
        WHERE p1."Aa" < p2."Aa"
          AND p1."Onomasia" IS NOT NULL
          AND TRIM(p1."Onomasia") <> ''
        GROUP BY p2."Aa"
        INTO :keep_id, :dup_id
    DO
    BEGIN
        -- 3. Update ALL customers
        UPDATE "pelates"
        SET "Polh" = :keep_id
        WHERE "Polh" = :dup_id;

        -- 4. Delete duplicate city
        DELETE FROM "poleis"
        WHERE "Aa" = :dup_id;
    END
END

