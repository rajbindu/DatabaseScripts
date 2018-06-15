USE [master]
GO

/****** Object:  Database [DigitalReelStage]    Script Date: 6/15/2018 3:40:55 PM ******/
CREATE DATABASE [DigitalReelStage]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DigitalReelStage', FILENAME = N'i:\MSSQL11.B\MSSQL\DATA\DigitalReelStage.mdf' , SIZE = 11264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DigitalReelStage_log', FILENAME = N'H:\MSSQL11.B\MSSQL\Log\DigitalReelStage_log.ldf' , SIZE = 22144KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [DigitalReelStage] SET COMPATIBILITY_LEVEL = 110
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DigitalReelStage].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [DigitalReelStage] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [DigitalReelStage] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [DigitalReelStage] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [DigitalReelStage] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [DigitalReelStage] SET ARITHABORT OFF 
GO

ALTER DATABASE [DigitalReelStage] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [DigitalReelStage] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [DigitalReelStage] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [DigitalReelStage] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [DigitalReelStage] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [DigitalReelStage] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [DigitalReelStage] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [DigitalReelStage] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [DigitalReelStage] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [DigitalReelStage] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [DigitalReelStage] SET  DISABLE_BROKER 
GO

ALTER DATABASE [DigitalReelStage] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [DigitalReelStage] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [DigitalReelStage] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [DigitalReelStage] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [DigitalReelStage] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [DigitalReelStage] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [DigitalReelStage] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [DigitalReelStage] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [DigitalReelStage] SET  MULTI_USER 
GO

ALTER DATABASE [DigitalReelStage] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [DigitalReelStage] SET DB_CHAINING OFF 
GO

ALTER DATABASE [DigitalReelStage] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [DigitalReelStage] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [DigitalReelStage] SET  READ_WRITE 
GO

