
ALTER TABLE "dikaivmata" DROP CONSTRAINT INTEG_544;

alter table "dikaivmata"
add constraint INTEG_544
primary key ("Aa");

ALTER TABLE "xrevseis" DROP CONSTRAINT INTEG_619;

alter table "xrevseis"
add constraint INTEG_619
primary key ("Aa");

ALTER TABLE "xrhstes" DROP CONSTRAINT INTEG_622;

alter table "xrhstes"
add constraint INTEG_622
primary key ("Aa");




execute block
returns (fieldname char(1000),fieldlength int)
as
declare cur cursor for 
  (

select T1.RDB$FIELD_NAME, T1.RDB$FIELD_LENGTH
from RDB$FIELDS T1, RDB$RELATION_FIELDS T2
where T1.RDB$FIELD_TYPE = 37 and
      T2.RDB$VIEW_CONTEXT is null and
      T1.RDB$FIELD_NAME = T2.RDB$FIELD_SOURCE and
      T1.RDB$CHARACTER_SET_ID<>4 and
      not T2.RDB$RELATION_NAME like 'RDB$%' and
      not T2.RDB$RELATION_NAME like 'MON$%'

  );


begin
  open cur;
  while (1=1) do
  begin

    fetch cur into fieldname, fieldlength;

          

update RDB$FIELDS set
RDB$CHARACTER_SET_ID = 4,
RDB$FIELD_LENGTH = :fieldlength*4,
RDB$CHARACTER_LENGTH = :fieldlength
where RDB$FIELD_NAME = :fieldname;




    if (row_count = 0) then leave;
    suspend;
  end
  close cur;
end;
