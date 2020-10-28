CREATE DEFINER=`root`@`localhost` PROCEDURE `register`(IN 身份证号 longtext,
							                                         IN 姓名 longtext,
																											 IN 性别 int,
																											 IN 出生日期 date,
																											 IN 年龄 int,
																											 IN 年龄类型 char,
																											 IN 家庭住址 longtext,
																											 IN 午别 longtext,
																											 IN 本次挂号科室ID int,
																											 IN 本次挂号医生ID int,
																											 IN 本次挂号等级ID int,
																											 IN 结算类别ID int,
																											 IN 是否要病历本 char,
																											 IN 挂号员ID int,
																											 OUT 结果 varchar(10)
																											 )
BEGIN
	declare MediBook int default 000000;
	SELECT MAX(MedicalRecordNum) + 1 FROM registrationinfo INTO MediBook;
	insert into registrationinfo(`IDCardNo`,
															 `MedicalRecordNum`,
															 `Name`,
															 `Sex`,
															 `BirthDate`,
															 `Age`,
															 `AgeType`,
															 `Address`,
															 `Date`,
															 `WuBie`,
															 `RegDepartID`,
															 `RegDocID`,
                               `RegLevelID`,
															 `SettlementTypeID`,
															 `WhetherMedicalBook`,
															 `RegTime`,
															 `RegistrarID`,
															 `VisitState`,
															 `Delete`
								               ) values (`身份证号`,`MediBook`,`姓名`,`性别`,`出生日期`,`年龄`,`年龄类型`,`家庭住址`,now(),`午别`,`本次挂号科室ID`,`本次挂号医生ID`,`本次挂号等级ID`,`结算类别ID`,`是否要病历本`,now(),`挂号员ID`,171,1);
															 
if ROW_COUNT() > 0
then set 结果 = 'success';
else 
set 结果 = 'failure';
end if;
END