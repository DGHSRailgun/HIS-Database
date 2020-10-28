use his;
select TrueName as '姓名', Q.num1 as '上班天数'
from users U join (select distinct count(DocID) num1,DocID
		               from (select distinct DocID,(select S1.Dates
		      														          from scheduling S1
																                where S1.id = S.id) as SD
					               from scheduling S ) A 
		               group by DocID						 
                   )  Q on Q.DocID = U.id
having Q.num1 > avg(Q.num1)
;