use his;
select truename as '真实姓名'
from (users US join department D) join reglevel Regl
where US.DepartmentID = D.id and US.RegistrationLevelID = Regl.id
														 and D.DeptName = '心血管内科'
														 and Regl.RegName = '专家号'
;