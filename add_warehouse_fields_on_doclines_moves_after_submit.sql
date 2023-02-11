-- doc --
execute block
as
declare I int = 0;
declare countc int = 0;
begin


	countc=(select count(PPL."Aa")
         from "pvlhseis" PPL, "grammes" GGR
         where GGR."Aapar" = PPL."Aa" and
               PPL."Aa" = :aa);

  while (I < countc) do
  begin

 
      if ((select first 1 skip (:I) GGR."Eidos"
           from "pvlhseis" PPL, "grammes" GGR
           where GGR."Aapar" = PPL."Aa" and
                 PPL."Aa" = :aa) in (select GGR."Eidos"
                                          from "grammes" GGR
                                          where GGR."Aapar" = :aa)) then
      begin

        update or insert into "kinhseis" ("kinhseis"."Grammh", "kinhseis"."aapar", "kinhseis"."Uesh", "kinhseis"."Merida")
        values ((
        select first 1 skip (:I) GGR."Aa"
        from "pvlhseis" PPL, "grammes" GGR
        where GGR."Aapar" = PPL."Aa" and
              PPL."Aa" = :aa), (
        select PPL."Aa"
        from "pvlhseis" PPL
        where PPL."Aa" = :aa), 
		
		(select round("apouhkh"."Diauesimothta",0) from "apouhkh" where "apouhkh"."Aa"=
		(
        select first 1 skip (:I) GGR."Eidos"
        from "pvlhseis" PPL, "grammes" GGR
        where GGR."Aapar" = PPL."Aa" and
              PPL."Aa" = :aa)), 
		
		
		(select "apouhkh"."custom4" from "apouhkh" where "apouhkh"."Aa"=
		(
        select first 1 skip (:I) GGR."Eidos"
        from "pvlhseis" PPL, "grammes" GGR
        where GGR."Aapar" = PPL."Aa" and
              PPL."Aa" = :aa))
		
		
		);

      end

 
    else
      suspend;

    I = I + 1;
  end

end
-- doc-eof --
