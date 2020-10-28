CREATE DEFINER=`root`@`localhost` PROCEDURE `Drop`(IN 处方ID int,
                                                   IN 操作员ID int,
																									 IN 发票号 int,
																									 OUT 结果 varchar(10))
BEGIN
  declare cur int default 1;
	declare tempStatus int default 0;
	declare tempMediDetailID int default 0;
	declare maxline int default 0;
	declare avaliableInvoiceNum int default 000000;
	declare tempInvID int default 0;
	declare tempRegID int default 0;
	declare tempDrugID int default 0;
	declare tempAmount int default 0;
	declare tempDrugName varchar(100);
	declare tempDrugsPrice float;
	declare tempPrice float default 0.0;
	select P.RegID from patientmediprescription P where P.id = 处方ID into tempRegID;
	select PD.id from patientmedipredetail PD where PD.MediPrescriptionID = 处方ID limit 0,1 into cur;
	select count(*) from patientmedipredetail P where P.MediPrescriptionID = 处方ID into maxline;
	select P.PrescriptionStatus from patientmediprescription P where P.id = 处方ID into tempStatus;
	
	
	if tempStatus != 2 and tempStatus != 3 and tempStatus != 4
	then set 结果 = 'failure';
	
	else
	set 结果 = 'success';
	set tempMediDetailID = cur;
	
	update patientmedipredetail PD set PD.`Status` = 5 where PD.MediPrescriptionID = 处方ID;
	update patientmediprescription P set PrescriptionStatus = 5 where P.id = 处方ID;
	#获取可用冲红发票号
	select max(InvNum)+1 from Invoice into avaliableInvoiceNum;
	#新建发票
	insert into invoice(InvNum
	                    ) values (avaliableInvoiceNum);
	select id from Invoice where InvNum = avaliableInvoiceNum into tempInvID;
	
	repeat   
	
	select PD.DrugID from patientmedipredetail PD where PD.MediPrescriptionID = 处方ID and PD.id = tempMediDetailID into tempDrugID;
	select DrugsName from Drugs where id = tempDrugID into tempDrugName;
	select DrugsPrice from Drugs where id = tempDrugID into tempDrugsPrice;
	select Amount from patientmedipredetail where id = tempMediDetailID into tempAmount;
	
	#新建患者费用明细
	insert into patientfeedetail(RegID,
															 InvoiceID,
															 ItemID,
															 ItemType,
															 ItemName,
															 ItemUnitPrice,
															 Amount,
															 ExpDepID,
															 OpenTime,
															 OpenerID,
															 `Cha/RefTime`,
															 `Cha/ReferID`,
															 ChargeMethod
	                             ) values (tempRegID,tempInvID,tempDrugID,1,tempDrugName,
															           -tempDrugsPrice,tempAmount,null,now(),9,now(),9,51);
  #记录发票金额累计
	set tempPrice = tempPrice + tempDrugsPrice * tempAmount;
	set tempMediDetailID = tempMediDetailID + 1;
	
	
	until tempMediDetailID = cur + maxline
	end repeat;
	
	#根据患者费用明细更新发票
	update invoice I set InvAmount = -tempPrice where I.id = tempInvID;
  update invoice I set Time = now() where I.id = tempInvID;
	update invoice I set InvStatus = 7 where I.id = tempInvID;
	update invoice I set RefToChaInvoiceNo = 发票号 where I.id = tempInvID;
  update invoice I set `Cha/RefEmployeeID` = 9 where I.id = tempInvID;
  update invoice I set RegID = tempRegID where I.id = tempInvID;
  update invoice I set ChaTypeID = 51 where I.id = tempInvID;
  update invoice I set InvProStatus = 0 where I.id = tempInvID;
	update invoice I set `Delete` = 1 where I.id = tempInvID;


	
	end if;
	

END