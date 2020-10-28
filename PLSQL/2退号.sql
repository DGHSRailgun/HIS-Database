CREATE DEFINER=`root`@`localhost` PROCEDURE `dropregister`(IN 挂号ID int,
                                                           OUT 结果 varchar(10))
BEGIN
  declare tempstatus int default 171;
-- 	select ContantName as '当前挂号状态' from Contant C join registrationinfo R0 on C.id = R0.VisitState where R0.id = 挂号ID;
	select VisitState from registrationinfo R where R.id = 挂号ID into tempstatus;
  #如果患者未就诊可以退号，否则不可以
	if tempstatus = 171
  then update registrationinfo R set VisitState = 174 where R.id = 挂号ID ;	
	end if;
	#判断是否修改成功
	if (select R1.VisitState from registrationinfo R1 where R1.id = 挂号ID) = 174
	then set 结果 = 'success';
	else set 结果 = 'failure';
	end if;
	
		
	
END