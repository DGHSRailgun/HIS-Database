CREATE DEFINER=`root`@`localhost` PROCEDURE `DesperateDrugs`(IN `病历ID` int,
                                                             OUT `结果` varchar(10))
BEGIN
	declare tempMediPreID int default 0;
	declare tempDetailID int;
  declare cur int default 0;
	declare maxline int default 0;
	declare cur1 int default 0;
	declare maxline1 int default 0;
	declare currStatus int default 0;
	select count(*) from patientmediprescription P where P.MedicalRecordID = 病历ID into maxline;
	select P.id from patientmediprescription P where P.MedicalRecordID = 病历ID limit 0,1 into cur;
	set tempMediPreID = cur;
	set 结果 = 'success';
	if maxline = 0
  then set 结果 = 'failure';
	
	else
	#利用cur遍历成药处方表
	repeat
	  update patientmediprescription P set P.`PrescriptionStatus` = 3 where P.id = tempMediPreID;
		#选择对应当前处方ID的明细表中的行数
	  select count(*) from patientmedipredetail PD where PD.MediPrescriptionID = tempMediPreID into maxline1;
		select PD.id from patientmedipredetail PD where PD.MediPrescriptionID = tempMediPreID limit 0,1 into cur1;
		set tempDetailID = cur1;
	  #利用cur1遍历成药处方明细表
		repeat
		select PD.`Status` from patientmedipredetail PD where PD.id = tempDetailID  into currStatus;
			if currStatus != 2
			then set 结果 = 'failure';
			else update patientmedipredetail PD set PD.`Status` = 3 where PD.id = tempDetailID;			
			end if;		
		set tempDetailID = tempDetailID + 1;
		until tempDetailID = cur1 + maxline1
    end repeat;		
	set tempMediPreID = tempMediPreID + 1;
	until tempMediPreID = cur + maxline
	end repeat;
	
	
	end if;
	
	
END