USE [DigitalReelStage]
GO
/****** Object:  User [syssql]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE USER [syssql] FOR LOGIN [syssql] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [SDRedactionQAUser]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE USER [SDRedactionQAUser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [drviewer]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE USER [drviewer] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [DigitalReelReadOnly]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE USER [DigitalReelReadOnly] FOR LOGIN [DigitalReelReadOnly] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [BMI\Jim]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE USER [BMI\Jim] FOR LOGIN [BMI\jim] WITH DEFAULT_SCHEMA=[BMI\Jim]
GO
ALTER ROLE [db_owner] ADD MEMBER [syssql]
GO
ALTER ROLE [db_owner] ADD MEMBER [SDRedactionQAUser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [drviewer]
GO
ALTER ROLE [db_datareader] ADD MEMBER [DigitalReelReadOnly]
GO
/****** Object:  Schema [BMI\Jim]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE SCHEMA [BMI\Jim]
GO
/****** Object:  Schema [syssql]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE SCHEMA [syssql]
GO
/****** Object:  StoredProcedure [dbo].[DF_GENERAL_MANUAL_PROCESS_AVAIL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DF_MANUAL_PROCESS_AVAIL_BY_USERUID]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_MANUAL_PROCESS_AVAIL_BY_USERUID]
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
	fiche_PROCESS_TBL fp, 
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
	fp.PREV_PID = f.PID and
	f.STATUS_UID = 1 and
	fs.FICHE_SET_UID = f.FICHE_SET_UID and	
	pm.status_uid = 1 and
	
	j.DLVR_DT is null 
	
	group by u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid order by j.PRIORITY, j.JOB_NUM

GO
/****** Object:  StoredProcedure [dbo].[DF_MANUAL_PROCESS_EX_AVAIL_BY_USERUID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DF_PID_BY_DATE_EVENT_TBL_BY_JOB]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DF_PID_BY_DATE_EVENT_TBL_DETAILS_BY_JOB]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DF_PROCESS_LIST_BY_JOB_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_PROCESS_LIST_BY_JOB_UID]
	@JobUID int
AS
	SELECT p.PROCESS_DESC, p.PID FROM dbo.PROCESS_TBL AS p INNER JOIN dbo.FICHE_PROCESS_TBL AS fp ON p.PID = fp.PID  where fp.job_uid = @jobUid ORDER BY p.PROCESS_DESC



GO
/****** Object:  StoredProcedure [dbo].[DF_USER_EVENT_REPORT_ALL_JOBS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DF_USER_EVENT_REPORT_ROLL_TIMES_BY_JOB]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORGUID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID_HIDE_NAME]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORGUID]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORGUID]
	@VendorGUID nchar(100)
AS



select j.PRIORITY, j.job_num, pv.process_code_name, j.job_uid, pv.pid, f.status_uid, COUNT(f.fiche_uid) as "Fiche Count" from
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
	
	group by j.PRIORITY, j.JOB_NUM, pv.process_code_name, j.job_uid, pv.pid, f.status_uid order by j.PRIORITY, j.JOB_NUM


GO
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID]
	@VendorUID int
AS

select v.vendor_name, j.PRIORITY, j.job_num, j.cust_name, pv.process_code_name, COUNT(f.fiche_uid) as "Fiche Count" from
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
	
	group by VENDOR_NAME, j.PRIORITY, j.JOB_NUM, j.cust_name, pv.process_code_name order by j.PRIORITY, j.JOB_NUM


GO
/****** Object:  StoredProcedure [dbo].[DF_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID_HIDE_NAME]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DIGITAL_REEL_PID_EVENT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_GENERAL_MANUAL_PROCESS_AVAIL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID]
	@UserUID int
AS

select U.user_name, j.PRIORITY, j.job_num, J.cust_name, p.process_desc, p.pid, j.job_uid, COUNT(r.roll_uid) as "Roll Count" from
	ROLL_TBL r, 
	USER_TBL u,
	JOB_TBL j,
	PROCESS_TBL p,	
	USER_GROUP_PROCESS_TBL ug,
	syssql.process_manual_tbl pm,
	ROLL_PROCESS_TBL rp,
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
	rp.PREV_PID = r.PID and
	r.STATUS_UID = 1 and	
	pm.status_uid = 1 and
	
	j.DLVR_DT is null 
	
	group by u.USER_NAME, j.PRIORITY, j.JOB_NUM, j.CUST_NAME, p.PROCESS_DESC, p.pid, j.job_uid order by j.PRIORITY, j.JOB_NUM



GO
/****** Object:  StoredProcedure [dbo].[DR_MANUAL_PROCESS_AVAIL_BY_USERUID_WITH_AVGTIME]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_MANUAL_PROCESS_EX_AVAIL_BY_USERUID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_PID_BY_DATE_EVENT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_PID_BY_DATE_EVENT_TBL_BY_JOB]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_PID_BY_DATE_EVENT_TBL_DETAILS_BY_JOB]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_PROCESS_LIST_BY_JOB_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DR_PROCESS_LIST_BY_JOB_UID]
	@JobUID int
AS
	SELECT p.PROCESS_DESC, p.PID FROM dbo.PROCESS_TBL AS p INNER JOIN dbo.ROLL_PROCESS_TBL AS rp ON p.PID = rp.PID  where rp.job_uid = @jobUid ORDER BY p.PROCESS_DESC


GO
/****** Object:  StoredProcedure [dbo].[DR_USER_EVENT_REPORT_ALL_JOBS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_USER_EVENT_REPORT_BY_JOB]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_USER_EVENT_REPORT_ROLL_TIMES_BY_JOB]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORGUID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_DETAILS_BY_VENDORUID_HIDE_NAME]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORGUID]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORGUID]
	@VendorGUID nchar(100)
AS



select j.PRIORITY, j.job_num, pv.process_code_name, j.job_uid, pv.pid, r.status_uid, COUNT(r.roll_uid) as "Roll Count" from
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
	
	group by j.PRIORITY, j.JOB_NUM, pv.process_code_name, j.job_uid, pv.pid, r.status_uid order by j.PRIORITY, j.JOB_NUM

GO
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID]
	@VendorUID int
AS

select v.vendor_name, j.PRIORITY, j.job_num, j.cust_name, pv.process_code_name, COUNT(r.roll_uid) as "Roll Count" from
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
	
	group by VENDOR_NAME, j.PRIORITY, j.JOB_NUM, j.cust_name, pv.process_code_name order by j.PRIORITY, j.JOB_NUM

GO
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_AVAIL_SUMMARY_BY_VENDORUID_HIDE_NAME]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DR_VENDOR_PROCESS_DETAILS_BY_PROCESS_PID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetRollByNewsPaperTitle_RollTitle]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SF_MUNI_BATCH_DELIVER_REPORT]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[ClarkCountyGetReScanList]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [syssql].[ClarkCountyGetReScanList] as 
	
select a.book as "Book", a.range as "Range", r.roll_uid as "Roll UID" from Clark_County.dbo.Asset_Tbl a, ROLL_TBL r where
	r.roll_uid = a.RollUID and r.job_uid = 887 and r.pid = 205 and r.status_uid = 1 order by a.Book desc, a.Range	
GO
/****** Object:  StoredProcedure [syssql].[ClarkCountyRollDateListByJobPidStatus]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DF_ALL_MANUAL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DF_ALL_MANUAL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DF_ALL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DF_ALL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DF_FICHE_HISTORY]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_FICHE_GET_BILLING_COUNTS_BY_JOBUID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_FICHE_JOB_PROCESS_COUNTS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_FICHE_JOB_PROCESS_COUNTS_WITH_STATUS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_FICHE_JOB_PROCESS_COUNTS_WITH_STATUS_BY_JOBUID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_FICHE_JOB_PROCESSED_LOCATIONS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_CHW_BILLING_COUNTS_BY_DATE]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_FOUND_PAGE_COUNT_BY_JOB_NUM]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [syssql].[DIGITAL_REEL_FOUND_PAGE_COUNT_BY_JOB_NUM] 
	@job_num char(20)
as 

select sum(r.found_pg_cnt) from roll_tbl r, job_tbl j where j.job_uid = r.job_uid and j.job_num = @job_num
GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_FOUND_PAGE_COUNT_BY_JOB_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [syssql].[DIGITAL_REEL_FOUND_PAGE_COUNT_BY_JOB_UID] 
	@job_uid int
as 
select sum(found_pg_cnt) from roll_tbl where job_uid = @job_uid
GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_FRAME_TOOL_EVENT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_GET_BILLING_COUNTS_BY_JOBUID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_BY_JOB]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_BY_JOBUID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_LIKE_CUSTOMER_NAME]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [syssql].[DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_LIKE_CUSTOMER_NAME]

@CustomerName varchar(500)

as

select distinct j.job_num as "Job Number", j.cust_name as "Customer", p.process_desc as "Process", s.Status_desc as "Status", count(r.roll_uid) as "Count"
	from job_tbl j, roll_tbl r, process_tbl p, roll_status_tbl s where j.job_uid = r.job_uid and p.pid = r.pid and r.status_uid = s.Status_uid
		and j.dlvr_dt is null and j.cust_name like @CustomerName group by j.job_num, j.cust_name, p.process_desc, s.Status_desc order by j.job_num, p.process_desc, s.Status_desc

--drop procedure [DIGITAL_REEL_JOB_PROCESS_COUNTS_WITH_STATUS_LIKE_CUSTOMER_NAME]
GO
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_JOB_PROCESSED_LOCATIONS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_ROLL_COUNT_BY_PID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_ROLL_COUNT_BY_PID_AND_STATUS_ID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_ROLL_LIST_BY_PROCESS_STATUS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST_NEW]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST_WITH_PID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DIGITAL_REEL_VENDOR_SENDER_LIST_WITH_PID_AND_STATUS_ID]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_DETAILS_IN_LAST_HOURS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_SUMMARY_IN_LAST_HOURS]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DR_ALL_MANUAL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DR_ALL_PROCESS_EVENTS_DETAILS_IN_LAST_MINUTES]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[DR_ALL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [syssql].[DR_ALL_PROCESS_EVENTS_SUMMARY_IN_LAST_MINUTES]
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
/****** Object:  StoredProcedure [syssql].[DR_ROLL_HISTORY]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[GetCustNameJobNum]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  StoredProcedure [syssql].[spJobNotOnTime]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[ALERTS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[AMEREN]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[ARCH_VOL_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[BILL_ITEM_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[BILL_ITEM_UNIT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BILL_ITEM_UNIT_TBL](
	[BILL_ITEM_UNIT_UID] [int] NOT NULL,
	[UNIT_DESC] [nvarchar](20) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BINARIZE_TYPE_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[BOOK_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[CLIENT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[CUSTOM_REPORT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[DIRECTORY_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[DVD_VOL_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[EVENT_FILTER_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[EVENT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_EXCLUDE_PROCESS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_EXCLUDE_PROCESS_TBL](
	[Execution_Plan_UID] [int] NOT NULL,
	[PID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_INCLUDE_JOB_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_INCLUDE_JOB_TBL](
	[Execution_Plan_UID] [int] NOT NULL,
	[Job_Uid] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_INCLUDE_PROCESS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXECUTION_PLAN_INCLUDE_PROCESS_TBL](
	[Execution_Plan_UID] [int] NOT NULL,
	[PID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EXECUTION_PLAN_STATION_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[EXECUTION_PLAN_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_ARCH_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[FICHE_BILL_EVENT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FICHE_BILL_EVENT_TBL](
	[FICHE_UID] [int] NOT NULL,
	[BILL_ITEM_UID] [int] NOT NULL,
	[BILL_ITEM_COUNT] [int] NOT NULL,
	[BILL_EVENT_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FICHE_META_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_PROCESS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
	[OUTPUT_DIR_UID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FICHE_SET_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],
 CONSTRAINT [IX_FICHE_SET_TBL] UNIQUE NONCLUSTERED 
(
	[JOB_UID] ASC,
	[FICHE_GROUP_UID] ASC,
	[FICHE_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_STATUS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[FICHE_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
 CONSTRAINT [PK_FICHE_TBL] PRIMARY KEY NONCLUSTERED 
(
	[FICHE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FICHE_TYPE_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[FICHE_VAULT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[GROUP_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[GROUP_USER_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[INSTRUCTIONS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
	[INSTRUCTION_FILE_PATH] [nvarchar](256) NULL,
 CONSTRAINT [PK_INSTRUCTIONS_TBL] PRIMARY KEY CLUSTERED 
(
	[INSTRUCTIONS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JOB_CLIENT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[JOB_PROCESS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JOB_ROLL_BINARIZE_TYPE_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[JOB_STATUS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[JOB_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
	[THRESHOLD] [float] NOT NULL CONSTRAINT [DF_JOB_TBL_THRESHOLD]  DEFAULT ((0.05)),
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
	[SALES_PERSON_USER_UID] [int] NULL,
	[PID] [int] NOT NULL DEFAULT ((0)),
	[STATUS_UID] [int] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_JOB_TBL] PRIMARY KEY NONCLUSTERED 
(
	[JOB_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[JOB_VENDOR_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[MARININDEX_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[MarinReport_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[NOTE_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[NOTIFICATION_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[OBJECT_TYPE_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[PQ_TITLE_AUTH_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[PRAIRIE_ISLAND]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PRAIRIE_ISLAND](
	[DOC_NUM] [char](12) NULL,
	[SITE] [char](4) NULL,
	[ROLL] [char](6) NULL,
	[FRAME] [char](6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PROCESS_MANUAL_INSTRUCTION_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[PROCESS_PARAM_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[PROCESS_STATION_LOCATION_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[PROCESS_STATION_LOG_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[PROCESS_STATION_STATUS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[PROCESS_STATION_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
	[PROCESS_STATION_NAME] [char](255) NULL,
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
/****** Object:  Table [dbo].[PROCESS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PROCESS_TBL](
	[PID] [int] NOT NULL,
	[SEQ_ID] [int] NOT NULL,
	[PROG_NAME] [char](255) NOT NULL,
	[PROCESS_DESC] [char](100) NOT NULL,
 CONSTRAINT [PK_PROCESS_TBL] PRIMARY KEY CLUSTERED 
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PROCESS_TIME_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
	[USER_UID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProQuest_Process_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[ROLL_ARCH_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[ROLL_BILL_EVENT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLL_BILL_EVENT_TBL](
	[ROLL_UID] [int] NOT NULL,
	[BILL_ITEM_UID] [int] NOT NULL,
	[BILL_ITEM_COUNT] [int] NOT NULL,
	[BILL_EVENT_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ROLL_BINARIZE_TYPE_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLL_BINARIZE_TYPE_TBL](
	[ROLL_UID] [int] NOT NULL,
	[BINARIZE_TYPE_UID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ROLL_META_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ROLL_META_TBL](
	[ROLL_UID] [int] NOT NULL,
	[MetaData] [varchar](5000) NULL,
 CONSTRAINT [PK_ROLL_META_TBL] PRIMARY KEY NONCLUSTERED 
(
	[ROLL_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ROLL_PROCESS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
 CONSTRAINT [PK_ROLL_PROCESS_TBL] PRIMARY KEY NONCLUSTERED 
(
	[JOB_UID] ASC,
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ROLL_STATUS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[ROLL_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ROLL_TYPE_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[ROLL_VAULT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[Rolls]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rolls](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileID] [uniqueidentifier] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SCAN_SETTINGS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
	[Scan_Type] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[STARRED_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[STARRED_TBL](
	[Starred_UID] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[URL] [varchar](500) NOT NULL,
	[User_UID] [int] NOT NULL,
 CONSTRAINT [PK_Starred_TBL] PRIMARY KEY CLUSTERED 
(
	[Starred_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[STATION_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[STORAGE_LOCATION_POOL_LOCATION_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[STORAGE_LOCATION_POOL_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[STORAGE_LOCATION_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[TASKER_STATION_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TASKER_STATION_TBL](
	[STATION_UID] [int] NOT NULL,
	[INSTANCE_COUNT] [int] NOT NULL,
	[IsEnabled] [int] NULL,
	[RecycleTimeInHours] [int] NULL,
	[Utilization] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UID_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[USER_GROUP_JOB_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_GROUP_JOB_TBL](
	[USER_GROUP_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
 CONSTRAINT [PK_GROUP_JOB_TBL] PRIMARY KEY CLUSTERED 
(
	[USER_GROUP_UID] ASC,
	[JOB_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[USER_GROUP_PROCESS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[USER_GROUP_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[USER_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[USER_TBL](
	[USER_UID] [int] NOT NULL,
	[USER_GROUP_UID] [int] NOT NULL CONSTRAINT [DF_USER_TBL_USER_GROUP_UID]  DEFAULT ((1)),
	[USER_NAME] [char](50) NOT NULL,
	[USER_PWD] [char](10) NOT NULL CONSTRAINT [DF_USER_TBL_USER_PWD]  DEFAULT ('password'),
	[IsPM] [int] NULL,
	[IsSalesPerson] [int] NULL,
 CONSTRAINT [PK_USER_TBL] PRIMARY KEY NONCLUSTERED 
(
	[USER_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VAULT_VOL_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VENDOR_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [dbo].[WIDGET_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
	[AutoRefreshFrequency] [int] NULL,
	[GroupPanel] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [syssql].[bill_item_unit_tbl]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[bill_item_unit_tbl](
	[bill_item_unit_uid] [int] NOT NULL,
	[unit_desc] [nchar](20) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[COST_ITEM_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[COST_ITEM_TBL](
	[COST_ITEM_UID] [int] NOT NULL,
	[JOB_UID] [int] NOT NULL,
	[ITEM_DESC] [nchar](100) NOT NULL,
	[ITEM_PRICE] [float] NOT NULL,
	[COST_ITEM_UNIT_UID] [int] NOT NULL,
	[INCLUDE_FILE_MASK] [nchar](100) NOT NULL,
	[EXCLUDE_FILE_MASK] [nchar](100) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[COST_ITEM_UNIT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[COST_ITEM_UNIT_TBL](
	[COST_ITEM_UNIT_UID] [int] NOT NULL,
	[unit_desc] [nchar](20) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[DTSC_DELIVERY_REPORT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[DTSC_DELIVERY_REPORT_TBL](
	[ROLL_UID] [int] NOT NULL,
	[BOX_NAME] [nchar](20) NOT NULL,
	[ROLL] [nchar](10) NOT NULL,
	[MANIFEST_COUNT] [int] NOT NULL,
	[DETAIL_COUNT] [int] NOT NULL,
	[DATE_DELIVERED] [date] NOT NULL,
	[DATE_EMAILED] [date] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[fiche_bill_event_tbl]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[fiche_bill_event_tbl](
	[fiche_uid] [int] NOT NULL,
	[bill_item_uid] [int] NOT NULL,
	[bill_item_count] [int] NOT NULL,
	[bill_event_dt] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[PROCESS_CHECK_IN_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [syssql].[PROCESS_INSTRUCTIONS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [syssql].[PROCESS_MANUAL_INSTRUCTION_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[PROCESS_MANUAL_INSTRUCTION_TBL](
	[JOB_UID] [int] NOT NULL,
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NOT NULL,
	[INST_UPDATE_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[PROCESS_MANUAL_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[PROCESS_MANUAL_TBL](
	[PID] [int] NOT NULL,
	[STATUS_UID] [int] NULL,
	[INST_LAST_UPDATE_DT] [timestamp] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[PROCESS_VENDOR_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [syssql].[REPORTING_PROCESS_EX_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [syssql].[ROLL_ADDITIONAL_INDEX_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[ROLL_ADDITIONAL_INDEX_TBL](
	[ROLL_UID] [int] NOT NULL,
	[ValueStr] [nchar](100) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[roll_bill_event_tbl]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[roll_bill_event_tbl](
	[roll_uid] [int] NOT NULL,
	[bill_item_uid] [int] NOT NULL,
	[bill_item_count] [int] NOT NULL,
	[bill_event_dt] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[ROLL_COST_EVENT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[ROLL_COST_EVENT_TBL](
	[ROLL_UID] [int] NOT NULL,
	[COST_ITEM_UID] [int] NOT NULL,
	[COST_ITEM_COUNT] [int] NOT NULL,
	[COST_EVENT_DT] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [syssql].[ROLL_PROCESS_IDLE_TIMES_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
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
/****** Object:  Table [syssql].[VENDOR_REPORT_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [syssql].[VENDOR_REPORT_TBL](
	[VENDOR_UID] [int] NOT NULL,
	[GUID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Index [IDX_USER_JOB_ROLL_STATUS_PID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_USER_JOB_ROLL_STATUS_PID] ON [dbo].[EVENT_TBL]
(
	[JOB_UID] ASC,
	[ROLL_UID] ASC,
	[PID] ASC,
	[STATUS_UID] ASC,
	[USER_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [FICHE_PROCESS_PID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [FICHE_PROCESS_PID] ON [dbo].[FICHE_PROCESS_TBL]
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_FICHE_PROCESS_CONT_STATUS_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_FICHE_PROCESS_CONT_STATUS_UID] ON [dbo].[FICHE_PROCESS_TBL]
(
	[CONT_STATUS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_FICHE_PROCESS_JOB_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_FICHE_PROCESS_JOB_UID] ON [dbo].[FICHE_PROCESS_TBL]
(
	[JOB_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_FICHE_PROCESS_PREV_PID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_FICHE_PROCESS_PREV_PID] ON [dbo].[FICHE_PROCESS_TBL]
(
	[PREV_PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PK_FICHE_PROCESS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [PK_FICHE_PROCESS_TBL] ON [dbo].[FICHE_PROCESS_TBL]
(
	[JOB_UID] ASC,
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IDEX_FICHE_SET_UID_JOB_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDEX_FICHE_SET_UID_JOB_UID] ON [dbo].[FICHE_SET_TBL]
(
	[FICHE_SET_UID] ASC,
	[JOB_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [PK_STATUS_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [PK_STATUS_TBL] ON [dbo].[FICHE_STATUS_TBL]
(
	[STATUS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IDX_FICHE_PROCESSED_STORAGE_LOCATION_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_FICHE_PROCESSED_STORAGE_LOCATION_UID] ON [dbo].[FICHE_TBL]
(
	[PROCESSED_STORAGE_LOCATION_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_FICHE_SET_UID_PID_STATUS]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_FICHE_SET_UID_PID_STATUS] ON [dbo].[FICHE_TBL]
(
	[FICHE_SET_UID] ASC,
	[PID] ASC,
	[STATUS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [IX_FICHE_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_FICHE_TBL] ON [dbo].[FICHE_TBL]
(
	[FICHE_SET_UID] ASC,
	[FICHE_NUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Fiche_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_Fiche_UID] ON [dbo].[FICHE_VAULT_TBL]
(
	[FICHE_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_JOB_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_JOB_TBL] ON [dbo].[JOB_TBL]
(
	[JOB_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [RollUID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [RollUID] ON [dbo].[MarinReport_TBL]
(
	[RollUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UNQ_PID_JOBUID_ParamName]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_PID_JOBUID_ParamName] ON [dbo].[PROCESS_PARAM_TBL]
(
	[PID] ASC,
	[JOB_UID] ASC,
	[ParamName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UNQ_PROG_NAME]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_PROG_NAME] ON [dbo].[PROCESS_TBL]
(
	[PROG_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IDX_time_uid]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_time_uid] ON [dbo].[PROCESS_TIME_TBL]
(
	[TIME_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_JOB_PID_STATUS]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_JOB_PID_STATUS] ON [dbo].[ROLL_TBL]
(
	[JOB_UID] ASC,
	[PID] ASC,
	[STATUS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IDX_UNIQ_ROLL_NAME_GROUP]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNIQ_ROLL_NAME_GROUP] ON [dbo].[ROLL_TBL]
(
	[ROLL_GROUP_UID] ASC,
	[ROLL_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IDX_UNIQUE_COMPUTER_NAME]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNIQUE_COMPUTER_NAME] ON [dbo].[STATION_TBL]
(
	[COMPUTER_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IDX_UNIQUE_STORAGE_LOCATION_PATH]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_UNIQUE_STORAGE_LOCATION_PATH] ON [dbo].[STORAGE_LOCATION_TBL]
(
	[STORAGE_LOCATION_PATH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IDX_PID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_PID] ON [dbo].[USER_GROUP_PROCESS_TBL]
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IDX_USER_NAME]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_USER_NAME] ON [dbo].[USER_TBL]
(
	[USER_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_VAULT_VOL_TBL]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_VAULT_VOL_TBL] ON [dbo].[VAULT_VOL_TBL]
(
	[VAULT_VOL_SERIAL_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER INDEX [IX_VAULT_VOL_TBL] ON [dbo].[VAULT_VOL_TBL] DISABLE
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_VAULT_VOL_TBL_1]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IX_VAULT_VOL_TBL_1] ON [dbo].[VAULT_VOL_TBL]
(
	[DUP_VOL_SERIAL_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER INDEX [IX_VAULT_VOL_TBL_1] ON [dbo].[VAULT_VOL_TBL] DISABLE
GO
/****** Object:  Index [UNQ_ITEM_UNIT_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_ITEM_UNIT_UID] ON [syssql].[bill_item_unit_tbl]
(
	[bill_item_unit_uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [UNQ_FICHE_UID_BILL_ITEM_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_FICHE_UID_BILL_ITEM_UID] ON [syssql].[fiche_bill_event_tbl]
(
	[fiche_uid] ASC,
	[bill_item_uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IDX_PID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE NONCLUSTERED INDEX [IDX_PID] ON [syssql].[PROCESS_MANUAL_TBL]
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IDX_PID_STATUS]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_PID_STATUS] ON [syssql].[PROCESS_MANUAL_TBL]
(
	[PID] ASC,
	[STATUS_UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [UNQ_ROLL_UID_BILL_ITEM_UID]    Script Date: 10/30/2017 1:45:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UNQ_ROLL_UID_BILL_ITEM_UID] ON [syssql].[roll_bill_event_tbl]
(
	[roll_uid] ASC,
	[bill_item_uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProQuest_Process_TBL] ADD  CONSTRAINT [DF_ProQuest_Process_TBL_ProductionStatus]  DEFAULT ((0)) FOR [ProductionStatus]
GO
USE [master]
GO
ALTER DATABASE [DigitalReelStage] SET  READ_WRITE 
GO
