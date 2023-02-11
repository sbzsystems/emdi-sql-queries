execute block
as
declare I int = 0;
begin

  while (I < 150) do
  begin

    if ((select count(PPL."Aa")
         from "pvlhseis" PPL, "grammes" GGR
         where GGR."Aapar" = PPL."Aa" and
               PPL."Sxetiko" = :aa) > :I) then
    begin

      if ((select first 1 skip (:I) GGR."Eidos"
           from "pvlhseis" PPL, "grammes" GGR
           where GGR."Aapar" = PPL."Aa" and
                 PPL."Sxetiko" = :aa) in (select GGR."Eidos"
                                          from "grammes" GGR
                                          where GGR."Aapar" = :aa)) then
      begin

        update or insert into "kinhseis" ("kinhseis"."Grammh", "kinhseis"."aapar", "kinhseis"."Uesh")
        values ((
        select first 1 skip (:I) GGR."Aa"
        from "pvlhseis" PPL, "grammes" GGR
        where GGR."Aapar" = PPL."Aa" and
              PPL."Sxetiko" = :aa), (
        select PPL."Aa"
        from "pvlhseis" PPL
        where PPL."Sxetiko" = :aa), 'GONE');

      end

    end
    else
      suspend;

    I = I + 1;
  end

end
