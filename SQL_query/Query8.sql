use his;
select TrueName as '姓名'
from users U join contant C on U.DoctorTitleID = C.id
where C.ConstantName in ('主任医师','副主任医师')
;