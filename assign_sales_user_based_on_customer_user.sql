update "pvlhseis" set "pvlhseis"."Xrhsths"=
(select "pelates"."Xrhsths" from "pelates"  where "pelates"."Aa"="pvlhseis"."Kvdikospelath")

where

"pvlhseis"."Hmeromhnia">'2022-5-20' and

"pvlhseis"."Parastatiko" in
(select "eidhpar"."Aa" from "eidhpar" where "eidhpar"."Tameio"=1)
