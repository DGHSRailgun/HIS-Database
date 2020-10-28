use his;
select 
			sum(case when (P.ItemUnitPrice * P.Amount > 0) then P.ItemUnitPrice * P.Amount else 0 end) as '缴费总和', 
			sum(case when (P.ItemUnitPrice * P.Amount < 0) then -(P.ItemUnitPrice * P.Amount) else 0 end) as '退费总和'                
from patientfeedetail P
;