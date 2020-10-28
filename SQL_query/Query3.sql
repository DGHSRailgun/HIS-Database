use his;
select distinct DeptName as '科室名称'
from (department D join registrationinfo R on D.id = R.RegDepartID) join contant C
where R.VisitState = C.id and C.ConstantName = '待诊' 
                          and (select count(VisitState)
                               from registrationinfo R1
													  	 where R1.VisitState = C.id and C.ConstantName = '待诊') > 5
;