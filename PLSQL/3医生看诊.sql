CREATE DEFINER=`root`@`localhost` PROCEDURE `DocVisit`(IN 挂号ID int,
                                                       IN 主诉 longtext,
																											 IN 现病史 longtext,
																											 IN 现病治疗情况 longtext,
																											 IN 既往史 longtext,
																											 IN 过敏史 longtext,
																											 IN 体格检查 longtext,
																											 IN 检查建议 longtext,
																											 IN 注意事项 longtext,
																											 IN 检查结果 longtext,
																											 IN 诊断结果 longtext,
																											 IN 处理意见 longtext,
																											 IN 病历状态 int,
																											 IN 疾病ID int,
																											 IN 诊断类型 int,
																											 IN 发病日期 date,
																											 IN 诊断种类 int,
																											 OUT 结果 varchar(10))
BEGIN
	declare tempMediBookID int default 0;
	declare tempMediBookNum int default 000000;
	declare tempVisitStatus int default 000;
	#获取患者看诊状态
	select R.VisitState from registrationinfo R where R.id = 挂号ID into tempVisitStatus;
	select R.MedicalRecordNum from registrationinfo R where R.id = 挂号ID into tempMediBookNum;
  set 结果 = 'success';
	if tempVisitStatus = 171
  then insert into patienthomepage(MedicalRecordNum,
															RegID,
															ZhuSu,
															XianBingShi,
															XianZhiLiaoStatus,
															JiWangShi,
															AllergyHistory,
															TiGeCheck,
															CheckProposal,
															AttentionItem,
															CheckResult,
															DiagnosticResults,
															DisposalIdea,
															`Status`,
															`Delete`
															) values(tempMediBookNum,挂号ID,主诉,现病史,现病治疗情况,既往史,过敏史,体格检查,检查建议,注意事项,			      													 检查结果,诊断结果,处理意见,病历状态,1);
	else set 结果 = 'failure';														
  end if;
	#如果重新插入一列
	if ROW_COUNT() > 0
	then update registrationinfo R set R.VisitState = 172 where R.id = 挂号ID;
	else set 结果 = 'failure';
	end if;
  #根据挂号ID获取病历ID
  select P.id from patienthomepage P where P.RegID = 挂号ID into tempMediBookID;
	
	if 结果 = 'success'
	then insert into assessmentdiagnosis(MedicalRecordNo,
	                                RegID,
																	DiseaseID,
																	DiagnosisLeiXing,
																  OnsetDate,
																	DiagnosisZhongLei,
																	`Delete`
	                                ) values(tempMediBookID,挂号ID,疾病ID,诊断类型,发病日期,诊断种类,1);
	end if;
END