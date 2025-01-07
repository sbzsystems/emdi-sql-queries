/*
Here's a quick explanation of the input parameters and the function's behavior:

    1. product_id: The ID of the product you want to fetch the latest purchase price for.
    2. after_discount: A boolean flag indicating whether the price should be returned after applying the discount (true) or the original price without the discount (false).
    3. customer_id: The ID of the customer you want to filter the results by. If this parameter is null, the function will not filter by customer.
    
    Example:
    SELECT GET_LATEST_SALE_PRICE(8594, true, 123) FROM RDB$DATABASE;    
*/


CREATE or alter FUNCTION GET_LATEST_SALE_PRICE (product_id INTEGER,after_discount boolean,customer_id integer)
RETURNS DOUBLE PRECISION
AS
 declare tim DOUBLE PRECISION;
 declare Timh DOUBLE PRECISION;
 declare Ekptvsh DOUBLE PRECISION;
 declare Kvdikospelath INTEGER;

BEGIN
  
    SELECT FIRST 1
      ("Timh" - (("Timh" * "Ekptvsh") / 100)) AS tim,
      "Timh", "Ekptvsh", "pvlhseis"."Kvdikospelath"
    FROM
      "grammes",
      "pvlhseis",
      "eidhpar"
    WHERE
      "grammes"."Aapar" = "pvlhseis"."Aa"
      AND "pvlhseis"."Parastatiko" = "eidhpar"."Aa"
      AND ("eidhpar"."Xrevstiko" = 1 OR "eidhpar"."Xrevstiko" = 6)
      AND "eidhpar"."Emf_timvn" IN (1, 3)
      AND "grammes"."Eidos" = :product_id
      AND ("pvlhseis"."Aa" = :customer_id or :customer_id is null)
      AND ("pvlhseis"."Hmeromhnia" <= 'NOW')
      AND (
        ("eidhpar"."related_products" = 2 AND "grammes"."type" = 1)
        OR ("eidhpar"."related_products" = 3 AND "grammes"."type" = 2)
        OR "eidhpar"."related_products" < 2
        OR "eidhpar"."related_products" IS NULL
        OR "grammes"."type" IS NULL
        OR "grammes"."type" < 1
      )
    ORDER BY
      "pvlhseis"."Hmeromhnia" DESC,
      "grammes"."order" DESC
    INTO
      :tim,
      :Timh,
      :Ekptvsh,
      :Kvdikospelath  ;
 
 if (after_discount) then  return tim;
   else return Timh;
    
END
