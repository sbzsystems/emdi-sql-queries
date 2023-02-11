create or alter function DOC_ABBREVIATION (
    DOCTITLE varchar(1000),
    DOCNUMBER varchar(1000))
returns varchar(1000)
as
declare q varchar(100);
declare i int;
declare countc int;
begin

q=DOCTITLE;

i=1;
countc=0;
while (i<=char_length(q)) do begin
    if (substring(q from i for 1) = ' ') then countc=countc+1;
    i=i+1;
end

q=replace(q,'(','');
q=replace(q,')','');
q=replace(q,' - ','');

if (countc=0) then q=left(split_string(q,' ',1),3)||' '||DOCNUMBER;
if (countc=1) then q=left(split_string(q,' ',1),1)||left(split_string(q,' ',2),3)||' '||DOCNUMBER;
if (countc>1) then q=left(split_string(q,' ',1),1)||left(split_string(q,' ',2),1)||left(split_string(q,' ',3),1)||' '||DOCNUMBER;

return q;

end
