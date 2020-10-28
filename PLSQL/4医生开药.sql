CREATE DEFINER=`root`@`localhost` PROCEDURE `Prescribe`(IN 挂号ID int,
																												IN 处方名称 longtext,
																												IN 处方状态 int,
																												IN 药品信息 varchar(10000),
																												OUT 结果 varchar(10)
																												)
BEGIN

  #输入药品信息要按照`药品ID`,`用法`,`用量`,`频次`,`数量`,输入 注意输入英文逗号
  declare tempMediBookID int default 0;
	declare tempDocID int default 0;
	declare tempMediID int default 0;
	declare tempString varchar(10000) default null;
	declare tempDrugID int default 0;
	declare tempUsage varchar(10000) default null;
	declare tempConsumption varchar(10000) default null;
	declare tempFrequency varchar(10000) default null;
	declare tempAmount int default 0;
	declare cur int default 0;

  select P.id from patienthomepage P where P.RegID = 挂号ID into tempMediBookID;
	select R.RegDocID from registrationinfo R where R.id = 挂号ID into tempDocID;
	set tempString = 药品信息;
	set 结果 = 'success';
	if tempMediBookID != 0
	then insert into patientmediprescription(MedicalRecordID,
																					 RegID,
																					 OpenDocID,
																				   PrescriptionName,
																					 OpenTime,
																					 PrescriptionStatus,
																					 `Delete`
																					 ) values(tempMediBookID,挂号ID,tempDocID,处方名称,now(),处方状态,1);
	else set 结果 = 'failure';																				 
	end if;
	
	select max(P.id) from patientmediprescription P into tempMediID;
	
	repeat
	#根据“，”逗号来拆分字符串，此处利用 SUBSTRING_INDEX（str, delim, count） 函数，最后把结果赋值给相应字段
  select substring_index(substring_index(tempString,',',help_topic_id + 1),',',-1) 
	from mysql.help_topic 
	where help_topic_id = cur 
	into tempDrugID;
	#游标自增
  set cur = cur + 1;
	
	select substring_index(substring_index(tempString,',',help_topic_id + 1),',',-1) 
	from mysql.help_topic 
	where help_topic_id = cur 
	into tempUsage;
  set cur = cur + 1;
	
  select substring_index(substring_index(tempString,',',help_topic_id + 1),',',-1) 
	from mysql.help_topic 
	where help_topic_id = cur 
	into tempConsumption;
  set cur = cur + 1;
	
	select substring_index(substring_index(tempString,',',help_topic_id + 1),',',-1) 
	from mysql.help_topic 
	where help_topic_id = cur 
	into tempFrequency;
  set cur = cur + 1;
	
	select substring_index(substring_index(tempString,',',help_topic_id + 1),',',-1) 
	from mysql.help_topic 
	where help_topic_id = cur 
	into tempAmount;
  set cur = cur + 1;
	
  insert into patientmedipredetail(MediPrescriptionID,
	                                 DrugID,
																	 `Usage`,
																   Consumption,
																	 Frequency,
																	 Amount,
																	 `Status`
	                                 ) values (tempMediID,tempDrugID,tempUsage,tempConsumption,tempFrequency,tempAmount,处方状态);
	
	until cur = length(tempString) - length(replace(tempString,',','')) + 1
	end repeat;

END