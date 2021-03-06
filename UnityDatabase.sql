USE [DigitalReel]
GO
/****** Object:  StoredProcedure [dbo].[DF_GENERAL_MANUAL_PROCESS_AVAIL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_GENERAL_MANUAL_PROCESS_AVAIL]
	@UserUID int
AS

select j.PRIORITY, j.job_num, J.cust_name, p.process_desc, p.pid, j.job_uid, COUNT(f.fiche_uid) as "Fiche Count" from
	FICHE_TBL f, 
	FICHE_SET_TBL fs,
	JOB_TBL j,
	PROCESS_TBL p,	
	syssql.process_manual_tbl pm,
	fiche_PROCESS_TBL fp
	where
    j.JOB_UID = fs.JOB_UID and
	fp.JOB_UID = j.JOB_UID and
	p.PID = fp.PID and
	p.PID = pm.pid and
	fp.PREV_PID = f.PID and
	f.STATUS_UID = 1 and
	fs.FICHE_SET_UID = f.FICHE_SET_UID and	
	pm.status_uid = 1 and
	j.DLVR_DT is null and
	p.PID not in (SELECT DISTINCT PID FROM USER_GROUP_PROCESS_TBL)
	
	group by j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid order by j.PRIORITY, j.JOB_NUM
GO
/****** Object:  StoredProcedure [dbo].[DF_MANUAL_PROCESS_AVAIL_BY_GROUPUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_MANUAL_PROCESS_AVAIL_BY_GROUPUID]
	@GroupUid int
AS

select ug.USER_GROUP_UID, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, p.pid, j.job_uid, f.STATUS_UID, COUNT(f.fiche_uid) as "Fiche Count" from
	FICHE_TBL f, 
	FICHE_SET_TBL fs,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	fiche_PROCESS_TBL fp
	where
	j.JOB_UID = fs.JOB_UID and
	fp.JOB_UID = j.JOB_UID and
	p.PID = fp.PID and
	ug.PID = fp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	((fp.PREV_PID = f.PID and f.STATUS_UID = fp.CONT_STATUS_UID and pm.STATUS_UID = 1) or
	(fp.PID = f.PID and pm.STATUS_UID = f.STATUS_UID and pm.STATUS_UID != 1)) and
	f.STATUS_UID = FP.CONT_STATUS_UID and
	fs.FICHE_SET_UID = f.FICHE_SET_UID and	
	ug.USER_GROUP_UID = @GroupUid and
	j.DLVR_DT is null 
	
	group by ug.USER_GROUP_UID, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid, f.STATUS_UID order by j.PRIORITY, j.JOB_NUM

GO
/****** Object:  StoredProcedure [dbo].[DF_MANUAL_PROCESS_AVAIL_BY_USERUID_Backup]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_MANUAL_PROCESS_AVAIL_BY_USERUID_Backup]
	@UserUID int
AS

select U.user_name, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, p.pid, j.job_uid, COUNT(f.fiche_uid) as "Fiche Count" from
	FICHE_TBL f, 
	FICHE_SET_TBL fs,
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	fiche_PROCESS_TBL fp where
	
	u.USER_UID = @UserUID and 
	
	ug.USER_GROUP_UID = u.USER_GROUP_UID and	
	j.JOB_UID = fs.JOB_UID and
	fp.JOB_UID = j.JOB_UID and
	p.PID = fp.PID and
	ug.PID = fp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	fp.PREV_PID = f.PID and
	f.STATUS_UID = 1 and
	fs.FICHE_SET_UID = f.FICHE_SET_UID and	
	pm.status_uid = 1 and
	
	j.DLVR_DT is null 
	
	group by u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid order by j.PRIORITY, j.JOB_NUM



GO
/****** Object:  StoredProcedure [dbo].[DF_MANUAL_PROCESS_AVAIL_BY_USERUID_obsolete]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_MANUAL_PROCESS_AVAIL_BY_USERUID_obsolete]
	@UserUID int
AS

select DISTINCT U.user_name, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, p.pid, j.job_uid, COUNT(f.fiche_uid) as "Fiche Count" from
	FICHE_TBL f, 
	FICHE_SET_TBL fs,
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	fiche_PROCESS_TBL fp, 
	GROUP_USER_TBL gu
	WITH (NOLOCK)
	where
	u.USER_UID = @UserUID and 
	
	u.USER_UID = gu.USER_UID and
	ug.USER_GROUP_UID = gu.USER_GROUP_UID and	
	j.JOB_UID = fs.JOB_UID and
	fp.JOB_UID = j.JOB_UID and
	p.PID = fp.PID and
	ug.PID = fp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	((fp.PREV_PID = f.PID and f.STATUS_UID = fp.CONT_STATUS_UID and pm.STATUS_UID = 1) or
	(fp.PID = f.PID and pm.STATUS_UID = f.STATUS_UID and pm.STATUS_UID != 1)) and
	f.STATUS_UID = fp.CONT_STATUS_UID and
	fs.FICHE_SET_UID = f.FICHE_SET_UID and	
	j.DLVR_DT is null 
	
	group by gu.USER_GROUP_UID, u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid order by j.PRIORITY, j.JOB_NUM

GO
/****** Object:  StoredProcedure [dbo].[DF_MANUAL_PROCESS_EX_AVAIL_BY_USERUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_MANUAL_PROCESS_EX_AVAIL_BY_USERUID]
	@UserUID int
AS

select U.user_name, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, fst.status_desc, j.job_uid, p.PID, fst.STATUS_UID, COUNT(f.fiche_uid) as "Fiche Count" from
	FICHE_TBL f, 
	FICHE_SET_TBL fs,
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	fiche_PROCESS_TBL fp,
	FICHE_STATUS_TBL fst,
	GROUP_USER_TBL gu
	 where
	
	u.USER_UID = @UserUID and 
	u.USER_UID = gu.USER_UID and
	ug.USER_GROUP_UID = gu.USER_GROUP_UID and	
	j.JOB_UID = fs.JOB_UID and
	fp.JOB_UID = j.JOB_UID and
	p.PID = fp.PID and
	ug.PID = fp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	fp.pid = f.PID and
	fst.STATUS_UID = f.status_uid and
	f.STATUS_UID = pm.status_uid and
	fs.FICHE_SET_UID = f.FICHE_SET_UID and
	f.STATUS_UID <> 1 and		
	
	j.DLVR_DT is null 
	
	group by u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, fst.STATUS_DESC, j.job_uid, p.PID, fst.status_uid order by j.PRIORITY, j.JOB_NUM




GO
/****** Object:  StoredProcedure [dbo].[DF_MANUAL_PROCESS_EX_AVAIL_BY_USERUID_Backup]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_MANUAL_PROCESS_EX_AVAIL_BY_USERUID_Backup]
	@UserUID int
AS

select U.user_name, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, fst.status_desc, j.job_uid, p.PID, fst.STATUS_UID, COUNT(f.fiche_uid) as "Fiche Count" from
	FICHE_TBL f, 
	FICHE_SET_TBL fs,
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	fiche_PROCESS_TBL fp,
	FICHE_STATUS_TBL fst where
	
	u.USER_UID = @UserUID and 
	
	ug.USER_GROUP_UID = u.USER_GROUP_UID and	
	j.JOB_UID = fs.JOB_UID and
	fp.JOB_UID = j.JOB_UID and
	p.PID = fp.PID and
	ug.PID = fp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	fp.pid = f.PID and
	fst.STATUS_UID = f.status_uid and
	f.STATUS_UID = pm.status_uid and
	fs.FICHE_SET_UID = f.FICHE_SET_UID and
	f.STATUS_UID <> 1 and		
	
	j.DLVR_DT is null 
	
	group by u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, fst.STATUS_DESC, j.job_uid, p.PID, fst.status_uid order by j.PRIORITY, j.JOB_NUM





GO
/****** Object:  StoredProcedure [dbo].[DF_PID_BY_DATE_EVENT_TBL_BY_JOB]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_PID_BY_DATE_EVENT_TBL_BY_JOB]
	@StartDate DateTime,
	@EndDate DateTime,
	@PID int,
	@StatusUID int,
	@JobUID int
AS
	select j.job_num as "Job Number", Day(e.event_dt) as "Day", Count(e.fiche_uid) 
as "Count" from event_tbl e, job_tbl j where e.pid = @PID and e.status_uid = @StatusUID and j.JOB_UID = @JobUID and e.event_dt > @StartDate and e.event_dt < @EndDate
	 and j.job_uid = e.job_uid GROUP BY j.job_num, Day(e.event_dt) order by day




GO
/****** Object:  StoredProcedure [dbo].[DF_PID_BY_DATE_EVENT_TBL_DETAILS_BY_JOB]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_PID_BY_DATE_EVENT_TBL_DETAILS_BY_JOB]
	@StartDate DateTime,
	@EndDate DateTime,
	@PID int,
	@StatusUID int,
	@JobUID int
AS
	select j.job_num as "Job Number", Day(e.event_dt) as "Day", u.user_name as "User", Count(e.user_uid) 
as "Count" from event_tbl e, user_tbl u, job_tbl j where e.pid = @PID and e.status_uid = @StatusUID and j.JOB_UID = @JobUID and e.event_dt > @StartDate and e.event_dt < @EndDate
	 and e.user_uid = u.user_uid and j.job_uid = e.job_uid GROUP BY j.job_num, Day(e.event_dt), e.user_uid, u.user_name order by day




GO
/****** Object:  StoredProcedure [dbo].[DF_PROCESS_LIST_BY_JOB_UID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_PROCESS_LIST_BY_JOB_UID]
	@JobUID int
AS
	SELECT p.PROCESS_DESC, p.PID FROM dbo.PROCESS_TBL AS p INNER JOIN dbo.FICHE_PROCESS_TBL AS fp ON p.PID = fp.PID  where fp.job_uid = @jobUid ORDER BY p.PROCESS_DESC



GO
/****** Object:  StoredProcedure [dbo].[DF_USER_EVENT_REPORT_ALL_JOBS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_USER_EVENT_REPORT_ALL_JOBS]
	@StartDate DateTime,
	@EndDate DateTime,	
	@UserUid int	
AS
	select e.event_dt, j.job_num, j.cust_name, fs.FICHE_NAME, p.process_desc, s.status_desc, U.user_name, e.computer_name, e.err_msg
	from EVENT_TBL e, FICHE_SET_TBL fs , FICHE_TBL f, PROCESS_TBL p, USER_TBL u, roll_status_tbl s, JOB_TBL j where u.USER_UID = e.USER_UID
	and fs.FICHE_SET_UID=f.FICHE_SET_UID
	and f.FICHE_UID = e.FICHE_UID and p.PID = e.PID and s.status_uid = e.STATUS_UID and u.USER_UID = @UserUid and j.JOB_UID = fs.JOB_UID
	and e.JOB_UID = j.JOB_UID and
	event_dt >= @StartDate and event_dt <= @EndDate order by EVENT_DT
GO
/****** Object:  StoredProcedure [dbo].[DF_USER_EVENT_REPORT_ROLL_TIMES_BY_JOB]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_USER_EVENT_REPORT_ROLL_TIMES_BY_JOB]
	@StartDate DateTime,
	@EndDate DateTime,	
	@UserUid int,
	@JobUID int
AS
	
	
select e.event_dt, fs.FICHE_NAME, p.process_desc, s.status_desc, U.user_name, e.computer_name, e.ERR_MSG,
	DateDiff(minute, (select top 1 event_dt from EVENT_TBL where FICHE_UID = e.FICHE_UID and STATUS_UID = 4 and PID = e.pid order by EVENT_DT desc), (select top 1 event_dt from EVENT_TBL where FICHE_UID = e.FICHE_UID and STATUS_UID = 1 and PID = e.pid order by EVENT_DT desc)) as "Minutes"
		
	from event_tbl e, FICHE_SET_TBL fs,FICHE_TBL f, PROCESS_TBL p, USER_TBL u, roll_status_tbl s 
	
	where 
		u.USER_UID = e.USER_UID
	and fs.FICHE_SET_UID=f.FICHE_SET_UID
	and f.FICHE_UID = e.FICHE_UID and p.PID = e.PID and s.status_uid = e.STATUS_UID and u.USER_UID = @UserUid and 
	e.job_uid = @JobUID and event_dt >= @StartDate and event_dt <= @EndDate and	e.STATUS_UID <> 4

GO
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORGUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORGUID]
	@VendorGUID nchar(100)
AS

select j.PRIORITY, j.job_num, g.group_desc, fs.fiche_name, pv.process_code_name, f.update_dt as "Available on", DATEADD(Hour, pv.ExpectedHours, f.update_dt) "Expected On" from
	fiche_tbl f, 
	FICHE_SET_TBL fs,
	vendor_tbl v,
	JOB_TBL j,
	GROUP_TBL g,
	syssql.process_vendor_tbl pv,
	syssql.vendor_report_tbl vr,
	FICHE_PROCESS_TBL rp where
	
	vr.GUID = Convert(uniqueidentifier, @VendorGUID) and 
	vr.vendor_uid = v.VENDOR_UID and
	fs.FICHE_SET_UID = f.FICHE_SET_UID and
		
	j.JOB_UID = fs.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = f.PID and
	f.STATUS_UID = 1 and
	g.GROUP_UID = fs.fiche_GROUP_UID and
	f.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	order by j.PRIORITY, j.JOB_NUM, g.group_desc, fs.FICHE_NAME, pv.process_code_name, f.UPDATE_DT 



GO
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID]
	@VendorUID int
AS

select v.VENDOR_NAME, j.PRIORITY, j.job_num, j.cust_name, g.group_desc, fs.fiche_name, pv.process_code_name, f.update_dt as "Available on", DATEADD(Hour, pv.ExpectedHours, f.update_dt) "Expected On" from
	FICHE_TBL f, 
	FICHE_SET_TBL fs,
	vendor_tbl v,
	JOB_TBL j,
	GROUP_TBL g,
	syssql.process_vendor_tbl pv,
	fiche_PROCESS_TBL rp where
	
	v.vendor_uid = @VendorUID and 
	fs.FICHE_SET_UID = f.FICHE_SET_UID and
		
	j.JOB_UID = fs.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = f.PID and
	f.STATUS_UID = 1 and
	g.GROUP_UID = fs.FICHE_GROUP_UID and
	f.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	order by j.PRIORITY, j.JOB_NUM, j.cust_name, g.group_desc, fs.FICHE_NAME, pv.process_code_name, f.UPDATE_DT





GO
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID_HIDE_NAME]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID_HIDE_NAME]
	@VendorUID int
AS

select j.PRIORITY, j.job_num, g.group_desc, fs.fiche_name, pv.process_code_name, f.update_dt as "Available on" from
	fiche_TBL f, 
	FICHE_SET_TBL fs,
	vendor_tbl v,
	JOB_TBL j,
	GROUP_TBL g,
	syssql.process_vendor_tbl pv,
	FICHE_PROCESS_TBL rp where
	
	v.vendor_uid = @VendorUID and 
		
	j.JOB_UID = fs.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = f.PID and
	f.STATUS_UID = 1 and
	g.GROUP_UID = fs.FICHE_GROUP_UID and
	f.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	order by j.PRIORITY, j.JOB_NUM, g.group_desc, fs.fiche_name, pv.process_code_name, f.UPDATE_DT

GO
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORGUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORGUID]
	@VendorGUID nchar(100)
AS



select j.PRIORITY, j.job_num, pv.process_code_name, j.job_uid, pv.pid, f.status_uid, COUNT(f.fiche_uid) as "Fiche Count", J.CODENAME, j.PM_USER_UID from
	FICHE_TBL f, 
	FICHE_SET_TBL fs,
	vendor_tbl v,
	JOB_TBL j,
	syssql.process_vendor_tbl pv,
	syssql.vendor_report_tbl vr,
	FICHE_PROCESS_TBL rp where
	
	vr.GUID = Convert(uniqueidentifier, @VendorGUID) and 
	vr.vendor_uid = v.VENDOR_UID and
	fs.FICHE_SET_UID = f.FICHE_SET_UID and
		
	j.JOB_UID = fs.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = f.PID and
	f.STATUS_UID = 1 and
	f.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	group by j.PRIORITY, j.JOB_NUM, pv.process_code_name, j.job_uid, pv.pid, f.status_uid, J.CODENAME, j.PM_USER_UID order by j.PRIORITY, j.JOB_NUM

GO
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID]
	@VendorUID int
AS

select v.vendor_name, j.PRIORITY, j.job_num, j.cust_name, pv.process_code_name, COUNT(f.fiche_uid) as "Fiche Count", j.CODENAME, j.PM_USER_UID from
	FICHE_TBL f, 
	FICHE_SET_TBL fs,
	vendor_tbl v,
	JOB_TBL j,
	syssql.process_vendor_tbl pv,
	FICHE_PROCESS_TBL rp where
	
	v.vendor_uid = @VendorUID and 
	fs.FICHE_SET_UID = f.FICHE_SET_UID and
		
	j.JOB_UID = fs.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = f.PID and
	f.STATUS_UID = 1 and
	f.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	group by VENDOR_NAME, j.PRIORITY, j.JOB_NUM, j.cust_name, pv.process_code_name, J.CODENAME, j.PM_USER_UID order by j.PRIORITY, j.JOB_NUM


GO
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID_HIDE_NAME]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID_HIDE_NAME]
	@VendorUID int
AS

select j.PRIORITY, j.job_num, pv.process_code_name, COUNT(f.fiche_uid) as "Fiche Count" from
	fiche_TBL f, 
	FICHE_SET_TBL fs,
	vendor_tbl v,
	JOB_TBL j,
	syssql.process_vendor_tbl pv,
	fiche_PROCESS_TBL rp where
	
	v.vendor_uid = @VendorUID and 
		
	j.JOB_UID = fs.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = f.PID and
	f.STATUS_UID = 1 and
	f.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	group by j.PRIORITY, j.JOB_NUM, pv.process_code_name order by j.PRIORITY, j.JOB_NUM


GO
/****** Object:  StoredProcedure [dbo].[DIGITAL_REEL_PID_EVENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DIGITAL_REEL_PID_EVENT_TBL]
	@StartDate DateTime,
	@EndDate DateTime,
	@PID int
AS
	select j.job_num as "Job Number", Day(e.event_dt) as "Day", u.user_name as "User", Count(e.user_uid) 
as "Count" from event_tbl e, user_tbl u, job_tbl j where e.pid = @PID and e.event_dt > @StartDate and e.event_dt < @EndDate
	 and e.user_uid = u.user_uid and j.job_uid = e.job_uid GROUP BY j.job_num, Day(e.event_dt), e.user_uid, u.user_name order by day

GO
/****** Object:  StoredProcedure [dbo].[DR_GENERAL_MANUAL_PROCESS_AVAIL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_GENERAL_MANUAL_PROCESS_AVAIL]
	@UserUID int
AS

select j.PRIORITY, j.job_num, J.cust_name, p.process_desc, p.pid, j.job_uid, COUNT(r.roll_uid) as "Roll Count" from
	ROLL_TBL r, 
	JOB_TBL j,
	PROCESS_TBL p,	
	syssql.process_manual_tbl pm,
	ROLL_PROCESS_TBL rp
	where
	
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	p.PID = rp.PID and
	p.PID = pm.pid and
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and	
	pm.status_uid = 1 and
	
	j.DLVR_DT is null AND
	p.PID NOT IN (SELECT DISTINCT PID FROM USER_GROUP_PROCESS_TBL)
	
	group by j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid order by j.PRIORITY, j.JOB_NUM
GO
/****** Object:  StoredProcedure [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_GROUPUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_GROUPUID]
	@GroupUid int
AS

select ug.USER_GROUP_UID, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, p.pid, j.job_uid, r.STATUS_UID, COUNT(r.roll_uid) as "Roll Count" from
	ROLL_TBL r, 
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	ROLL_PROCESS_TBL rp
	where
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	p.PID = rp.PID and
	ug.PID = rp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	((rp.PREV_PID = r.PID and r.STATUS_UID = rp.CONT_STATUS_UID and pm.STATUS_UID = 1) or 
	(rp.PID = r.PID and pm.STATUS_UID = r.STATUS_UID and pm.STATUS_UID !=1)) and
	ug.USER_GROUP_UID = @GroupUid and
	j.DLVR_DT is null 
	
	group by ug.USER_GROUP_UID, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid,r.STATUS_UID order by j.PRIORITY, j.JOB_NUM



GO
/****** Object:  StoredProcedure [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID]
	@UserUID int
AS

select DISTINCT U.user_name, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, p.pid, j.job_uid, r.STATUS_UID,COUNT(r.roll_uid) as "Roll Count" from
	ROLL_TBL r, 
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	ROLL_PROCESS_TBL rp,
	GROUP_USER_TBL gu where
	
	u.USER_UID = @UserUID and 
	u.USER_UID = gu.USER_UID and
	ug.USER_GROUP_UID = gu.USER_GROUP_UID and	
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	p.PID = rp.PID and
	ug.PID = rp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	((rp.PREV_PID = r.PID and r.STATUS_UID = rp.CONT_STATUS_UID and pm.STATUS_UID = 1) or 
	(rp.PID = r.PID and pm.STATUS_UID = r.STATUS_UID and pm.STATUS_UID !=1)) and

	j.DLVR_DT is null 
	
	group by gu.USER_GROUP_UID, u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid,r.STATUS_UID order by j.PRIORITY, j.JOB_NUM



GO
/****** Object:  StoredProcedure [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID_Backup]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID_Backup]
	@UserUID int
AS

select U.user_name, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, p.pid, j.job_uid, COUNT(r.roll_uid) as "Roll Count" from
	ROLL_TBL r, 
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	ROLL_PROCESS_TBL rp where
	
	u.USER_UID = @UserUID and 
	
	ug.USER_GROUP_UID = u.USER_GROUP_UID and	
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	p.PID = rp.PID and
	ug.PID = rp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and	
	pm.status_uid = 1 and
	
	j.DLVR_DT is null 
	
	group by u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid order by j.PRIORITY, j.JOB_NUM



GO
/****** Object:  StoredProcedure [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID_WITH_AVGTIME]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID_WITH_AVGTIME]
	@UserUID int
AS

select U.USER_NAME, j.PRIORITY, j.JOB_NUM, J.CUST_NAME, p.PROCESS_DESC, p.PID, j.JOB_UID, 
COUNT(r.ROLL_UID) as "Roll Count",str((AVG(cast(pt.PROCESS_TIME_SECS as decimal(8,2)))/60),12,2) as "Average Process Time(in mins)" 
from
	ROLL_TBL r, 
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	GROUP_USER_TBL gu,
	ROLL_PROCESS_TBL rp
	left join PROCESS_TIME_TBL pt
	on pt.PID=rp.PID
	WHERE
	u.USER_UID = @UserUID and 
	u.USER_UID = gu.USER_UID and
	ug.USER_GROUP_UID = gu.USER_GROUP_UID and	
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	p.PID = rp.PID and
	ug.PID = rp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and	
	pm.status_uid = 1 and
	
	j.DLVR_DT is null 
	
	GROUP BY u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid order by j.PRIORITY, j.JOB_NUM



GO
/****** Object:  StoredProcedure [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID_WITH_AVGTIME_Backup]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID_WITH_AVGTIME_Backup]
	@UserUID int
AS

select U.USER_NAME, j.PRIORITY, j.JOB_NUM, J.CUST_NAME, p.PROCESS_DESC, p.PID, j.JOB_UID, 
COUNT(r.ROLL_UID) as "Roll Count",str((AVG(cast(pt.PROCESS_TIME_SECS as decimal(8,2)))/60),12,2) as "Average Process Time(in mins)" 
from
	ROLL_TBL r, 
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	ROLL_PROCESS_TBL rp
	left join PROCESS_TIME_TBL pt
	on pt.PID=rp.PID
	WHERE
	u.USER_UID = @UserUID and 
	ug.USER_GROUP_UID = u.USER_GROUP_UID and	
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	p.PID = rp.PID and
	ug.PID = rp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and	
	pm.status_uid = 1 and
	
	j.DLVR_DT is null 
	
	GROUP BY u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid order by j.PRIORITY, j.JOB_NUM




GO
/****** Object:  StoredProcedure [dbo].[DR_MANUAL_PROCESS_EX_AVAIL_BY_USERUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_MANUAL_PROCESS_EX_AVAIL_BY_USERUID]
	@UserUID int
AS

select U.user_name, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, rs.status_desc, j.job_uid, p.PID, rs.STATUS_UID, COUNT(r.roll_uid) as "Roll Count" from
	ROLL_TBL r, 
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	ROLL_PROCESS_TBL rp,
	ROLL_STATUS_TBL rs,
	GROUP_USER_TBL gu
	where
	
	u.USER_UID = @UserUID and 
	u.USER_UID = gu.USER_UID and
	ug.USER_GROUP_UID = gu.USER_GROUP_UID and	
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	p.PID = rp.PID and
	ug.PID = rp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	rp.PID = r.PID and
	rs.STATUS_UID = r.STATUS_UID and
	r.STATUS_UID = pm.status_uid and
	r.STATUS_UID <> 1 and		
	
	j.DLVR_DT is null 
	
	group by u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, rs.STATUS_DESC, j.job_uid, p.PID, rs.status_uid order by j.PRIORITY, j.JOB_NUM



GO
/****** Object:  StoredProcedure [dbo].[DR_MANUAL_PROCESS_EX_AVAIL_BY_USERUID_Backup]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_MANUAL_PROCESS_EX_AVAIL_BY_USERUID_Backup]
	@UserUID int
AS

select U.user_name, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, rs.status_desc, j.job_uid, p.PID, rs.STATUS_UID, COUNT(r.roll_uid) as "Roll Count" from
	ROLL_TBL r, 
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	ROLL_PROCESS_TBL rp,
	ROLL_STATUS_TBL rs
	
	where
	
	u.USER_UID = @UserUID and 
	
	ug.USER_GROUP_UID = u.USER_GROUP_UID and	
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	p.PID = rp.PID and
	ug.PID = rp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	rp.PID = r.PID and
	rs.STATUS_UID = r.STATUS_UID and
	r.STATUS_UID = pm.status_uid and
	r.STATUS_UID <> 1 and		
	
	j.DLVR_DT is null 
	
	group by u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, rs.STATUS_DESC, j.job_uid, p.PID, rs.status_uid order by j.PRIORITY, j.JOB_NUM



GO
/****** Object:  StoredProcedure [dbo].[DR_PID_BY_DATE_EVENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_PID_BY_DATE_EVENT_TBL]
	@StartDate DateTime,
	@EndDate DateTime,
	@PID int
AS
	select j.job_num as "Job Number", Day(e.event_dt) as "Day", u.user_name as "User", Count(e.user_uid) 
as "Count" from event_tbl e, user_tbl u, job_tbl j where e.pid = @PID and e.event_dt > @StartDate and e.event_dt <= @EndDate
	 and e.user_uid = u.user_uid and j.job_uid = e.job_uid GROUP BY j.job_num, Day(e.event_dt), e.user_uid, u.user_name order by day


GO
/****** Object:  StoredProcedure [dbo].[DR_PID_BY_DATE_EVENT_TBL_BY_JOB]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_PID_BY_DATE_EVENT_TBL_BY_JOB]
	@StartDate DateTime,
	@EndDate DateTime,
	@PID int,
	@StatusUID int,
	@JobUID int
AS
	select j.job_num as "Job Number", Day(e.event_dt) as "Day", Count(e.roll_uid) 
as "Count" from event_tbl e, job_tbl j where e.pid = @PID and e.status_uid = @StatusUID and j.JOB_UID = @JobUID and e.event_dt > @StartDate and e.event_dt < @EndDate
	 and j.job_uid = e.job_uid GROUP BY j.job_num, Day(e.event_dt) order by day




GO
/****** Object:  StoredProcedure [dbo].[DR_PID_BY_DATE_EVENT_TBL_DETAILS_BY_JOB]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[DR_PID_BY_DATE_EVENT_TBL_DETAILS_BY_JOB]
	@StartDate DateTime,
	@EndDate DateTime,
	@PID int,
	@StatusUID int,
	@JobUID int
AS
	select j.job_num as "Job Number", Day(e.event_dt) as "Day", u.user_name as "User", Count(e.user_uid) 
as "Count" from event_tbl e, user_tbl u, job_tbl j where e.pid = @PID and e.status_uid = @StatusUID and j.JOB_UID = @JobUID and e.event_dt > @StartDate and e.event_dt < @EndDate
	 and e.user_uid = u.user_uid and j.job_uid = e.job_uid GROUP BY j.job_num, Day(e.event_dt), e.user_uid, u.user_name order by day




GO
/****** Object:  StoredProcedure [dbo].[DR_PROCESS_LIST_BY_JOB_UID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DR_PROCESS_LIST_BY_JOB_UID]
	@JobUID int
AS
	SELECT p.PROCESS_DESC, p.PID FROM dbo.PROCESS_TBL AS p INNER JOIN dbo.ROLL_PROCESS_TBL AS rp ON p.PID = rp.PID  where rp.job_uid = @jobUid ORDER BY p.PROCESS_DESC


GO
/****** Object:  StoredProcedure [dbo].[DR_USER_EVENT_REPORT_ALL_JOBS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_USER_EVENT_REPORT_ALL_JOBS]
	@StartDate DateTime,
	@EndDate DateTime,	
	@UserUid int	
AS
	select e.event_dt, j.job_num, j.cust_name, r.roll_name, p.process_desc, s.status_desc, U.user_name, e.computer_name, e.err_msg
	from EVENT_TBL e, ROLL_TBL r, PROCESS_TBL p, USER_TBL u, roll_status_tbl s, JOB_TBL j where u.USER_UID = e.USER_UID
	and r.ROLL_UID = e.ROLL_UID and p.PID = e.PID and s.status_uid = e.STATUS_UID and u.USER_UID = @UserUid and j.JOB_UID = r.job_uid
	and e.JOB_UID = j.JOB_UID and
	event_dt >= @StartDate and event_dt <= @EndDate order by EVENT_DT



GO
/****** Object:  StoredProcedure [dbo].[DR_USER_EVENT_REPORT_BY_JOB]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_USER_EVENT_REPORT_BY_JOB]
	@StartDate DateTime,
	@EndDate DateTime,	
	@UserUid int,
	@JobUID int
AS
	select e.event_dt, r.roll_name, p.process_desc, s.status_desc, U.user_name, e.computer_name, e.err_msg
	from EVENT_TBL e, ROLL_TBL r, PROCESS_TBL p, USER_TBL u, roll_status_tbl s where u.USER_UID = e.USER_UID
	and r.ROLL_UID = e.ROLL_UID and p.PID = e.PID and s.status_uid = e.STATUS_UID and u.USER_UID = @UserUid and 
	e.job_uid = @JobUID and event_dt >= @StartDate and event_dt <= @EndDate order by EVENT_DT


GO
/****** Object:  StoredProcedure [dbo].[DR_USER_EVENT_REPORT_ROLL_TIMES_BY_JOB]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_USER_EVENT_REPORT_ROLL_TIMES_BY_JOB]
	@StartDate DateTime,
	@EndDate DateTime,	
	@UserUid int,
	@JobUID int
AS
	
	select e.event_dt, r.roll_name, p.process_desc, s.status_desc, U.user_name, e.computer_name, e.ERR_MSG,
	DateDiff(minute, (select top 1 event_dt from EVENT_TBL where ROLL_UID = e.roll_uid and STATUS_UID = 4 and PID = e.pid order by EVENT_DT desc), (select top 1 event_dt from EVENT_TBL where ROLL_UID = e.roll_uid and STATUS_UID = 1 and PID = e.pid order by EVENT_DT desc)) as "Minutes"
		
	from event_tbl e, ROLL_TBL r, PROCESS_TBL p, USER_TBL u, roll_status_tbl s 
	
	where 
	
	u.USER_UID = e.USER_UID
	and r.ROLL_UID = e.ROLL_UID and p.PID = e.PID and s.status_uid = e.STATUS_UID and u.USER_UID = @UserUid and 
	e.job_uid = @JobUID and event_dt >= @StartDate and event_dt <= @EndDate and	e.STATUS_UID <> 4



GO
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORGUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DR_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORGUID]
	@VendorGUID nchar(100)
AS

select j.PRIORITY, j.job_num, g.group_desc, r.roll_name, pv.process_code_name, r.update_dt as "Available on", DATEADD(Hour, pv.ExpectedHours, r.update_dt) "Expected On" from
	ROLL_TBL r, 
	vendor_tbl v,
	JOB_TBL j,
	GROUP_TBL g,
	syssql.process_vendor_tbl pv,
	syssql.vendor_report_tbl vr,
	ROLL_PROCESS_TBL rp where
	
	vr.GUID = Convert(uniqueidentifier, @VendorGUID) and 
	vr.vendor_uid = v.VENDOR_UID and
		
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and
	g.GROUP_UID = r.ROLL_GROUP_UID and
	r.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	order by j.PRIORITY, j.JOB_NUM, g.group_desc, r.roll_name, pv.process_code_name, r.UPDATE_DT 


GO
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID]
	@VendorUID int
AS

select v.VENDOR_NAME, j.PRIORITY, j.job_num, j.cust_name, g.group_desc, r.roll_name, pv.process_code_name, r.update_dt as "Available on", DATEADD(Hour, pv.ExpectedHours, r.update_dt) "Expected On" from
	ROLL_TBL r, 
	vendor_tbl v,
	JOB_TBL j,
	GROUP_TBL g,
	syssql.process_vendor_tbl pv,
	ROLL_PROCESS_TBL rp where
	
	v.vendor_uid = @VendorUID and 
		
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and
	g.GROUP_UID = r.ROLL_GROUP_UID and
	r.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	order by j.PRIORITY, j.JOB_NUM, j.cust_name, g.group_desc, r.roll_name, pv.process_code_name, r.UPDATE_DT



GO
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID_HIDE_NAME]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID_HIDE_NAME]
	@VendorUID int
AS

select j.PRIORITY, j.job_num, g.group_desc, r.roll_name, pv.process_code_name, r.update_dt as "Available on" from
	ROLL_TBL r, 
	vendor_tbl v,
	JOB_TBL j,
	GROUP_TBL g,
	syssql.process_vendor_tbl pv,
	ROLL_PROCESS_TBL rp where
	
	v.vendor_uid = @VendorUID and 
		
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and
	g.GROUP_UID = r.ROLL_GROUP_UID and
	r.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	order by j.PRIORITY, j.JOB_NUM, g.group_desc, r.roll_name, pv.process_code_name, r.UPDATE_DT
GO
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORGUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORGUID]
	@VendorGUID nchar(100)
AS



select j.PRIORITY, j.job_num, pv.process_code_name, j.job_uid, pv.pid, r.status_uid, COUNT(r.roll_uid) as "Roll Count", J.CODENAME, j.PM_USER_UID from
	ROLL_TBL r, 
	vendor_tbl v,
	JOB_TBL j,
	syssql.process_vendor_tbl pv,
	syssql.vendor_report_tbl vr,
	ROLL_PROCESS_TBL rp where
	
	vr.GUID = Convert(uniqueidentifier, @VendorGUID) and 
	vr.vendor_uid = v.VENDOR_UID and
		
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and
	r.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	group by j.PRIORITY, j.JOB_NUM, pv.process_code_name, j.job_uid, pv.pid, r.status_uid, J.CODENAME, j.PM_USER_UID order by j.PRIORITY, j.JOB_NUM
GO
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID]
	@VendorUID int
AS

select v.vendor_name, j.PRIORITY, j.job_num, j.cust_name, pv.process_code_name, COUNT(r.roll_uid) as "Roll Count", J.CODENAME, j.PM_USER_UID from
	ROLL_TBL r, 
	vendor_tbl v,
	JOB_TBL j,
	syssql.process_vendor_tbl pv,
	ROLL_PROCESS_TBL rp where
	
	v.vendor_uid = @VendorUID and 
		
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and
	r.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	group by VENDOR_NAME, j.PRIORITY, j.JOB_NUM, j.cust_name, pv.process_code_name, J.CODENAME, j.PM_USER_UID order by j.PRIORITY, j.JOB_NUM
GO
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID_HIDE_NAME]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID_HIDE_NAME]
	@VendorUID int
AS

select j.PRIORITY, j.job_num, pv.process_code_name, COUNT(r.roll_uid) as "Roll Count" from
	ROLL_TBL r, 
	vendor_tbl v,
	JOB_TBL j,
	syssql.process_vendor_tbl pv,
	ROLL_PROCESS_TBL rp where
	
	v.vendor_uid = @VendorUID and 
		
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and
	r.MARK_VENDOR_UID = v.VENDOR_UID and
	
	j.DLVR_DT is null 
	
	group by j.PRIORITY, j.JOB_NUM, pv.process_code_name order by j.PRIORITY, j.JOB_NUM

GO
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_DETAILS_BY_PROCESS_PID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_VENDOR_PROCESS_DETAILS_BY_PROCESS_PID]
	@PID int
AS

select j.PRIORITY, j.job_num, g.group_desc, r.roll_name, pv.process_code_name,  
	r.update_dt as "Available On", 
	DATEADD(Hour, pv.ExpectedHours, r.update_dt) as "Expected On", r.roll_uid from
	
	ROLL_TBL r, 	
	JOB_TBL j,
	GROUP_TBL g,
	syssql.process_vendor_tbl pv,
	ROLL_PROCESS_TBL rp where	
		
	j.JOB_UID = r.JOB_UID and
	rp.JOB_UID = j.JOB_UID and
	pv.PID = rp.PID and			
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and
	g.GROUP_UID = r.ROLL_GROUP_UID and
	pv.PID = @PID and
	
	j.DLVR_DT is null 
	
	order by j.PRIORITY, j.JOB_NUM, j.cust_name, g.group_desc, r.roll_name, pv.process_code_name, r.UPDATE_DT	




GO
/****** Object:  StoredProcedure [dbo].[GetRollByNewsPaperTitle_RollTitle]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRollByNewsPaperTitle_RollTitle]
@TitleId varchar(20),
@RollTitle varchar(50)
AS
Select top 1000 * 
from proquest_process_tbl p 
	inner join PQ_TITLE_AUTH_TBL t on p.NewspaperTitle = t.NewsPaperTitle
where t.TitleId = @TitleId
	AND p.RollTitle = @RollTitle



GO
/****** Object:  StoredProcedure [dbo].[SF_MUNI_BATCH_DELIVER_REPORT]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SF_MUNI_BATCH_DELIVER_REPORT]

	@JobUid int,
	@StartDate char(20)
AS

select r.roll_name as "Batch Name", r.found_pg_cnt as "Citation Count",	
	
	(select top 1 event_dt from EVENT_TBL et where et.job_uid = 1353 and et.PID = 416 and et.STATUS_UID = 1 and et.ROLL_UID = r.roll_uid) as "Downloaded From Customer",
	
	(select top 1 event_dt from EVENT_TBL et where et.job_uid = 1353 and et.PID = 429 and et.STATUS_UID = 1 and et.ROLL_UID = r.roll_uid) as "Uploaded To Customer",
	
	DateDiff(day, (select top 1 event_dt from EVENT_TBL et where et.job_uid = 1353 and et.PID = 416 and et.STATUS_UID = 1 and et.ROLL_UID = r.roll_uid),
	(select top 1 event_dt from EVENT_TBL et where et.job_uid = 1353 and et.PID = 429 and et.STATUS_UID = 1 and et.ROLL_UID = r.roll_uid)) as "Days to Process"
	from ROLL_TBL r where JOB_UID = @JobUid 
	
	and (select top 1 event_dt from EVENT_TBL et where et.job_uid = 1353 and et.PID = 416 and et.STATUS_UID = 1 and et.ROLL_UID = r.roll_uid) >= @StartDate
	
	order by "Downloaded From Customer"



GO
/****** Object:  StoredProcedure [syssql].[ClarkCountyGetReScanList]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [syssql].[ClarkCountyGetReScanList] as 
	
select a.book as "Book", a.range as "Range", r.roll_uid as "Roll UID" from Clark_County.dbo.Asset_Tbl a, ROLL_TBL r where
	r.roll_uid = a.RollUID and r.job_uid = 887 and r.pid = 205 and r.status_uid = 1 order by a.Book desc, a.Range	
GO
/****** Object:  StoredProcedure [syssql].[ClarkCountyRollDateListByJobPidStatus]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [syssql].[ClarkCountyRollDateListByJobPidStatus] 

@jobuid int,
@pid int,
@status int

as
	
select a.book as "Book", a.range as "Range", a.Date as "Date", r.roll_uid as "Roll UID" from Clark_County.dbo.Asset_Tbl a, ROLL_TBL r where
	r.roll_uid = a.RollUID and r.job_uid = @jobuid and r.pid = @pid and r.status_uid = @status order by a.date desc, a.Range	


GO
/****** Object:  StoredProcedure [syssql].[DF_ALL_MANUAL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [syssql].[DF_ALL_MANUAL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]
	@Minutes int
AS

select e.EVENT_DT, J.job_num, J.cust_name, fs.fiche_name, p.process_desc, fst.status_desc, U.user_name, e.computer_name, e.err_msg
	from EVENT_TBL e, JOB_TBL j, FICHE_TBL f, FICHE_SET_TBL fs, PROCESS_TBL p, FICHE_STATUS_TBL fst, USER_TBL u, PROCESS_MANUAL_TBL pm
	
	where e.EVENT_DT >= DATEADD(minute, -@Minutes, CURRENT_TIMESTAMP) and
	
	e.USER_UID = u.USER_UID and
	e.JOB_UID = j.JOB_UID and
	e.fiche_uid = f.fiche_uid and
	f.FICHE_SET_UID = fs.FICHE_SET_UID and
	e.STATUS_UID = fst.STATUS_UID and
	e.PID = p.PID and
	e.PID = pm.pid and
	pm.STATUS_UID = 1 	
	
	order by e.EVENT_DT desc


GO
/****** Object:  StoredProcedure [syssql].[DF_ALL_MANUAL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [syssql].[DF_ALL_MANUAL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]
	@Minutes int
AS

select J.job_num, J.cust_name, p.process_desc, U.user_name, COUNT(e.fiche_uid)
	from EVENT_TBL e, JOB_TBL j, FICHE_TBL f, FICHE_SET_TBL fs, PROCESS_TBL p, FICHE_STATUS_TBL fst, 
	USER_TBL u, PROCESS_MANUAL_TBL pm
	
	where e.EVENT_DT >= DATEADD(MINUTE, -@Minutes, CURRENT_TIMESTAMP) and
	
	e.USER_UID = u.USER_UID and
	e.JOB_UID = j.JOB_UID and
	e.fiche_uid = f.fiche_uid and
	f.FICHE_SET_UID = fs.FICHE_SET_UID and
	e.STATUS_UID = fst.STATUS_UID and
	e.PID = p.PID and
	e.PID = pm.pid and
	e.STATUS_UID = 1 and
	pm.STATUS_UID = 1 
	
	group by J.job_num, J.cust_name, p.process_desc, U.user_name	
	
	order by J.job_num, J.cust_name, p.process_desc, U.user_name desc


GO
/****** Object:  StoredProcedure [syssql].[DF_ALL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [syssql].[DF_ALL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]
	@Minutes int
AS

select e.EVENT_DT, J.job_num, J.cust_name, fs.fiche_name, p.process_desc, fst.status_desc, U.user_name, e.computer_name, e.err_msg
	from EVENT_TBL e, JOB_TBL j, FICHE_TBL f, FICHE_SET_TBL fs, PROCESS_TBL p, FICHE_STATUS_TBL fst, USER_TBL u
	
	where e.EVENT_DT >= DATEADD(minute, -@Minutes, CURRENT_TIMESTAMP) and
	
	e.USER_UID = u.USER_UID and
	e.JOB_UID = j.JOB_UID and
	e.fiche_uid = f.fiche_uid and
	f.FICHE_SET_UID = fs.FICHE_SET_UID and
	e.STATUS_UID = fst.STATUS_UID and
	e.PID = p.PID and	
	f.STATUS_UID = 1 	
	
	order by e.EVENT_DT desc



GO
/****** Object:  StoredProcedure [syssql].[DF_ALL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [syssql].[DF_ALL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]
	@Minutes int
AS

select J.job_num, J.cust_name, p.process_desc, U.user_name, COUNT(e.fiche_uid)
	from EVENT_TBL e, JOB_TBL j, FICHE_TBL f, FICHE_SET_TBL fs, PROCESS_TBL p, FICHE_STATUS_TBL fst, 
	USER_TBL u
	
	where e.EVENT_DT >= DATEADD(MINUTE, -@Minutes, CURRENT_TIMESTAMP) and
	
	e.USER_UID = u.USER_UID and
	e.JOB_UID = j.JOB_UID and
	e.fiche_uid = f.fiche_uid and
	f.FICHE_SET_UID = fs.FICHE_SET_UID and
	e.STATUS_UID = fst.STATUS_UID and
	e.PID = p.PID and	
	e.STATUS_UID = 1 and
	f.STATUS_UID = 1 
	
	group by J.job_num, J.cust_name, p.process_desc, U.user_name	
	
	order by J.job_num, J.cust_name, p.process_desc, U.user_name desc



GO
/****** Object:  StoredProcedure [syssql].[DF_FICHE_HISTORY]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [syssql].[DF_FICHE_HISTORY] 
	@FicheUID int
as
	 select e.event_dt, p.process_desc, fs.status_desc, U.user_name, e.COMPUTER_NAME, e.err_msg from EVENT_TBL e, PROCESS_TBL p, FICHE_STATUS_TBL fs, USER_TBL u
	where e.FICHE_UID = @FicheUID and p.PID = e.PID and u.USER_UID = e.user_uid and fs.STATUS_UID = e.STATUS_UID order by e.EVENT_DT desc

GO
/****** Object:  StoredProcedure [syssql].[DF_MANUAL_PROCESS_AVAIL_BY_USERUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [syssql].[DF_MANUAL_PROCESS_AVAIL_BY_USERUID]
	@UserUID int
AS

select DISTINCT U.user_name, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, p.pid, j.job_uid, f.STATUS_UID, COUNT(f.fiche_uid) as "Fiche Count" from
	FICHE_TBL f, 
	FICHE_SET_TBL fs,
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	fiche_PROCESS_TBL fp, 
	GROUP_USER_TBL gu
	WITH (NOLOCK)
	where
	u.USER_UID = @UserUID and 
	
	u.USER_UID = gu.USER_UID and
	ug.USER_GROUP_UID = gu.USER_GROUP_UID and	
	j.JOB_UID = fs.JOB_UID and
	fp.JOB_UID = j.JOB_UID and
	p.PID = fp.PID and
	ug.PID = fp.PID and
	ug.PID = p.PID and
	p.PID = pm.pid and
	((fp.PREV_PID = f.PID and f.STATUS_UID = fp.CONT_STATUS_UID and pm.STATUS_UID = 1) or
	(fp.PID = f.PID and pm.STATUS_UID = f.STATUS_UID and pm.STATUS_UID != 1)) and
	f.STATUS_UID = fp.CONT_STATUS_UID and
	fs.FICHE_SET_UID = f.FICHE_SET_UID and	
	j.DLVR_DT is null 
	
	group by gu.USER_GROUP_UID, u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid,f.STATUS_UID order by j.PRIORITY, j.JOB_NUM

GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_FICHE_GET_BILLING_COUNTS_BY_JOBUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [syssql].[DIGITAL_FICHE_GET_BILLING_COUNTS_BY_JOBUID]

@JobUid int

AS


SELECT BI.ITEM_DESC, SUM(FB.bill_item_count) 
FROM fiche_bill_event_tbl FB, BILL_ITEM_TBL BI
WHERE BI.BILL_ITEM_UID = FB.bill_item_uid 
      AND BI.JOB_UID = @JobUid --2494
      GROUP BY BI.ITEM_DESC  
      
  
GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_FICHE_JOB_PROCESS_COUNTS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  PROCEDURE [syssql].[DIGITAL_FICHE_JOB_PROCESS_COUNTS]

as

select distinct j.job_num as "Job Number", j.cust_name as "Customer", p.process_desc as "Process", count(f.fiche_uid) as "Count"
	from job_tbl j, fiche_tbl f, fiche_set_tbl fs, process_tbl p where j.job_uid = fs.job_uid and f.fiche_set_uid = fs.fiche_set_uid and p.pid = f.pid
		and j.dlvr_dt is null group by j.job_num, j.cust_name, p.process_desc order by j.job_num, p.process_desc


GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_FICHE_JOB_PROCESS_COUNTS_WITH_STATUS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  PROCEDURE [syssql].[DIGITAL_FICHE_JOB_PROCESS_COUNTS_WITH_STATUS]

as

select distinct j.job_num as "Job Number", j.cust_name as "Customer", p.process_desc as "Process", s.Status_desc as "Status", count(f.fiche_uid) as "Count"
	from job_tbl j, fiche_tbl f, fiche_set_tbl fs, process_tbl p, fiche_status_tbl s where j.job_uid = fs.job_uid and f.fiche_set_uid = fs.fiche_set_uid and p.pid = f.pid and f.status_uid = s.Status_uid
		and j.dlvr_dt is null group by j.job_num, j.cust_name, p.process_desc, s.Status_desc order by j.job_num, p.process_desc, s.Status_desc

GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_FICHE_JOB_PROCESS_COUNTS_WITH_STATUS_BY_JOBUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [syssql].[DIGITAL_FICHE_JOB_PROCESS_COUNTS_WITH_STATUS_BY_JOBUID]

@JobUid int

AS
/* Equivalent of stored proc "DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_BY_JOBUID" */
SELECT DISTINCT J.JOB_NUM AS "Job Number", J.CUST_NAME as "Customer", p.process_desc as "Process", s.Status_desc as "Status", count(f.fiche_uid) as "Count"
	FROM JOB_TBL J
	JOIN
	FICHE_SET_TBL FS
	ON J.JOB_UID = FS.JOB_UID
	JOIN FICHE_TBL F
	ON F.FICHE_SET_UID=FS.FICHE_SET_UID
	JOIN FICHE_STATUS_TBL S
	ON F.STATUS_UID=S.STATUS_UID
	JOIN PROCESS_TBL P
	ON P.PID = F.PID 
	
	WHERE 
		J.DLVR_DT IS NULL 
		AND 
		J.JOB_UID= @JobUid --coconino '2396' --input parameter
	GROUP BY J.JOB_NUM, J.CUST_NAME, P.PROCESS_DESC, S.STATUS_DESC 
	ORDER BY J.JOB_NUM, P.PROCESS_DESC, S.STATUS_DESC
		 
GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_FICHE_JOB_PROCESSED_LOCATIONS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [syssql].[DIGITAL_FICHE_JOB_PROCESSED_LOCATIONS]
	@job_num char(20)

as

select distinct(s.storage_location_path) as "Storage Location Path" from job_tbl j, fiche_set_tbl fs, fiche_tbl f, storage_location_tbl s
	where j.job_num = @job_num and fs.job_uid = j.job_uid and f.fiche_set_uid = fs.fiche_set_uid and 
		s.storage_location_uid = f.processed_storage_location_uid

GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_CHW_BILLING_COUNTS_BY_DATE]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [syssql].[DIGITAL_REEL_CHW_BILLING_COUNTS_BY_DATE]
	@StartDate DateTime,
	@EndDate DateTime,
	@JobUID int
AS

SELECT ROLL_TBL.ROLL_NAME as "Box", roll_bill_event_tbl.bill_item_count as "Count", roll_bill_event_tbl.bill_event_dt as "Completed" 
FROM bill_item_tbl, roll_bill_event_tbl, roll_tbl 
WHERE (bill_item_tbl.job_uid =@JobUID)  
and roll_bill_event_tbl.bill_item_uid = bill_item_tbl.bill_item_uid 
and bill_event_dt >= @StartDate and bill_event_dt <= @EndDate and ROLL_TBL.ROLL_UID = roll_bill_event_tbl.roll_uid 
ORDER BY ROLL_TBL.ROLL_NAME

GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_FOUND_PAGE_COUNT_BY_JOB_NUM]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [syssql].[DIGITAL_REEL_FOUND_PAGE_COUNT_BY_JOB_NUM] 
	@job_num char(20)
as 

select sum(r.found_pg_cnt) from roll_tbl r, job_tbl j where j.job_uid = r.job_uid and j.job_num = @job_num
GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_FOUND_PAGE_COUNT_BY_JOB_UID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [syssql].[DIGITAL_REEL_FOUND_PAGE_COUNT_BY_JOB_UID] 
	@job_uid int
as 
select sum(found_pg_cnt) from roll_tbl where job_uid = @job_uid
GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_FRAME_TOOL_EVENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [syssql].[DIGITAL_REEL_FRAME_TOOL_EVENT_TBL]
	@StartDate DateTime,
	@EndDate DateTime
AS
	select j.job_num as "Job Number", Day(e.event_dt) as "Day", u.user_name as "User", Count(e.user_uid) 
as "Count" from event_tbl e, user_tbl u, job_tbl j where e.pid = 5 and e.event_dt > @StartDate and e.event_dt < @EndDate
	 and e.user_uid = u.user_uid and j.job_uid = e.job_uid GROUP BY j.job_num, Day(e.event_dt), e.user_uid, u.user_name order by day

GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_GET_BILLING_COUNTS_BY_JOBUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [syssql].[DIGITAL_REEL_GET_BILLING_COUNTS_BY_JOBUID]

@JobUid int

AS

SELECT BI.ITEM_DESC, SUM(RB.bill_item_count) 
FROM roll_bill_event_tbl RB, BILL_ITEM_TBL BI
WHERE BI.BILL_ITEM_UID = RB.bill_item_uid 
      AND BI.JOB_UID = @JobUid 
      GROUP BY BI.ITEM_DESC  
GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS]

as

select distinct j.job_num as "Job Number", j.cust_name as "Customer", p.process_desc as "Process", count(r.roll_uid) as "Count"
	from job_tbl j, roll_tbl r, process_tbl p where j.job_uid = r.job_uid and p.pid = r.pid
		and j.dlvr_dt is null group by j.job_num, j.cust_name, p.process_desc order by j.job_num, p.process_desc


GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS]

as

select distinct j.job_num as "Job Number", j.cust_name as "Customer", p.process_desc as "Process", s.Status_desc as "Status", count(r.roll_uid) as "Count"
	from job_tbl j, roll_tbl r, process_tbl p, roll_status_tbl s where j.job_uid = r.job_uid and p.pid = r.pid and r.status_uid = s.Status_uid
		and j.dlvr_dt is null group by j.job_num, j.cust_name, p.process_desc, s.Status_desc order by j.job_num, p.process_desc, s.Status_desc

GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_BY_JOB]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_BY_JOB]

@JobNumber varchar(10)

as

select distinct j.job_num as "Job Number", j.cust_name as "Customer", p.process_desc as "Process", s.Status_desc as "Status", count(r.roll_uid) as "Count"
	from job_tbl j, roll_tbl r, process_tbl p, roll_status_tbl s where j.job_uid = r.job_uid and p.pid = r.pid and r.status_uid = s.Status_uid
		and j.dlvr_dt is null and j.job_num = @JobNumber group by j.job_num, j.cust_name, p.process_desc, s.Status_desc order by j.job_num, p.process_desc, s.Status_desc

GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_BY_JOBUID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_BY_JOBUID]

@JobUid int

as

select distinct j.job_num as "Job Number", j.cust_name as "Customer", p.process_desc as "Process", s.Status_desc as "Status", count(r.roll_uid) as "Count"
	from job_tbl j, roll_tbl r, process_tbl p, roll_status_tbl s where j.job_uid = r.job_uid and p.pid = r.pid and r.status_uid = s.Status_uid
		and j.dlvr_dt is null and j.job_uid = @JobUid group by j.job_num, j.cust_name, p.process_desc, s.Status_desc order by j.job_num, p.process_desc, s.Status_desc


GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_LIKE_CUSTOMER_NAME]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_LIKE_CUSTOMER_NAME]

@CustomerName varchar(500)

as

select distinct j.job_num as "Job Number", j.cust_name as "Customer", p.process_desc as "Process", s.Status_desc as "Status", count(r.roll_uid) as "Count"
	from job_tbl j, roll_tbl r, process_tbl p, roll_status_tbl s where j.job_uid = r.job_uid and p.pid = r.pid and r.status_uid = s.Status_uid
		and j.dlvr_dt is null and j.cust_name like @CustomerName group by j.job_num, j.cust_name, p.process_desc, s.Status_desc order by j.job_num, p.process_desc, s.Status_desc

--drop procedure [DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_LIKE_CUSTOMER_NAME]
GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESSED_LOCATIONS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [syssql].[DIGITAL_REEL_JOB_PROCESSED_LOCATIONS]
	@job_num char(20)

as

--select distinct(s.storage_location_path) as "Storage Location Path" from job_tbl j, fiche_set_tbl fs, fiche_tbl f, storage_location_tbl s
	--where j.job_num = @job_num and fs.job_uid = j.job_uid and f.fiche_set_uid = fs.fiche_set_uid and 
	--	s.storage_location_uid = f.processed_storage_location_uid

select distinct(s.storage_location_path) as "Storage Location Path" from job_tbl j, roll_tbl r, storage_location_tbl s
	where j.job_num = @job_num and r.job_uid = j.job_uid and 
		s.storage_location_uid = r.processed_storage_location_uid
GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_ROLL_COUNT_BY_PID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [syssql].[DIGITAL_REEL_ROLL_COUNT_BY_PID]
	@PID int
AS

select j.job_num, j.cust_name, count(r.roll_name) as Count from roll_tbl r, job_tbl j where 
	r.job_uid = j.job_uid and r.pid = @PID and r.status_uid = 1 and j.dlvr_dt is null or
		dlvr_dt = '' group by j.job_num, j.cust_name order by j.job_num


GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_ROLL_COUNT_BY_PID_AND_STATUS_ID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [syssql].[DIGITAL_REEL_ROLL_COUNT_BY_PID_AND_STATUS_ID]
	@PID int, 
	@SID int
AS

select j.job_num, j.cust_name, count(r.roll_name) as Count from roll_tbl r, job_tbl j where 
	r.job_uid = j.job_uid and r.pid = @PID and r.status_uid = @SID and j.dlvr_dt is null or
		dlvr_dt = '' group by j.job_num, j.cust_name order by j.job_num



GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_ROLL_LIST_BY_PROCESS_STATUS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [syssql].[DIGITAL_REEL_ROLL_LIST_BY_PROCESS_STATUS]

@Job_uid int,
@PID int,
@Status_uid int

as

select RTrim(r.roll_name) as "Roll Name", RTrim(g.group_desc) as "Group", RTrim(u.user_name) as "Last Update By", r.UPDATE_DT as "Updated Date"
	from ROLL_TBL r, GROUP_TBL g, USER_TBL u where r.ROLL_GROUP_UID = g.GROUP_UID and r.UPDATE_USER_UID = u.USER_UID 
	
	and r.PID = @PID and r.STATUS_UID = @Status_UID and r.JOB_UID = @Job_Uid
	
	order by r.ROLL_NAME


GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Vendor list stored proc
CREATE  PROCEDURE [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST]	

AS
	select j.job_num as "Job Number", j.cust_name as "Job Name", r.roll_name as "Roll Name", 
	v.Vendor_Name as "Vendor Name", r.Update_dt "Last Updated" from job_tbl j, roll_tbl r, vendor_tbl v where
		r.pid = 8 and r.status_uid = 1 and j.job_uid = r.job_uid and 
			v.Vendor_uid = r.Mark_Vendor_uid and j.dlvr_dt is null order by j.job_uid, r.roll_name


GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST_NEW]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Vendor list stored proc
CREATE  PROCEDURE [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST_NEW]	

AS

select j.job_num as "Job Number", j.cust_name as "Job Name", r.roll_name as "Roll Name", 
v.Vendor_Name as "Vendor Name", r.Update_dt "Last Updated", r.PID 
from job_tbl j, roll_tbl r, vendor_tbl v, roll_process_tbl p
where j.job_uid = r.job_uid and j.job_uid = p.job_uid and r.pid = p.PID and p.PREV_PID = 8 and r.pid <> 9 and 
v.Vendor_uid = r.Mark_Vendor_uid and j.dlvr_dt is null order by j.job_uid, r.roll_name



GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST_WITH_PID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST_WITH_PID]	

@PID int

AS
	select j.job_num as "Job Number", j.cust_name as "Job Name", r.roll_name as "Roll Name", 
		v.Vendor_Name as "Vendor Name", r.Update_dt "Last Updated" from job_tbl j, roll_tbl r, 
		vendor_tbl v where
		r.PID = (select PREV_PID from roll_process_tbl where PID = @PID and JOB_UID = j.JOB_UID) and r.status_uid = 1 and j.job_uid = r.job_uid and 
		v.Vendor_uid = r.Mark_Vendor_uid and j.dlvr_dt is null order by j.job_uid, r.roll_name



GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST_WITH_PID_AND_STATUS_ID]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Vendor list stored proc
CREATE  PROCEDURE [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST_WITH_PID_AND_STATUS_ID]
	@PID int, 
	@SID int	

AS
	select j.job_num as "Job Number", j.cust_name as "Job Name", r.roll_name as "Roll Name", 
	v.Vendor_Name as "Vendor Name", r.Update_dt "Last Updated" from job_tbl j, roll_tbl r, vendor_tbl v where
		r.pid = @PID and r.status_uid = @SID and j.job_uid = r.job_uid and 
			v.Vendor_uid = r.Mark_Vendor_uid and j.dlvr_dt is null order by j.job_uid, r.roll_name



