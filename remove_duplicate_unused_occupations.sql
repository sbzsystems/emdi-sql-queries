-- ============================================================================
-- REMOVE UNUSED AND MERGE DUPLICATE OCCUPATIONS (by name)
-- ============================================================================
EXECUTE BLOCK
AS
DECLARE VARIABLE keep_id INTEGER;
DECLARE VARIABLE dup_id INTEGER;
BEGIN

    -- 1. Delete unused professions
    DELETE FROM "epaggelmata"
    WHERE "Aa" NOT IN (
        SELECT DISTINCT "pelates"."Epaggelma"
        FROM "pelates"
        WHERE "pelates"."Epaggelma" IS NOT NULL
    );

    -- 2. For each duplicated profession title
    FOR
        SELECT
            MIN(e1."Aa") AS keep_id,
            e2."Aa" AS dup_id
        FROM "epaggelmata" e1
        JOIN "epaggelmata" e2
          ON UPPER(TRIM(e1."Titlos")) = UPPER(TRIM(e2."Titlos"))
        WHERE e1."Aa" < e2."Aa"
          AND e1."Titlos" IS NOT NULL
          AND TRIM(e1."Titlos") <> ''
        GROUP BY e2."Aa"
        INTO :keep_id, :dup_id
    DO
    BEGIN
        -- 3. Update ALL customers
        UPDATE "pelates"
        SET "Epaggelma" = :keep_id
        WHERE "Epaggelma" = :dup_id;

        -- 4. Delete duplicate profession
        DELETE FROM "epaggelmata"
        WHERE "Aa" = :dup_id;
    END
END
