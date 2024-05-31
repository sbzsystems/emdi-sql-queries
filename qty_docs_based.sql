/*
Function: qty_docs_based
Purpose:
The function qty_docs_based calculates the sum of quantities for a specified product, considering certain types of documents that add to and subtract from the quantity.

Parameters:
product_aa (INTEGER): The identifier of the product whose quantity needs to be calculated.
add_docs (VARCHAR(1000)): A comma-separated list of document types that should add to the quantity.
subtract_docs (VARCHAR(1000)): A comma-separated list of document types that should subtract from the quantity.

Returns:
FLOAT: The calculated quantity of the specified product based on the provided document types.

Usage:
To use the function, you need to provide the product identifier and the document types that add to and subtract from the quantity.

Example:
SELECT qty_docs_based("apouhkh"."Aa",'133,125','135') FROM from "apouhkh"

This example calculates the quantity for the product with ID 123, adding quantities from document types 1, 2, 3 and subtracting quantities from document types 4, 5, 6.
*/

CREATE OR ALTER FUNCTION qty_docs_based (
    product_aa INTEGER,
    add_docs VARCHAR(1000),
    subtract_docs VARCHAR(1000)
)
RETURNS FLOAT
AS
DECLARE VARIABLE tmpqty FLOAT;
BEGIN
    execute statement '
    SELECT
        SUM(CASE WHEN "pvlhseis"."Parastatiko" IN (' || :add_docs || ') THEN 1 ELSE -1 END * "grammes"."Posothta")
    FROM 
        "grammes", "pvlhseis", "eidhpar"
    WHERE 
        "pvlhseis"."Parastatiko" IN (' || :add_docs || ',' || :subtract_docs || ')
        AND "grammes"."Aapar" = "pvlhseis"."Aa"
        AND "pvlhseis"."Parastatiko" = "eidhpar"."Aa"
        AND "grammes"."Eidos" = ' || :product_aa || '
        AND ("grammes"."KvdikosEidoys" <> '''')
        AND ("grammes"."KvdikosEidoys" IS NOT NULL)'
    INTO :tmpqty;
    
    if (tmpqty is null) then tmpqty=0;
    RETURN tmpqty;
END
