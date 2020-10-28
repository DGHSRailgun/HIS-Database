select distinct TrueName as '姓名'
from users U join scheduling S on U.id = S.DocID
where Dates >= '2019-04-01' and Dates <= '2019-04-30' 
                           and (select count(*)
													      from scheduling S1
																where U.id = S1.DocID) > 7				
;