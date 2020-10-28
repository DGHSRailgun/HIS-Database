use his;
select distinct Name as '姓名',IDCardNO as '身份证号' 
from registrationinfo R
where R.Date >= '2019-04-01' and R.Date <= '2019-07-11'
group by R.IDCardNO having count(R.IDCardNO) >= 3                            
;
