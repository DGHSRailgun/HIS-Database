use his;
select Date as '日期',count(Date) as '看诊人数'
from registrationinfo R
group by Date
order by count(Date) desc
;