GO
/****** Object:  StoredProcedure [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_DETAILS_IN_LAST_HOURS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_DETAILS_IN_LAST_HOURS]
	@Hours int
AS

select e.EVENT_DT, J.job_num, J.cust_name, r.roll_name, p.process_desc, rs.status_desc, U.user_name, e.computer_name, e.err_msg
	from EVENT_TBL e, JOB_TBL j, ROLL_TBL r, PROCESS_TBL p, ROLL_STATUS_TBL rs, USER_TBL u, PROCESS_MANUAL_TBL pm
	
	where e.EVENT_DT >= DATEADD(hour, -@Hours, CURRENT_TIMESTAMP) and
	
	e.USER_UID = u.USER_UID and
	e.JOB_UID = j.JOB_UID and
	e.ROLL_UID = r.ROLL_UID and
	e.STATUS_UID = rs.STATUS_UID and
	e.PID = p.PID and
	e.PID = pm.pid and
	pm.STATUS_UID = 1 	
	
	order by e.EVENT_DT desc
GO
/****** Object:  StoredProcedure [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]
	@Minutes int
AS

select e.EVENT_DT, J.job_num, J.cust_name, r.roll_name, p.process_desc, rs.status_desc, U.user_name, e.computer_name, e.err_msg
	from EVENT_TBL e, JOB_TBL j, ROLL_TBL r, PROCESS_TBL p, ROLL_STATUS_TBL rs, USER_TBL u, PROCESS_MANUAL_TBL pm
	
	where e.EVENT_DT >= DATEADD(minute, -@Minutes, CURRENT_TIMESTAMP) and
	
	e.USER_UID = u.USER_UID and
	e.JOB_UID = j.JOB_UID and
	e.ROLL_UID = r.ROLL_UID and
	e.STATUS_UID = rs.STATUS_UID and
	e.PID = p.PID and
	e.PID = pm.pid and
	pm.STATUS_UID = 1 	
	
	order by e.EVENT_DT desc

GO
/****** Object:  StoredProcedure [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_SUMMARY_IN_LAST_HOURS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_SUMMARY_IN_LAST_HOURS]
	@Hours int
AS

select J.job_num, J.cust_name, p.process_desc, U.user_name, COUNT(e.roll_uid)
	from EVENT_TBL e, JOB_TBL j, ROLL_TBL r, PROCESS_TBL p, ROLL_STATUS_TBL rs, USER_TBL u, PROCESS_MANUAL_TBL pm
	
	where e.EVENT_DT >= DATEADD(hour, -@Hours, CURRENT_TIMESTAMP) and
	
	e.USER_UID = u.USER_UID and
	e.JOB_UID = j.JOB_UID and
	e.ROLL_UID = r.ROLL_UID and
	e.STATUS_UID = rs.STATUS_UID and
	e.PID = p.PID and
	e.PID = pm.pid and
	e.STATUS_UID = 1 and
	pm.STATUS_UID = 1 
	
	group by J.job_num, J.cust_name, p.process_desc, U.user_name	
	
	order by J.job_num, J.cust_name, p.process_desc, U.user_name desc
GO
/****** Object:  StoredProcedure [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]
	@Minutes int
AS

select J.job_num, J.cust_name, p.process_desc, U.user_name, COUNT(e.roll_uid)
	from EVENT_TBL e, JOB_TBL j, ROLL_TBL r, PROCESS_TBL p, ROLL_STATUS_TBL rs, USER_TBL u, PROCESS_MANUAL_TBL pm
	
	where e.EVENT_DT >= DATEADD(MINUTE, -@Minutes, CURRENT_TIMESTAMP) and
	
	e.USER_UID = u.USER_UID and
	e.JOB_UID = j.JOB_UID and
	e.ROLL_UID = r.ROLL_UID and
	e.STATUS_UID = rs.STATUS_UID and
	e.PID = p.PID and
	e.PID = pm.pid and
	e.STATUS_UID = 1 and
	pm.STATUS_UID = 1 
	
	group by J.job_num, J.cust_name, p.process_desc, U.user_name	
	
	order by J.job_num, J.cust_name, p.process_desc, U.user_name desc

GO
/****** Object:  StoredProcedure [syssql].[DR_ALL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [syssql].[DR_ALL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]
	@Minutes int
AS

select e.EVENT_DT, J.job_num, J.cust_name, r.roll_name, p.process_desc, rs.status_desc, U.user_name, e.computer_name, e.err_msg
	from EVENT_TBL e, JOB_TBL j, ROLL_TBL r, PROCESS_TBL p, ROLL_STATUS_TBL rs, USER_TBL u
	
	where e.EVENT_DT >= DATEADD(minute, -@Minutes, CURRENT_TIMESTAMP) and
	
	e.USER_UID = u.USER_UID and
	e.JOB_UID = j.JOB_UID and
	e.ROLL_UID = r.ROLL_UID and
	e.STATUS_UID = rs.STATUS_UID and
	e.PID = p.PID and	
	r.STATUS_UID = 1 	
	
	order by e.EVENT_DT desc


GO
/****** Object:  StoredProcedure [syssql].[DR_ALL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [syssql].[DR_ALL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]
	@Minutes int
AS

select J.job_num, J.cust_name, p.process_desc, U.user_name, COUNT(e.roll_uid)
	from EVENT_TBL e, JOB_TBL j, ROLL_TBL r, PROCESS_TBL p, ROLL_STATUS_TBL rs, USER_TBL u
	
	where e.EVENT_DT >= DATEADD(MINUTE, -@Minutes, CURRENT_TIMESTAMP) and
	
	e.USER_UID = u.USER_UID and
	e.JOB_UID = j.JOB_UID and
	e.ROLL_UID = r.ROLL_UID and
	e.STATUS_UID = rs.STATUS_UID and
	e.PID = p.PID and
	e.STATUS_UID = 1 and
	r.STATUS_UID = 1 
	
	group by J.job_num, J.cust_name, p.process_desc, U.user_name	
	
	order by J.job_num, J.cust_name, p.process_desc, U.user_name desc


GO
/****** Object:  StoredProcedure [syssql].[DR_ROLL_HISTORY]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [syssql].[DR_ROLL_HISTORY] 
	@RollUID int
as
select e.event_dt, p.process_desc, rs.status_desc, U.user_name, e.COMPUTER_NAME, e.err_msg from EVENT_TBL e, PROCESS_TBL p, ROLL_STATUS_TBL rs, USER_TBL u
	where e.ROLL_UID = @RollUID and p.PID = e.PID and u.USER_UID = e.user_uid and rs.STATUS_UID = e.STATUS_UID order by e.EVENT_DT desc


GO
/****** Object:  StoredProcedure [syssql].[GetCustNameJobNum]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [syssql].[GetCustNameJobNum]
(
	@JobNum char(10)
)
As
	select Job_Num, Cust_Name from job_tbl where job_num = @JobNum


GO
/****** Object:  StoredProcedure [syssql].[spJobNotOnTime]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [syssql].[spJobNotOnTime] (@JobUID as INT, @UploadID as INT, @HoursAllowed as INT ) AS
SET NOCOUNT ON

SELECT R.ROLL_NAME,
R.UPDATE_DT,
S.STATUS_DESC,
P.PROCESS_DESC,
L.STORAGE_LOCATION_PATH  
FROM ROLL_TBL R
JOIN GROUP_TBL G 
ON R.ROLL_GROUP_UID=G.GROUP_UID
JOIN ROLL_STATUS_TBL S
ON R.STATUS_UID=S.STATUS_UID
JOIN PROCESS_TBL P
ON R.PID=P.PID
JOIN STORAGE_LOCATION_TBL L
ON R.PROCESSED_STORAGE_LOCATION_UID=L.STORAGE_LOCATION_UID
WHERE 
	--job uid constant, sutter HCFA = 2111
	R.JOB_UID = @JobUID 
	AND    
	
	--relate to the group table
    R.ROLL_GROUP_UID = G.GROUP_UID  
    AND
	
	--check if this roll is uploaded to the customer ,upload PID = 648
    (R.PID <> @UploadID 
    AND R.STATUS_UID = 1)
    AND
    
    --subtract the hours allowed from the current date/time, if that
    --is larger than the julian date then this roll is late           
    DATEADD(HOUR, -@HoursAllowed, CURRENT_TIMESTAMP) >          
    DATEADD(DAY, (CAST(G.GROUP_DESC  AS INT) % 1000), CONVERT(DATETIME,'01/01/' + CONVERT(CHAR(2) , (CAST(G.GROUP_DESC  AS INT) / 1000)) )) 


GO
/****** Object:  Table [dbo].[ALERTS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ALERTS_TBL](
	[ALERT_UID] [int] NOT NULL,
	[LABEL] [varchar](100) NOT NULL,
	[QUERY_TEXT] [varchar](max) NOT NULL,
	[ALERT_RESULT] [bigint] NULL,
	[CLICK_LINK] [varchar](500) NULL,
	[USER_UID] [int] NOT NULL,
	[IS_ENABLED] [int] NULL,
	[AUTO_REFRESH] [int] NULL,
	[OPERATOR] [varchar](2) NULL,
	[ALERT_FREQUENCY_DT] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AMEREN]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AMEREN](
	[DOC_NUM] [char](15) NULL,
	[ROLL] [char](6) NULL,
	[FRAME] [int] NULL,
	[DESC] [char](4) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ARCH_VOL_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ARCH_VOL_TBL](
	[ARCH_VOL_UID] [int] NOT NULL,
	[ARCH_LABEL_NAME] [char](256) NOT NULL,
	[ARCH_VOL_NAME] [char](80) NOT NULL,
	[ARCH_VOL_SERIAL_NUM] [char](10) NOT NULL,
	[ARCH_VOL_TOT_SPACE_MB] [int] NOT NULL,
	[ARCH_VOL_AUTO_MIRRORED] [bit] NOT NULL,
	[ARCH_VOL_ASSIGNED_JOB_UID] [int] NULL,
	[ARCH_VOL_ASSIGNED_AS_PRIMARY] [bit] NOT NULL,
	[ARCH_VOL_ASSIGNED_AS_MIRROR] [bit] NOT NULL,
 CONSTRAINT [PK_ARCH_VOL_TBL] PRIMARY KEY NONCLUSTERED 
(
	[ARCH_VOL_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_ARCH_VOL_TBL_SERIAL_NUM_UNIQUE] UNIQUE NONCLUSTERED 
(
	[ARCH_VOL_SERIAL_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ATTACHMENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ATTACHMENT_TBL](
	[Guid] [varchar](50) NOT NULL,
	[Path] [varchar](255) NOT NULL,
	[Type] [varchar](100) NULL,
	[Filename] [varchar](100) NOT NULL,
	[Notes] [varchar](255) NULL,
	[UploadDate] [datetime] NOT NULL,
	[LastAccessed] [datetime] NULL,
 CONSTRAINT [PK_ATTACHMENT_TBL] PRIMARY KEY CLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BILL_ITEM_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BILL_ITEM_TBL](
	[BILL_ITEM_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ITEM_DESC] [nchar](100) NOT NULL,
	[ITEM_PRICE] [float] NOT NULL,
	[BILL_ITEM_UNIT_UID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[bill_item_unit_tbl]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bill_item_unit_tbl](
	[bill_item_unit_uid] [int] NOT NULL,
	[unit_desc] [nchar](100) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BINARIZE_TYPE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BINARIZE_TYPE_TBL](
	[BINARIZE_TYPE_UID] [int] NOT NULL,
	[BRIGHTNESS] [int] NOT NULL,
	[CONTRAST] [int] NOT NULL,
	[METHOD] [char](10) NOT NULL,
	[BASIC_DITHER] [bit] NOT NULL,
	[ADV_MODE] [char](10) NOT NULL,
	[ADV_LCE] [int] NOT NULL,
	[ADV_BACKGROUND] [int] NOT NULL,
	[ADV_LETTER] [int] NOT NULL,
	[DESPECK] [bit] NOT NULL,
	[DESPECK_MAX_WIDTH] [int] NOT NULL,
	[DESPECK_MAX_HEIGHT] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BOOK_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BOOK_TBL](
	[BOOK_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[START_ROLL_UID] [int] NULL,
	[END_ROLL_UID] [int] NULL,
	[BOOK_NAME] [char](50) NULL,
	[PG_CNT] [int] NULL,
	[NOTE_UID] [int] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_BOOK_TBL] PRIMARY KEY NONCLUSTERED 
(
	[BOOK_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BOX_BOX_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOX_BOX_TBL](
	[PARENT_BOX_NUM] [int] NOT NULL,
	[CHILD_BOX_NUM] [int] NOT NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_BOX_BOX_TBL] PRIMARY KEY CLUSTERED 
(
	[PARENT_BOX_NUM] ASC,
	[CHILD_BOX_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BOX_DESTRUCTION_ORDER_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOX_DESTRUCTION_ORDER_TBL](
	[DESTRUCTION_ORDER_UID] [int] NOT NULL,
	[BOX_NUM] [int] NOT NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_BOX_DESTRUCTION_ORDER_TBL] PRIMARY KEY CLUSTERED 
(
	[DESTRUCTION_ORDER_UID] ASC,
	[BOX_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BOX_JOB_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOX_JOB_TBL](
	[BOX_NUM] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_BOX_JOB_TBL] PRIMARY KEY CLUSTERED 
(
	[BOX_NUM] ASC,
	[JOB_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BOX_MATERIAL_TYPE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOX_MATERIAL_TYPE_TBL](
	[BOX_NUM] [int] NOT NULL,
	[MATERIAL_TYPE_UID] [int] NOT NULL,
 CONSTRAINT [PK_BOX_MATERIAL_TYPE_TBL] PRIMARY KEY CLUSTERED 
(
	[BOX_NUM] ASC,
	[MATERIAL_TYPE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BOX_SOP_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOX_SOP_TBL](
	[BOX_NUM] [int] NOT NULL,
	[SOPId] [int] NOT NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_BOX_SOP_TBL] PRIMARY KEY CLUSTERED 
(
	[BOX_NUM] ASC,
	[SOPId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BOX_STORAGE_LOCATION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOX_STORAGE_LOCATION_TBL](
	[BOX_STORAGE_LOCATION_UID] [int] NOT NULL,
	[SITE] [nvarchar](50) NOT NULL,
	[LOCATION] [text] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_BOX_STORAGE_LOCATION_TBL] PRIMARY KEY CLUSTERED 
(
	[BOX_STORAGE_LOCATION_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BOX_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOX_TBL](
	[BOX_NUM] [int] NOT NULL,
	[BOX_TYPE_UID] [int] NOT NULL,
	[CUST_BOX_NUM] [text] NULL,
	[CUST_NUM] [nvarchar](100) NULL,
	[CUST_NAME] [nvarchar](100) NULL,
	[RCVD_DT] [datetime] NULL,
	[RCVD_SHIPMENT_CARRIER_UID] [int] NULL,
	[RCVD_SHIPMENT_TRACKING_NUM] [nvarchar](100) NULL,
	[BOX_STORAGE_LOCATION_UID] [int] NOT NULL,
	[CHECKED_OUT] [bit] NOT NULL,
	[NOTES] [text] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
	[HIDDEN] [bit] NOT NULL,
	[RETURN_DT] [datetime] NULL,
	[RETURN_SHIPMENT_CARRIER_UID] [int] NULL,
	[RETURN_SHIPMENT_TRACKING_NUM] [nvarchar](100) NULL,
	[RETURN_CONTACT_INFO] [text] NULL,
	[RETURN_BMI_DLVR_DRIVER_UID] [int] NULL,
	[RETURN_SHIPPING_COST] [nvarchar](100) NULL,
 CONSTRAINT [PK_BOX_TBL] PRIMARY KEY CLUSTERED 
(
	[BOX_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BOX_TYPE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BOX_TYPE_TBL](
	[BOX_TYPE_UID] [int] NOT NULL,
	[DESCRIPTION] [varchar](200) NOT NULL,
 CONSTRAINT [PK_BOX_TYPE_TBL] PRIMARY KEY CLUSTERED 
(
	[BOX_TYPE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CLIENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CLIENT_TBL](
	[CLIENT_UID] [int] NOT NULL,
	[CLIENT_NAME] [char](50) NOT NULL,
	[CONTACT_FIRST_NAME] [char](50) NULL,
	[CONTACT_LAST_NAME] [char](50) NULL,
	[PHONE_AREA_CODE] [char](3) NULL,
	[PHONE_PREFIX] [char](3) NULL,
	[PHONE_SUFFIX] [char](4) NULL,
	[PHONE_EXT] [char](6) NULL,
	[ADDRESS1] [char](100) NULL,
	[ADDRESS2] [char](100) NULL,
	[CITY] [char](100) NULL,
	[STATE] [char](2) NULL,
	[ZIP] [char](10) NULL,
	[NOTE_UID] [int] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[COST_ITEM_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COST_ITEM_TBL](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[Cost_Item_Unit_Uid] [int] NOT NULL,
	[Vendor_Uid] [int] NOT NULL,
	[Item_Desc] [nvarchar](100) NOT NULL,
	[Item_Cost] [float] NOT NULL,
	[Job_Cost_Item_Uid] [int] NOT NULL,
	[Include_File_Mask] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_COST_ITEM_TBL] PRIMARY KEY CLUSTERED 
(
	[Job_Cost_Item_Uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [AK_CostItem] UNIQUE NONCLUSTERED 
(
	[JOB_UID] ASC,
	[PID] ASC,
	[Cost_Item_Unit_Uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[COST_ITEM_UNIT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COST_ITEM_UNIT_TBL](
	[COST_ITEM_UNIT_UID] [int] NOT NULL,
	[unit_desc] [nchar](20) NOT NULL,
 CONSTRAINT [PK_COST_ITEM_UNIT_TBL] PRIMARY KEY CLUSTERED 
(
	[COST_ITEM_UNIT_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CUSTOM_REPORT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CUSTOM_REPORT_TBL](
	[Custom_Report_UID] [int] NOT NULL,
	[Label] [varchar](100) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Icon] [varchar](50) NOT NULL,
	[QueryText] [varchar](max) NOT NULL,
	[PanelStyle] [varchar](50) NULL,
	[User_UID] [int] NULL,
	[IsEnabled] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DELIVERABLE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DELIVERABLE_TBL](
	[DELIVERABLE_UID] [int] NOT NULL,
	[QUANTITY] [text] NULL,
	[DLVR_DT] [datetime] NULL,
	[DLVR_METHOD] [nvarchar](100) NULL,
	[CONTACT_INFO] [text] NULL,
	[BMI_DLVR_DRIVER_UID] [int] NULL,
	[SHIPPED_VIA] [nvarchar](100) NULL,
	[TRACKING_NUMBER] [nvarchar](100) NULL,
	[SHIPPING_COST] [nvarchar](100) NULL,
	[NOTES] [text] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_DELIVERABLE_TBL] PRIMARY KEY CLUSTERED 
(
	[DELIVERABLE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DESTRUCTION_ORDER_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DESTRUCTION_ORDER_TBL](
	[DESTRUCTION_ORDER_UID] [int] NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESTRUCTION_METHOD_UID] [int] NULL,
	[DESTRUCTION_FACILITY_UID] [int] NULL,
	[LETTER] [nvarchar](200) NULL,
	[CERTIFICATION] [nvarchar](200) NULL,
 CONSTRAINT [PK_DESTRUCTION_ORDER_TBL] PRIMARY KEY CLUSTERED 
(
	[DESTRUCTION_ORDER_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DIRECTORY_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DIRECTORY_TBL](
	[DIR_UID] [int] NOT NULL,
	[SEQ_ID] [int] NOT NULL,
	[DIRECTORY] [char](255) NOT NULL,
 CONSTRAINT [PK_DIRECTORY_TBL] PRIMARY KEY CLUSTERED 
(
	[DIR_UID] ASC,
	[SEQ_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DOCUMENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DOCUMENT_TBL](
	[DocumentId] [int] NOT NULL,
	[Filename] [varchar](250) NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[Description] [varchar](500) NULL,
	[Labels] [varchar](250) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[GUID] [varchar](50) NOT NULL,
	[LastAccessedBy] [int] NOT NULL,
	[LastAccessedDate] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DOCUMENT_VERSION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DOCUMENT_VERSION_TBL](
	[DocumentId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[Notes] [varchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[GUID] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DVD_VOL_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DVD_VOL_TBL](
	[DVD_ID] [char](25) NOT NULL,
	[JOB_UID] [int] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_DVD_VOL_TBL] PRIMARY KEY NONCLUSTERED 
(
	[DVD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EVENT_FILTER_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVENT_FILTER_TBL](
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
 CONSTRAINT [PK_EVENT_FILTER_TBL] PRIMARY KEY CLUSTERED 
(
	[PID] ASC,
	[STATUS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EVENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EVENT_TBL](
	[EVENT_UID] [int] NOT NULL,
	[EVENT_DT] [datetime] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ROLL_UID] [int] NOT NULL,
	[FICHE_UID] [int] NULL,
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
	[USER_UID] [int] NOT NULL,
	[COMPUTER_NAME] [char](80) NOT NULL,
	[ERR_MSG] [char](255) NULL,
 CONSTRAINT [PK_EVENT_TBL] PRIMARY KEY CLUSTERED 
(
	[EVENT_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EVENT_TBL_2015]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EVENT_TBL_2015](
	[EVENT_UID] [int] NOT NULL,
	[EVENT_DT] [datetime] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ROLL_UID] [int] NOT NULL,
	[FICHE_UID] [int] NULL,
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
	[USER_UID] [int] NOT NULL,
	[COMPUTER_NAME] [char](80) NOT NULL,
	[ERR_MSG] [char](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EVENT_TBL_2016]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EVENT_TBL_2016](
	[EVENT_UID] [int] NOT NULL,
	[EVENT_DT] [datetime] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ROLL_UID] [int] NOT NULL,
	[FICHE_UID] [int] NULL,
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
	[USER_UID] [int] NOT NULL,
	[COMPUTER_NAME] [char](80) NOT NULL,
	[ERR_MSG] [char](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EVENT_TBL_2017]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EVENT_TBL_2017](
	[EVENT_UID] [int] NOT NULL,
	[EVENT_DT] [datetime] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ROLL_UID] [int] NOT NULL,
	[FICHE_UID] [int] NULL,
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
	[USER_UID] [int] NOT NULL,
	[COMPUTER_NAME] [char](80) NOT NULL,
	[ERR_MSG] [char](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EVENT_TBL_2018]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EVENT_TBL_2018](
	[EVENT_UID] [int] NOT NULL,
	[EVENT_DT] [datetime] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ROLL_UID] [int] NOT NULL,
	[FICHE_UID] [int] NULL,
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
	[USER_UID] [int] NOT NULL,
	[COMPUTER_NAME] [char](80) NOT NULL,
	[ERR_MSG] [char](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[event_tbl_2019]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[event_tbl_2019](
	[EVENT_UID] [int] NOT NULL,
	[EVENT_DT] [datetime] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ROLL_UID] [int] NOT NULL,
	[FICHE_UID] [int] NULL,
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
	[USER_UID] [int] NOT NULL,
	[COMPUTER_NAME] [char](80) NOT NULL,
	[ERR_MSG] [char](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_EXCLUDE_JOB_PROCESS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_EXCLUDE_JOB_PROCESS_TBL](
	[Execution_Plan_UID] [int] NOT NULL,
	[Job_Uid] [int] NOT NULL,
	[PID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_EXCLUDE_JOB_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_EXCLUDE_JOB_TBL](
	[Execution_Plan_UID] [int] NOT NULL,
	[Job_Uid] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_EXCLUDE_PROCESS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_EXCLUDE_PROCESS_TBL](
	[Execution_Plan_UID] [int] NOT NULL,
	[PID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_INCLUDE_JOB_PROCESS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_INCLUDE_JOB_PROCESS_TBL](
	[Execution_Plan_UID] [int] NOT NULL,
	[Job_Uid] [int] NOT NULL,
	[PID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_INCLUDE_JOB_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_INCLUDE_JOB_TBL](
	[Execution_Plan_UID] [int] NOT NULL,
	[Job_Uid] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_INCLUDE_PROCESS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_INCLUDE_PROCESS_TBL](
	[Execution_Plan_UID] [int] NOT NULL,
	[PID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_JOB_PROCESS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_JOB_PROCESS_TBL](
	[Execution_Plan_UID] [int] NOT NULL,
	[Job_Uid] [int] NOT NULL,
	[PID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_STATION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_STATION_TBL](
	[EXECUTION_PLAN_UID] [int] NOT NULL,
	[STATION_UID] [int] NOT NULL,
	[PRIORITY] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_TBL](
	[EXECUTION_PLAN_UID] [int] NOT NULL,
	[PLAN_NAME] [varchar](128) NOT NULL,
 CONSTRAINT [PK_EXECUTION_PLAN_TBL] PRIMARY KEY CLUSTERED 
(
	[EXECUTION_PLAN_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_ARCH_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FICHE_ARCH_TBL](
	[FICHE_UID] [int] NOT NULL,
	[ARCH_VOL_UID] [int] NOT NULL,
	[MIRROR_ARCH_VOL_UID] [int] NOT NULL,
	[ESTIMATE_SIZE_MB] [int] NOT NULL,
	[ACTUAL_SIZE_MB] [int] NULL,
	[ARCHIVE_DT] [datetime] NULL,
 CONSTRAINT [PK_FICHE_ARCH_TBL] PRIMARY KEY NONCLUSTERED 
(
	[FICHE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[fiche_bill_event_tbl]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fiche_bill_event_tbl](
	[fiche_uid] [int] NOT NULL,
	[bill_item_uid] [int] NOT NULL,
	[bill_item_count] [int] NOT NULL,
	[bill_event_dt] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FICHE_META_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_META_TBL](
	[FICHE_UID] [int] NOT NULL,
	[MetaData] [varchar](5000) NULL,
 CONSTRAINT [PK_FICHE_META_TBL] PRIMARY KEY NONCLUSTERED 
(
	[FICHE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_PROCESS_COST_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FICHE_PROCESS_COST_TBL](
	[Vendor_Uid] [int] NOT NULL,
	[Job_Uid] [int] NOT NULL,
	[Pid] [int] NOT NULL,
	[Fiche_Uid] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[Job_Cost_Item_Uid] [int] NULL,
	[DateTime] [datetime] NULL,
 CONSTRAINT [AK_FicheProcessCost] UNIQUE NONCLUSTERED 
(
	[Job_Uid] ASC,
	[Pid] ASC,
	[Fiche_Uid] ASC,
	[Job_Cost_Item_Uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FICHE_PROCESS_EXPECTANCY]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FICHE_PROCESS_EXPECTANCY](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Count] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FICHE_PROCESS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FICHE_PROCESS_TBL](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[PREV_PID] [int] NULL,
	[CONT_STATUS_UID] [int] NULL,
	[INPUT_DIR_UID] [int] NULL,
	[OUTPUT_DIR_UID] [int] NULL,
	[EXPECTANCY] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FICHE_SET_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_SET_TBL](
	[FICHE_SET_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[FICHE_GROUP_UID] [int] NOT NULL,
	[FICHE_NAME] [char](255) NOT NULL,
 CONSTRAINT [PK_FICHE_SET_TBL] PRIMARY KEY NONCLUSTERED 
(
	[FICHE_SET_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_FICHE_SET_TBL] UNIQUE NONCLUSTERED 
(
	[JOB_UID] ASC,
	[FICHE_GROUP_UID] ASC,
	[FICHE_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_SET_TBL_2016]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_SET_TBL_2016](
	[FICHE_SET_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[FICHE_GROUP_UID] [int] NOT NULL,
	[FICHE_NAME] [char](255) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_SET_TBL_2017]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_SET_TBL_2017](
	[FICHE_SET_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[FICHE_GROUP_UID] [int] NOT NULL,
	[FICHE_NAME] [char](255) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_SET_TBL_2018]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_SET_TBL_2018](
	[FICHE_SET_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[FICHE_GROUP_UID] [int] NOT NULL,
	[FICHE_NAME] [char](255) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_STATUS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_STATUS_TBL](
	[STATUS_UID] [int] NOT NULL,
	[STATUS_DESC] [char](20) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_TBL](
	[FICHE_UID] [int] NOT NULL,
	[FICHE_TYPE_UID] [int] NULL,
	[FICHE_SET_UID] [int] NOT NULL,
	[FICHE_NUMBER] [int] NOT NULL,
	[STATION_UID] [int] NULL,
	[DVD_ID] [int] NULL,
	[RAW_IMG_CNT] [int] NULL,
	[FOUND_PG_CNT] [int] NULL,
	[FICHE_SZ_ON_DISK_MB] [int] NULL,
	[IP_ROTATE] [int] NULL,
	[IP_MIRROR] [bit] NULL,
	[DIRECTION] [char](20) NULL,
	[NOTE_UID] [int] NULL,
	[CREATE_USER_UID] [int] NULL,
	[SCAN_USER_UID] [int] NULL,
	[IP_USER_UID] [int] NULL,
	[MARK_USER_UID] [int] NULL,
	[DLVR_USER_UID] [int] NULL,
	[MARK_VENDOR_UID] [int] NULL,
	[SCAN_TM_SECS] [int] NULL,
	[IP_TM_SECS] [int] NULL,
	[MARK_TM_SECS] [int] NULL,
	[PID] [int] NOT NULL,
	[RAW_STORAGE_LOCATION_UID] [int] NULL,
	[PROCESSED_STORAGE_LOCATION_UID] [int] NULL,
	[STATUS_UID] [int] NOT NULL,
	[ERR_MSG] [char](255) NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
	[FINAL_PG_CNT] [int] NULL,
 CONSTRAINT [PK_FICHE_TBL] PRIMARY KEY NONCLUSTERED 
(
	[FICHE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_TBL_2016]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_TBL_2016](
	[FICHE_UID] [int] NOT NULL,
	[FICHE_TYPE_UID] [int] NULL,
	[FICHE_SET_UID] [int] NOT NULL,
	[FICHE_NUMBER] [int] NOT NULL,
	[STATION_UID] [int] NULL,
	[DVD_ID] [int] NULL,
	[RAW_IMG_CNT] [int] NULL,
	[FOUND_PG_CNT] [int] NULL,
	[FICHE_SZ_ON_DISK_MB] [int] NULL,
	[IP_ROTATE] [int] NULL,
	[IP_MIRROR] [bit] NULL,
	[DIRECTION] [char](20) NULL,
	[NOTE_UID] [int] NULL,
	[CREATE_USER_UID] [int] NULL,
	[SCAN_USER_UID] [int] NULL,
	[IP_USER_UID] [int] NULL,
	[MARK_USER_UID] [int] NULL,
	[DLVR_USER_UID] [int] NULL,
	[MARK_VENDOR_UID] [int] NULL,
	[SCAN_TM_SECS] [int] NULL,
	[IP_TM_SECS] [int] NULL,
	[MARK_TM_SECS] [int] NULL,
	[PID] [int] NOT NULL,
	[RAW_STORAGE_LOCATION_UID] [int] NULL,
	[PROCESSED_STORAGE_LOCATION_UID] [int] NULL,
	[STATUS_UID] [int] NOT NULL,
	[ERR_MSG] [char](255) NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_TBL_2017]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_TBL_2017](
	[FICHE_UID] [int] NOT NULL,
	[FICHE_TYPE_UID] [int] NULL,
	[FICHE_SET_UID] [int] NOT NULL,
	[FICHE_NUMBER] [int] NOT NULL,
	[STATION_UID] [int] NULL,
	[DVD_ID] [int] NULL,
	[RAW_IMG_CNT] [int] NULL,
	[FOUND_PG_CNT] [int] NULL,
	[FICHE_SZ_ON_DISK_MB] [int] NULL,
	[IP_ROTATE] [int] NULL,
	[IP_MIRROR] [bit] NULL,
	[DIRECTION] [char](20) NULL,
	[NOTE_UID] [int] NULL,
	[CREATE_USER_UID] [int] NULL,
	[SCAN_USER_UID] [int] NULL,
	[IP_USER_UID] [int] NULL,
	[MARK_USER_UID] [int] NULL,
	[DLVR_USER_UID] [int] NULL,
	[MARK_VENDOR_UID] [int] NULL,
	[SCAN_TM_SECS] [int] NULL,
	[IP_TM_SECS] [int] NULL,
	[MARK_TM_SECS] [int] NULL,
	[PID] [int] NOT NULL,
	[RAW_STORAGE_LOCATION_UID] [int] NULL,
	[PROCESSED_STORAGE_LOCATION_UID] [int] NULL,
	[STATUS_UID] [int] NOT NULL,
	[ERR_MSG] [char](255) NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_TBL_2018]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_TBL_2018](
	[FICHE_UID] [int] NOT NULL,
	[FICHE_TYPE_UID] [int] NULL,
	[FICHE_SET_UID] [int] NOT NULL,
	[FICHE_NUMBER] [int] NOT NULL,
	[STATION_UID] [int] NULL,
	[DVD_ID] [int] NULL,
	[RAW_IMG_CNT] [int] NULL,
	[FOUND_PG_CNT] [int] NULL,
	[FICHE_SZ_ON_DISK_MB] [int] NULL,
	[IP_ROTATE] [int] NULL,
	[IP_MIRROR] [bit] NULL,
	[DIRECTION] [char](20) NULL,
	[NOTE_UID] [int] NULL,
	[CREATE_USER_UID] [int] NULL,
	[SCAN_USER_UID] [int] NULL,
	[IP_USER_UID] [int] NULL,
	[MARK_USER_UID] [int] NULL,
	[DLVR_USER_UID] [int] NULL,
	[MARK_VENDOR_UID] [int] NULL,
	[SCAN_TM_SECS] [int] NULL,
	[IP_TM_SECS] [int] NULL,
	[MARK_TM_SECS] [int] NULL,
	[PID] [int] NOT NULL,
	[RAW_STORAGE_LOCATION_UID] [int] NULL,
	[PROCESSED_STORAGE_LOCATION_UID] [int] NULL,
	[STATUS_UID] [int] NOT NULL,
	[ERR_MSG] [char](255) NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_TYPE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FICHE_TYPE_TBL](
	[FICHE_TYPE_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[FICHE_SIZE] [char](2) NULL,
	[DPI] [int] NULL,
	[RAW_IMG_CNT] [int] NULL,
	[RAW_WDTH_PIX] [int] NULL,
	[RAW_HGHT_PIX] [int] NULL,
	[RDCT_RATIO] [int] NULL,
	[FRAME_CNT] [int] NULL,
	[TYPE_DESC] [char](100) NULL,
	[NOTE_UID] [int] NULL,
	[SCANNER_CFG_FILE] [char](255) NULL,
	[IP_CFG_FILE] [char](255) NULL,
	[BENCHMARK_DIR] [char](255) NULL,
	[SETUP_USER_UID] [int] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_VAULT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FICHE_VAULT_TBL](
	[FICHE_UID] [int] NOT NULL,
	[VAULT_VOL_UID] [int] NOT NULL,
	[ACTUAL_SIZE_MB] [int] NOT NULL,
	[ARCHIVE_DT] [datetime] NOT NULL,
	[TIME_MINS] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GROUP_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GROUP_TBL](
	[GROUP_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[GROUP_DESC] [varchar](224) NOT NULL,
 CONSTRAINT [PK_GROUP_TBL] PRIMARY KEY NONCLUSTERED 
(
	[GROUP_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GROUP_USER_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GROUP_USER_TBL](
	[USER_GROUP_UID] [int] NOT NULL,
	[USER_UID] [int] NOT NULL,
 CONSTRAINT [PK_GROUP_USER_TBL] PRIMARY KEY CLUSTERED 
(
	[USER_GROUP_UID] ASC,
	[USER_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[INSTRUCTIONS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[INSTRUCTIONS_TBL](
	[INSTRUCTIONS_UID] [int] NOT NULL,
	[INSTRUCTIONS_DATA] [varbinary](max) NULL,
	[LAST_UPDATED_DT] [datetime] NOT NULL,
	[LAST_UPDATED_BY] [int] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[INSTRUCTION_FILE_PATH] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[INVOICE_SERVICE_COUNT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[INVOICE_SERVICE_COUNT_TBL](
	[INVOICE_SERVICE_COUNT_UID] [int] NOT NULL,
	[INVOICE_UID] [int] NOT NULL,
	[SERVICE] [varchar](50) NOT NULL,
	[COUNT] [decimal](18, 10) NOT NULL,
	[NOTE] [varchar](1024) NULL,
	[ENTERED_DT] [datetime] NOT NULL,
	[ENTERED_USER_UID] [int] NOT NULL,
	[VALIDATED] [int] NOT NULL,
	[VALIDATED_DT] [datetime] NULL,
	[VALIDATED_USER_UID] [int] NULL,
 CONSTRAINT [PK_INVOICE_SERVICE_COUNT_TBL] PRIMARY KEY CLUSTERED 
(
	[INVOICE_SERVICE_COUNT_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[INVOICE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[INVOICE_TBL](
	[INVOICE_UID] [int] NOT NULL,
	[INVOICE_NUM] [varchar](100) NOT NULL,
	[INVOICE_DT] [datetime] NULL,
	[INVOICE_MEMO] [text] NULL,
	[TAXABLE] [bit] NOT NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
	[JOB_UID] [int] NULL,
 CONSTRAINT [PK_INVOICE_TBL] PRIMARY KEY CLUSTERED 
(
	[INVOICE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JOB_BOX_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOB_BOX_TBL](
	[Job_Uid] [int] NOT NULL,
	[Box_Num] [int] NOT NULL,
	[Customer_Box_Num] [text] NULL,
	[Box_Notes] [text] NULL,
 CONSTRAINT [PK_JOB_BOX_TBL] PRIMARY KEY CLUSTERED 
(
	[Job_Uid] ASC,
	[Box_Num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JOB_CLIENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOB_CLIENT_TBL](
	[JOB_UID] [int] NOT NULL,
	[CLIENT_UID] [int] NOT NULL,
	[TARG_DLVR_DT] [datetime] NULL,
	[DLVR_DT] [datetime] NULL,
	[DLVR_SETS_NUM] [int] NULL,
	[NOTE_UID] [int] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JOB_NOTES]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOB_NOTES](
	[Note_Uid] [int] IDENTITY(1,1) NOT NULL,
	[Notes] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JOB_PROCESS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOB_PROCESS_TBL](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[PREV_PID] [int] NULL,
	[CONT_STATUS_UID] [int] NULL,
 CONSTRAINT [PK_JOB_PROCESS_TBL] PRIMARY KEY NONCLUSTERED 
(
	[JOB_UID] ASC,
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JOB_ROLL_BINARIZE_TYPE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JOB_ROLL_BINARIZE_TYPE_TBL](
	[JOB_UID] [int] NOT NULL,
	[BINARIZE_TYPE_UID] [int] NOT NULL,
	[TYPE_DESC] [char](100) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JOB_SERVICE_COUNT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JOB_SERVICE_COUNT_TBL](
	[JOB_SERVICE_COUNT_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[SERVICE] [varchar](50) NULL,
	[COUNT] [decimal](18, 10) NULL,
	[NOTE] [varchar](1024) NULL,
	[ENTERED_DT] [datetime] NOT NULL,
	[ENTERED_USER_UID] [int] NOT NULL,
	[VALIDATED] [int] NOT NULL,
	[VALIDATED_DT] [datetime] NULL,
	[VALIDATED_USER_UID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JOB_SERVICE_COUNT_TBL_DUPS]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JOB_SERVICE_COUNT_TBL_DUPS](
	[JOB_SERVICE_COUNT_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[SERVICE] [varchar](25) NOT NULL,
	[COUNT] [decimal](18, 10) NULL,
	[NOTE] [varchar](1024) NULL,
	[ENTERED_DT] [datetime] NOT NULL,
	[ENTERED_USER_UID] [int] NOT NULL,
	[VALIDATED] [int] NOT NULL,
	[VALIDATED_DT] [datetime] NULL,
	[VALIDATED_USER_UID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JOB_STATUS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JOB_STATUS_TBL](
	[STATUS_UID] [int] NOT NULL,
	[STATUS_DESC] [varchar](20) NOT NULL,
 CONSTRAINT [PK_JOB_STATUS_TBL] PRIMARY KEY NONCLUSTERED 
(
	[STATUS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JOB_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JOB_TBL](
	[JOB_UID] [int] NOT NULL,
	[JOB_NUM] [char](10) NOT NULL,
	[CUST_NAME] [char](50) NOT NULL,
	[PRIORITY] [int] NOT NULL,
	[THRESHOLD] [float] NOT NULL,
	[IN_DT] [datetime] NULL,
	[TARG_COMP_DT] [datetime] NULL,
	[COMP_DT] [datetime] NULL,
	[DLVR_DT] [datetime] NULL,
	[DLVR_SETS_NUM] [int] NULL,
	[BACKUP_DVD] [bit] NULL,
	[BACKUP_HD] [bit] NULL,
	[NOTE_UID] [int] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
	[PM_USER_UID] [int] NULL,
	[Sales_Person_User_Uid] [int] NULL,
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
	[ROLL_PROCESS_LOCKED] [bit] NULL,
	[FICHE_PROCESS_LOCKED] [bit] NULL,
	[CODENAME] [nvarchar](50) NULL,
	[Is_Template] [bit] NULL,
	[Job_Name] [char](255) NULL,
	[PO_Number] [varchar](255) NULL,
	[TAXABLE] [bit] NOT NULL,
	[Job_Note_Uid] [int] NULL,
	[HomeFolder] [nvarchar](max) NULL,
	[RollCount] [int] NULL,
	[FicheCount] [int] NULL,
	[FULLY_INVOICED] [int] NULL,
 CONSTRAINT [PK_JOB_TBL] PRIMARY KEY NONCLUSTERED 
(
	[JOB_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JOB_VENDOR_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOB_VENDOR_TBL](
	[JOB_UID] [int] NOT NULL,
	[VENDOR_UID] [int] NOT NULL,
	[SEQ_ID] [int] NOT NULL,
	[LAST_USED] [bit] NULL,
 CONSTRAINT [PK_JOB_VENDOR_TBL] PRIMARY KEY CLUSTERED 
(
	[JOB_UID] ASC,
	[VENDOR_UID] ASC,
	[SEQ_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MAINTENANCE_ITEM_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAINTENANCE_ITEM_TBL](
	[MAINTENANCE_ITEM_UID] [int] NOT NULL,
	[SOPNumber] [varchar](255) NOT NULL,
	[MODEL] [varchar](100) NULL,
	[DESCRIPTION] [varchar](200) NOT NULL,
	[SERIAL_NUMBER] [varchar](100) NOT NULL,
	[UNIT_ID] [varchar](100) NULL,
	[LOCATION_NAME] [char](100) NULL,
	[LOCATION_STREET] [char](100) NULL,
	[LOCATION_STREET2] [char](100) NULL,
	[LOCATION_CITY] [char](100) NULL,
	[LOCATION_STATE] [char](2) NULL,
	[LOCATION_ZIP] [char](10) NULL,
	[LOCATION_ATTENTION] [char](100) NULL,
	[LOCATION_PHONE] [char](20) NULL,
	[LOCATION] [varchar](200) NULL,
	[RESPONSE_HOURS] [decimal](18, 10) NULL,
	[INSTALLED_DT] [datetime] NULL,
	[DELETED] [bit] NOT NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_MAINTENANCE_ITEM_TBL] PRIMARY KEY CLUSTERED 
(
	[MAINTENANCE_ITEM_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MARININDEX_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MARININDEX_TBL](
	[NAME] [varchar](20) NULL,
	[PG_CNT] [int] NOT NULL,
	[Sequence] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MarinReport_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MarinReport_TBL](
	[RollUID] [int] NOT NULL,
	[RollName] [char](50) NOT NULL,
	[Document] [char](50) NULL,
	[PageNumber] [int] NULL,
	[Message] [char](500) NULL,
	[ProcessType] [int] NOT NULL,
	[Status] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MATERIAL_TYPE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MATERIAL_TYPE_TBL](
	[MATERIAL_TYPE_UID] [int] NOT NULL,
	[MATERIAL] [varchar](100) NOT NULL,
	[DESCRIPTION] [varchar](200) NOT NULL,
 CONSTRAINT [PK_MATERIAL_TYPE_TBL] PRIMARY KEY CLUSTERED 
(
	[MATERIAL_TYPE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MTS_EVENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MTS_EVENT_TBL](
	[EVENT_UID] [int] NOT NULL,
	[EVENT_DT] [datetime] NOT NULL,
	[EVENT_TYPE] [nvarchar](50) NOT NULL,
	[BOX_NUM] [int] NOT NULL,
	[BOX_STORAGE_LOCATION_UID] [int] NULL,
	[EVENT_DATA] [text] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_MTS_EVENT_TBL] PRIMARY KEY CLUSTERED 
(
	[EVENT_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MTS_STATION_USER_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MTS_STATION_USER_TBL](
	[USER_UID] [int] NOT NULL,
	[BOX_STORAGE_LOCATION_UID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NOTE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NOTE_TBL](
	[NOTE_UID] [int] NOT NULL,
	[NOTE_TEXT] [text] NOT NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_NOTE_TBL] PRIMARY KEY NONCLUSTERED 
(
	[NOTE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NOTIFICATION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NOTIFICATION_TBL](
	[NOTIFICATION_UID] [int] NOT NULL,
	[NOTIFICATION_DESC] [nchar](100) NOT NULL,
	[SQL_FILE] [nchar](500) NOT NULL,
	[SQL_RESULT_EXPECTED] [int] NOT NULL,
	[RESULT_OPERATOR] [nchar](10) NOT NULL,
	[NOTIFICATION_TYPE] [nchar](10) NOT NULL,
	[NOTIFICATION_RECIPIENTS] [nchar](500) NOT NULL,
	[RESULT_TYPE] [nchar](10) NOT NULL,
	[NOTIFICATION_INTERVAL_MIN] [int] NOT NULL,
	[LAST_NOTIFICATION_DT] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OBJECT_TYPE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OBJECT_TYPE_TBL](
	[OBJECT_TYPE_UID] [int] NOT NULL,
	[OBJECT_TYPE_NAME] [char](50) NOT NULL,
	[OBJECT_TYPE_DESC] [char](255) NOT NULL,
 CONSTRAINT [PK_OBJECT_TYPE_TBL] PRIMARY KEY CLUSTERED 
(
	[OBJECT_TYPE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PQ_TITLE_AUTH_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PQ_TITLE_AUTH_TBL](
	[TitleId] [char](20) NOT NULL,
	[NewsPaperTitle] [char](255) NOT NULL,
 CONSTRAINT [PK_PQ_TITLE_AUTH_TBL] PRIMARY KEY NONCLUSTERED 
(
	[TitleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PROCESS_GROUP_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PROCESS_GROUP_TBL](
	[PROCESS_GROUP_NAME] [varchar](50) NOT NULL,
	[PID] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PROCESS_MACHINE_LOCK_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PROCESS_MACHINE_LOCK_TBL](
	[COMPUTER_NAME] [varchar](50) NOT NULL,
	[IsLocked] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PROCESS_MANUAL_INSTRUCTION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROCESS_MANUAL_INSTRUCTION_TBL](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
	[INST_UPDATE_DT] [datetime] NOT NULL,
	[INSTRUCTION_UID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PROCESS_PARAM_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PROCESS_PARAM_TBL](
	[PID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ParamName] [varchar](250) NOT NULL,
	[ParamValue] [varchar](500) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PROCESS_STATION_LOCATION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROCESS_STATION_LOCATION_TBL](
	[PROCESS_STATION_UID] [int] NOT NULL,
	[LOCATION_TYPE_UID] [int] NOT NULL,
	[STORAGE_LOCATION_UID] [int] NOT NULL,
	[SEQ_ID] [int] NOT NULL,
 CONSTRAINT [PK_PROCESS_STATION_LOCATION_TBL] PRIMARY KEY CLUSTERED 
(
	[PROCESS_STATION_UID] ASC,
	[LOCATION_TYPE_UID] ASC,
	[STORAGE_LOCATION_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PROCESS_STATION_LOG_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROCESS_STATION_LOG_TBL](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[STATION_UID] [int] NOT NULL,
	[OBJECT_TYPE_UID] [int] NOT NULL,
	[OBJECT_UID] [int] NOT NULL,
	[INPUT_STORAGE_LOCATION_UID] [int] NULL,
	[OUTPUT_STORAGE_LOCATION_UID] [int] NULL,
	[PROCESS_TIME] [int] NOT NULL,
 CONSTRAINT [PK_PROCESS_STATION_LOG_TBL] PRIMARY KEY NONCLUSTERED 
(
	[JOB_UID] ASC,
	[PID] ASC,
	[STATION_UID] ASC,
	[OBJECT_TYPE_UID] ASC,
	[OBJECT_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PROCESS_STATION_STATUS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PROCESS_STATION_STATUS_TBL](
	[STATUS_UID] [int] NOT NULL,
	[STATUS_DESC] [char](255) NOT NULL,
 CONSTRAINT [PK_PROCESS_STATION_STATUS_TBL] PRIMARY KEY CLUSTERED 
(
	[STATUS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PROCESS_STATION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PROCESS_STATION_TBL](
	[PROCESS_STATION_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[STATION_UID] [int] NOT NULL,
	[PROCESS_STATION_NAME] [char](50) NOT NULL,
	[PROCESS_STATION_DESC] [char](255) NOT NULL,
	[STATUS_UID] [int] NULL,
	[OBJECT_TYPE_UID] [int] NULL,
	[OBJECT_UID] [int] NULL,
 CONSTRAINT [PK_PROCESS_STATION_TBL_1] PRIMARY KEY CLUSTERED 
(
	[PROCESS_STATION_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_PROCESS_STATION_TBL] UNIQUE NONCLUSTERED 
(
	[PID] ASC,
	[STATION_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PROCESS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PROCESS_TBL](
	[PID] [int] NOT NULL,
	[SEQ_ID] [int] NOT NULL,
	[PROG_NAME] [varchar](2048) NULL,
	[PROCESS_DESC] [char](100) NOT NULL,
 CONSTRAINT [PK_PROCESS_TBL] PRIMARY KEY CLUSTERED 
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PROCESS_TIME_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROCESS_TIME_TBL](
	[TIME_UID] [int] IDENTITY(1,1) NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ROLL_UID] [int] NULL,
	[FICHE_UID] [int] NULL,
	[PID] [int] NOT NULL,
	[STOP_STATUS_UID] [int] NOT NULL,
	[PROCESS_TIME_SECS] [int] NOT NULL,
	[STATION_UID] [int] NULL,
	[USER_UID] [int] NULL,
	[EventDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProQuest_Process_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ProQuest_Process_TBL](
	[ROLL_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[NewspaperTitle] [varchar](100) NOT NULL,
	[RollTitle] [varchar](50) NOT NULL,
	[Rescan] [int] NULL,
	[PageCount] [int] NULL,
	[DeployToTestDt] [datetime] NULL,
	[DeployToLiveDt] [datetime] NULL,
	[ProductionStatus] [int] NOT NULL,
	[ColoHardDriveId] [varchar](10) NULL,
 CONSTRAINT [PK_ProQuest_Process_TBL] PRIMARY KEY CLUSTERED 
(
	[ROLL_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ROLL_ADDITIONAL_INDEX_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLL_ADDITIONAL_INDEX_TBL](
	[ROLL_UID] [int] NOT NULL,
	[ValueStr] [nchar](100) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ROLL_ARCH_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLL_ARCH_TBL](
	[ROLL_UID] [int] NOT NULL,
	[ARCH_VOL_UID] [int] NOT NULL,
	[MIRROR_ARCH_VOL_UID] [int] NOT NULL,
	[ESTIMATE_SIZE_MB] [int] NOT NULL,
	[ACTUAL_SIZE_MB] [int] NULL,
	[ARCHIVE_DT] [datetime] NULL,
 CONSTRAINT [PK_ROLL_ARCH_TBL] PRIMARY KEY NONCLUSTERED 
(
	[ROLL_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[roll_bill_event_tbl]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[roll_bill_event_tbl](
	[roll_uid] [int] NOT NULL,
	[bill_item_uid] [int] NOT NULL,
	[bill_item_count] [int] NOT NULL,
	[bill_event_dt] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ROLL_BILL_ITEM_EVENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ROLL_BILL_ITEM_EVENT_TBL](
	[ROLL_UID] [int] NOT NULL,
	[ITEM] [varchar](500) NOT NULL,
	[BILL_ITEM_UID] [int] NOT NULL,
	[EVENT_DT] [datetime] NOT NULL,
	[JOB_UID] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ROLL_BINARIZE_TYPE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLL_BINARIZE_TYPE_TBL](
	[ROLL_UID] [int] NOT NULL,
	[BINARIZE_TYPE_UID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ROLL_LOCATION_HISTORY]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLL_LOCATION_HISTORY](
	[ROLL_UID] [int] NOT NULL,
	[Storage_Location_UID] [int] NOT NULL,
	[UpdateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ROLL_META_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ROLL_META_TBL](
	[ROLL_UID] [int] NOT NULL,
	[MetaData] [varchar](5000) NULL,
 CONSTRAINT [PK_ROLL_META_TBL] PRIMARY KEY CLUSTERED 
(
	[ROLL_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ROLL_PROCESS_COST_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLL_PROCESS_COST_TBL](
	[Vendor_Uid] [int] NOT NULL,
	[Job_Uid] [int] NOT NULL,
	[Pid] [int] NOT NULL,
	[Roll_Uid] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[Job_Cost_Item_Uid] [int] NULL,
	[DateTime] [datetime] NULL,
 CONSTRAINT [AK_RollProcessCost] UNIQUE NONCLUSTERED 
(
	[Job_Uid] ASC,
	[Pid] ASC,
	[Roll_Uid] ASC,
	[Job_Cost_Item_Uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ROLL_PROCESS_EXPECTANCY]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLL_PROCESS_EXPECTANCY](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Count] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ROLL_PROCESS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLL_PROCESS_TBL](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[PREV_PID] [int] NULL,
	[CONT_STATUS_UID] [int] NULL,
	[INPUT_DIR_UID] [int] NULL,
	[OUTPUT_DIR_UID] [int] NULL,
	[EXPECTANCY] [int] NULL,
 CONSTRAINT [PK_ROLL_PROCESS_TBL] PRIMARY KEY NONCLUSTERED 
(
	[JOB_UID] ASC,
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ROLL_STATUS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ROLL_STATUS_TBL](
	[STATUS_UID] [int] NOT NULL,
	[STATUS_DESC] [char](20) NOT NULL,
 CONSTRAINT [PK_STATUS_TBL] PRIMARY KEY NONCLUSTERED 
(
	[STATUS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ROLL_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ROLL_TBL](
	[ROLL_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ROLL_TYPE_UID] [int] NULL,
	[ROLL_GROUP_UID] [int] NULL,
	[ROLL_NAME] [char](50) NOT NULL,
	[STATION_UID] [int] NULL,
	[DVD_ID] [int] NULL,
	[RAW_IMG_CNT] [int] NULL,
	[FOUND_PG_CNT] [int] NULL,
	[ROLL_SZ_ON_DISK_MB] [int] NULL,
	[IP_ROTATE] [int] NULL,
	[IP_MIRROR] [bit] NULL,
	[DIRECTION] [char](20) NULL,
	[NOTE_UID] [int] NULL,
	[CREATE_USER_UID] [int] NULL,
	[SCAN_USER_UID] [int] NULL,
	[IP_USER_UID] [int] NULL,
	[MARK_USER_UID] [int] NULL,
	[DLVR_USER_UID] [int] NULL,
	[MARK_VENDOR_UID] [int] NULL,
	[SCAN_TM_SECS] [int] NULL,
	[IP_TM_SECS] [int] NULL,
	[MARK_TM_SECS] [int] NULL,
	[PID] [int] NOT NULL,
	[RAW_STORAGE_LOCATION_UID] [int] NULL,
	[PROCESSED_STORAGE_LOCATION_UID] [int] NULL,
	[STATUS_UID] [int] NOT NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
	[ERR_MSG] [char](255) NULL,
 CONSTRAINT [PK_ROLL_TBL] PRIMARY KEY NONCLUSTERED 
(
	[ROLL_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ROLL_TYPE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ROLL_TYPE_TBL](
	[ROLL_TYPE_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ROLL_SIZE] [char](2) NULL,
	[DPI] [int] NULL,
	[RAW_IMG_CNT] [int] NOT NULL,
	[RAW_WDTH_PIX] [int] NULL,
	[RAW_HGHT_PIX] [int] NULL,
	[RDCT_RATIO] [int] NULL,
	[FRAME_CNT] [int] NOT NULL,
	[TYPE_DESC] [char](100) NULL,
	[NOTE_UID] [int] NULL,
	[SCANNER_CFG_FILE] [char](255) NULL,
	[IP_CFG_FILE] [char](255) NOT NULL,
	[BENCHMARK_DIR] [char](255) NOT NULL,
	[SETUP_USER_UID] [int] NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_ROLL_TYPE_TBL] PRIMARY KEY NONCLUSTERED 
(
	[ROLL_TYPE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ROLL_VAULT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLL_VAULT_TBL](
	[ROLL_UID] [int] NOT NULL,
	[VAULT_VOL_UID] [int] NOT NULL,
	[ACTUAL_SIZE_MB] [float] NOT NULL,
	[ARCHIVE_DT] [datetime] NOT NULL,
	[TIME_MINS] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SCAN_SETTINGS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SCAN_SETTINGS_TBL](
	[FILM_TYPE] [char](10) NULL,
	[POLARITY] [char](5) NULL,
	[AVG_DENSITY] [decimal](3, 2) NULL,
	[DENSITY_RANGE] [decimal](3, 3) NULL,
	[r_AGCControl] [int] NULL,
	[r_ManualVideoOffset] [int] NULL,
	[r_ManualVideoGain] [int] NULL,
	[r_GraySharpenRadius] [int] NULL,
	[r_GraySharpenPercent] [int] NULL,
	[SoftwareGrayAdjustEnable] [int] NULL,
	[SoftwareContrast] [int] NULL,
	[SoftwareBrightness] [int] NULL,
	[SoftwareGamma] [int] NULL,
	[BitonalThreshold] [int] NULL,
	[BitonalSensitivity] [int] NULL,
	[BitonalType] [int] NULL,
	[TESTED] [char](1) NULL,
	[Scan_Type] [int] NULL,
	[JpgQualityStrip] [int] NULL,
	[r_ManualExposure] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SERVICE_REQUEST_ATTACHMENT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SERVICE_REQUEST_ATTACHMENT_TBL](
	[ATTACHMENT_GUID] [varchar](50) NOT NULL,
	[SERVICE_REQUEST_UID] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SERVICE_REQUEST_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SERVICE_REQUEST_TBL](
	[SERVICE_REQUEST_UID] [int] NOT NULL,
	[MAINTENANCE_ITEM_UID] [int] NOT NULL,
	[JOB_TYPE] [varchar](100) NULL,
	[CATEGORY] [varchar](100) NULL,
	[CONTRACT] [bit] NULL,
	[SERVICE_LEVEL] [varchar](100) NULL,
	[CHARGE] [varchar](50) NULL,
	[COMMENTS] [varchar](500) NULL,
	[ASSIGNED_TO_USER_UID] [int] NULL,
	[FAULT] [varchar](100) NULL,
	[FAULT_DETAILS] [varchar](500) NULL,
	[CAUSE] [varchar](200) NULL,
	[ACTION] [varchar](200) NULL,
	[ACTION_DETAILS] [varchar](500) NULL,
	[RESPONDED_TO_DT] [datetime] NULL,
	[RESPONDED_IN_MINS] [int] NULL,
	[FIXED_DT] [datetime] NULL,
	[FIXED_IN_MINS] [int] NULL,
	[STARTED_DT] [datetime] NULL,
	[COMPLETED_DT] [datetime] NULL,
	[COMPLETED_IN_MINS] [int] NULL,
	[TOTAL_MINS] [int] NULL,
	[CREATED_USER_UID] [int] NOT NULL,
	[CREATED_DT] [datetime] NOT NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_SERVICE_REQUEST_TBL] PRIMARY KEY CLUSTERED 
(
	[SERVICE_REQUEST_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SHIPMENT_CARRIER_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SHIPMENT_CARRIER_TBL](
	[SHIPMENT_CARRIER_UID] [int] NOT NULL,
	[NAME] [varchar](200) NOT NULL,
 CONSTRAINT [PK_SHIPMENT_CARRIER_TBL] PRIMARY KEY CLUSTERED 
(
	[SHIPMENT_CARRIER_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SOP_DELIVERABLE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOP_DELIVERABLE_TBL](
	[SOPNumber] [varchar](255) NOT NULL,
	[DELIVERABLE_UID] [int] NOT NULL,
 CONSTRAINT [PK_SOP_DELIVERABLE_TBL] PRIMARY KEY CLUSTERED 
(
	[SOPNumber] ASC,
	[DELIVERABLE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SOP_INVOICE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOP_INVOICE_TBL](
	[SOPNumber] [varchar](255) NOT NULL,
	[INVOICE_UID] [int] NOT NULL,
 CONSTRAINT [PK_SOP_INVOICE_TBL] PRIMARY KEY CLUSTERED 
(
	[SOPNumber] ASC,
	[INVOICE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SOP_JOB_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOP_JOB_TBL](
	[SOPId] [int] NOT NULL,
	[Job_UID] [int] NOT NULL,
	[SOPNumber] [varchar](255) NULL,
 CONSTRAINT [PK_SOP_JOB_TBL] PRIMARY KEY CLUSTERED 
(
	[SOPId] ASC,
	[Job_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Starred_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Starred_TBL](
	[Starred_UID] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[URL] [varchar](500) NOT NULL,
	[User_UID] [int] NOT NULL,
 CONSTRAINT [PK_Starred_TBL] PRIMARY KEY CLUSTERED 
(
	[Starred_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[STATION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[STATION_TBL](
	[STATION_UID] [int] NOT NULL,
	[COMPUTER_NAME] [char](80) NOT NULL,
	[STATION_DESC] [char](50) NOT NULL,
 CONSTRAINT [PK_SCANNER_TBL] PRIMARY KEY NONCLUSTERED 
(
	[STATION_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[STORAGE_LOCATION_POOL_LOCATION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STORAGE_LOCATION_POOL_LOCATION_TBL](
	[STORAGE_LOCATION_POOL_UID] [int] NOT NULL,
	[STORAGE_LOCATION_UID] [int] NOT NULL,
 CONSTRAINT [PK_STORAGE_LOCATION_POOL_LOCATION_TBL] PRIMARY KEY NONCLUSTERED 
(
	[STORAGE_LOCATION_POOL_UID] ASC,
	[STORAGE_LOCATION_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[STORAGE_LOCATION_POOL_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[STORAGE_LOCATION_POOL_TBL](
	[STORAGE_LOCATION_POOL_UID] [int] NOT NULL,
	[STORAGE_LOCATION_POOL_NAME] [char](50) NOT NULL,
	[STORAGE_LOCATION_POOL_DESC] [char](255) NOT NULL,
 CONSTRAINT [PK_STORAGE_LOCATION_POOL_TBL] PRIMARY KEY CLUSTERED 
(
	[STORAGE_LOCATION_POOL_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[STORAGE_LOCATION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[STORAGE_LOCATION_TBL](
	[STORAGE_LOCATION_UID] [int] NOT NULL,
	[STORAGE_LOCATION_PATH] [char](255) NOT NULL,
	[STORAGE_LOCATION_DESC] [char](255) NOT NULL,
 CONSTRAINT [PK_STORAGE_LOCATION_TBL] PRIMARY KEY NONCLUSTERED 
(
	[STORAGE_LOCATION_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TASKER_STATION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TASKER_STATION_TBL](
	[STATION_UID] [int] NOT NULL,
	[INSTANCE_COUNT] [int] NOT NULL,
	[IsEnabled] [int] NULL,
	[RecycleTimeInHours] [int] NULL,
	[Utilization] [int] NULL,
	[TimeoutInMinutes] [int] NULL,
	[Delay] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UID_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UID_TBL](
	[UID_NAME] [char](255) NOT NULL,
	[UID_VALUE] [int] NOT NULL,
 CONSTRAINT [PK_UID_TBL] PRIMARY KEY NONCLUSTERED 
(
	[UID_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[USER_ACTIVITY_TYPE_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[USER_ACTIVITY_TYPE_TBL](
	[ACTIVITY_UID] [int] NOT NULL,
	[ACTIVITY_NAME] [varchar](250) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[USER_GROUP_PROCESS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_GROUP_PROCESS_TBL](
	[USER_GROUP_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[SEC_LVL] [int] NOT NULL,
 CONSTRAINT [PK_USER_GROUP_PROCESS_TBL] PRIMARY KEY CLUSTERED 
(
	[USER_GROUP_UID] ASC,
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[USER_GROUP_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[USER_GROUP_TBL](
	[USER_GROUP_UID] [int] NOT NULL,
	[USER_GROUP_DESC] [char](50) NOT NULL,
 CONSTRAINT [PK_USER_GROUP_TBL] PRIMARY KEY CLUSTERED 
(
	[USER_GROUP_UID] ASC,
	[USER_GROUP_DESC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[USER_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[USER_TBL](
	[USER_UID] [int] NOT NULL,
	[USER_GROUP_UID] [int] NOT NULL,
	[USER_NAME] [char](50) NOT NULL,
	[USER_PWD] [char](10) NOT NULL,
	[IsPM] [int] NULL,
	[IsSalesPerson] [int] NULL,
	[Vendor_Uid] [int] NULL,
	[IsPL] [int] NULL,
	[Hourly_Cost] [float] NULL,
	[ShiftStart] [time](7) NULL,
	[ShiftEnd] [time](7) NULL,
	[First_Name] [nvarchar](50) NULL,
	[Last_Name] [nvarchar](50) NULL,
	[BadgeID] [nchar](200) NULL,
 CONSTRAINT [PK_USER_TBL] PRIMARY KEY NONCLUSTERED 
(
	[USER_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[USER_TIME_ACTIVITY_TRACKING_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_TIME_ACTIVITY_TRACKING_TBL](
	[Job_uid] [int] NOT NULL,
	[ACTIVITY_UID] [int] NOT NULL,
	[USER_UID] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[Uid] [int] NOT NULL,
	[ClockedMinutes] [float] NOT NULL,
	[AdjustedMinutes] [float] NOT NULL,
	[NetMinutes] [float] NOT NULL,
	[AdjustedUserUID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[USER_TIME_PROCESS_TRACKING_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_TIME_PROCESS_TRACKING_TBL](
	[Job_uid] [int] NOT NULL,
	[PID] [int] NULL,
	[USER_UID] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[Uid] [int] NOT NULL,
	[ClockedMinutes] [float] NOT NULL,
	[AdjustedMinutes] [float] NOT NULL,
	[NetMinutes] [float] NOT NULL,
	[AdjustedUserUID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[USER_TIME_TRACKING]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_TIME_TRACKING](
	[Uid] [int] IDENTITY(1,1) NOT NULL,
	[Job_uid] [int] NOT NULL,
	[PID] [int] NULL,
	[USER_UID] [int] NOT NULL,
	[Starttime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VAULT_VOL_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VAULT_VOL_TBL](
	[VAULT_VOL_UID] [int] NOT NULL,
	[ASSIGNED_JOB_UID] [int] NOT NULL,
	[LABEL_NAME] [char](80) NOT NULL,
	[VOL_NAME] [char](80) NOT NULL,
	[VAULT_VOL_SERIAL_NUM] [char](10) NOT NULL,
	[VAULT_HD_SERIAL_NUM] [char](10) NOT NULL,
	[VAULT_TOT_SPACE_GB] [int] NOT NULL,
	[VOL_AUTO_DUPLICATE] [bit] NOT NULL,
	[DUP_VOL_SERIAL_NUM] [char](10) NULL,
	[DUP_HD_SERIAL_NUM] [char](10) NULL,
	[DUP_TOT_SPACE_GB] [int] NULL,
	[LAST_VOL_ROOT_PATH] [char](100) NOT NULL,
	[LAST_DUP_VOL_ROOT_PATH] [char](100) NOT NULL,
 CONSTRAINT [PK_VAULT_VOL_TBL] PRIMARY KEY CLUSTERED 
(
	[VAULT_VOL_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VENDOR_KEYING_STATS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VENDOR_KEYING_STATS_TBL](
	[JOB_UID] [int] NOT NULL,
	[ROLL_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[VENDOR_UID] [int] NOT NULL,
	[FIELDS_KEYED] [int] NOT NULL,
	[ERRORS] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VENDOR_KEYS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VENDOR_KEYS_TBL](
	[VendorUID] [int] NOT NULL,
	[PGPKeyID] [varchar](50) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VENDOR_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VENDOR_TBL](
	[VENDOR_UID] [int] NOT NULL,
	[VENDOR_NAME] [char](100) NOT NULL,
	[VENDOR_DESC] [char](255) NOT NULL,
	[SEND_PATH] [char](255) NULL,
	[RCV_PATH] [char](255) NULL,
 CONSTRAINT [PK_VENDOR_TBL] PRIMARY KEY CLUSTERED 
(
	[VENDOR_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WIDGET_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WIDGET_TBL](
	[Widget_UID] [int] NOT NULL,
	[Label] [varchar](100) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Icon] [varchar](50) NOT NULL,
	[QueryText] [varchar](max) NOT NULL,
	[PanelStyle] [varchar](50) NULL,
	[ClickLink] [varchar](500) NULL,
	[User_UID] [int] NULL,
	[SortOrder] [int] NULL,
	[IsEnabled] [int] NULL,
	[GroupPanel] [varchar](50) NULL,
	[AutoRefreshFrequency] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [syssql].[FICHE_SET_TBL_COMPLETED]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [syssql].[FICHE_SET_TBL_COMPLETED](
	[FICHE_SET_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[FICHE_GROUP_UID] [int] NOT NULL,
	[FICHE_NAME] [char](255) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [syssql].[FICHE_TBL_COMPLETED]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [syssql].[FICHE_TBL_COMPLETED](
	[FICHE_UID] [int] NOT NULL,
	[FICHE_TYPE_UID] [int] NULL,
	[FICHE_SET_UID] [int] NOT NULL,
	[FICHE_NUMBER] [int] NOT NULL,
	[STATION_UID] [int] NULL,
	[DVD_ID] [int] NULL,
	[RAW_IMG_CNT] [int] NULL,
	[FOUND_PG_CNT] [int] NULL,
	[FICHE_SZ_ON_DISK_MB] [int] NULL,
	[IP_ROTATE] [int] NULL,
	[IP_MIRROR] [bit] NULL,
	[DIRECTION] [char](20) NULL,
	[NOTE_UID] [int] NULL,
	[CREATE_USER_UID] [int] NULL,
	[SCAN_USER_UID] [int] NULL,
	[IP_USER_UID] [int] NULL,
	[MARK_USER_UID] [int] NULL,
	[DLVR_USER_UID] [int] NULL,
	[MARK_VENDOR_UID] [int] NULL,
	[SCAN_TM_SECS] [int] NULL,
	[IP_TM_SECS] [int] NULL,
	[MARK_TM_SECS] [int] NULL,
	[PID] [int] NOT NULL,
	[RAW_STORAGE_LOCATION_UID] [int] NULL,
	[PROCESSED_STORAGE_LOCATION_UID] [int] NULL,
	[STATUS_UID] [int] NOT NULL,
	[ERR_MSG] [char](255) NULL,
	[UPDATE_USER_UID] [int] NOT NULL,
	[UPDATE_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [syssql].[PROCESS_CHECK_IN_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[PROCESS_CHECK_IN_TBL](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[UpdateDt] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[PROCESS_INSTRUCTIONS_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [syssql].[PROCESS_INSTRUCTIONS_TBL](
	[UID] [int] NOT NULL,
	[JobUID] [int] NULL,
	[PID] [int] NULL,
	[CreatedDate] [varchar](10) NULL,
	[CreatedBy] [char](50) NULL,
	[ModifiedDate] [varchar](10) NULL,
	[ModifiedBy] [char](50) NULL,
	[InstructionType] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [syssql].[PROCESS_MANUAL_INSTRUCTION_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[PROCESS_MANUAL_INSTRUCTION_TBL](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
	[INST_UPDATE_DT] [datetime] NOT NULL,
	[INSTRUCTION_UID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[PROCESS_MANUAL_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[PROCESS_MANUAL_TBL](
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NULL,
	[INST_LAST_UPDATE_DT] [timestamp] NULL,
	[JOB_UID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[PROCESS_VENDOR_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[PROCESS_VENDOR_TBL](
	[PID] [int] NOT NULL,
	[PROCESS_CODE_NAME] [nchar](50) NULL,
	[ExpectedHours] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[REPORTING_PROCESS_EX_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[REPORTING_PROCESS_EX_TBL](
	[PID] [int] NOT NULL,
	[PrevPID] [int] NULL,
	[HoursAllowedBehind] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[ROLL_PROCESS_IDLE_TIMES_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[ROLL_PROCESS_IDLE_TIMES_TBL](
	[IDLE_TM_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ROLL_UID] [int] NOT NULL,
	[FICHE_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[IDLE_TM_MINUTES] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[VENDOR_REPORT_TBL]    Script Date: 3/13/2020 2:13:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[VENDOR_REPORT_TBL](
	[VENDOR_UID] [int] NOT NULL,
	[GUID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[BOX_TBL] ADD  CONSTRAINT [DF_BOX_TBL_CHECKED_OUT]  DEFAULT ((0)) FOR [CHECKED_OUT]
GO
ALTER TABLE [dbo].[BOX_TBL] ADD  DEFAULT ((0)) FOR [HIDDEN]
GO
ALTER TABLE [dbo].[COST_ITEM_TBL] ADD  DEFAULT ('') FOR [Include_File_Mask]
GO
ALTER TABLE [dbo].[JOB_TBL] ADD  CONSTRAINT [DF_JOB_TBL_THRESHOLD]  DEFAULT (0.05) FOR [THRESHOLD]
GO
ALTER TABLE [dbo].[JOB_TBL] ADD  DEFAULT ((0)) FOR [PID]
GO
ALTER TABLE [dbo].[JOB_TBL] ADD  DEFAULT ((0)) FOR [STATUS_UID]
GO
ALTER TABLE [dbo].[JOB_TBL] ADD  DEFAULT ((1)) FOR [TAXABLE]
GO
ALTER TABLE [dbo].[MAINTENANCE_ITEM_TBL] ADD  CONSTRAINT [DF_MAINTENANCE_ITEM_TBL_DELETED]  DEFAULT ((0)) FOR [DELETED]
GO
ALTER TABLE [dbo].[ProQuest_Process_TBL] ADD  CONSTRAINT [DF_ProQuest_Process_TBL_ProductionStatus]  DEFAULT ((0)) FOR [ProductionStatus]
GO
ALTER TABLE [dbo].[USER_TBL] ADD  CONSTRAINT [DF_USER_TBL_USER_GROUP_UID]  DEFAULT (1) FOR [USER_GROUP_UID]
GO
ALTER TABLE [dbo].[USER_TBL] ADD  CONSTRAINT [DF_USER_TBL_USER_PWD]  DEFAULT ('password') FOR [USER_PWD]
GO
