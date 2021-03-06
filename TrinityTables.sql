USE [master]
GO
/****** Object:  Database [TrinityQCDB_Stage]    Script Date: 7/17/2020 2:10:33 PM ******/
CREATE DATABASE [TrinityQCDB_Stage]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TrinityQCDB_Stage', FILENAME = N'i:\MSSQL11.B\MSSQL\DATA\TrinityQCDB_Stage.mdf' , SIZE = 6144KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TrinityQCDB_Stage_log', FILENAME = N'h:\MSSQL11.B\MSSQL\Log\TrinityQCDB_Stage_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [TrinityQCDB_Stage] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TrinityQCDB_Stage].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TrinityQCDB_Stage] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET ARITHABORT OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET  MULTI_USER 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TrinityQCDB_Stage] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TrinityQCDB_Stage] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [TrinityQCDB_Stage]
GO
/****** Object:  User [TrinityQCStageUser]    Script Date: 7/17/2020 2:10:34 PM ******/
CREATE USER [TrinityQCStageUser] FOR LOGIN [TrinityQCStageUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [TrinityQCStageUser]
GO
/****** Object:  Table [dbo].[Activity]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Activity](
	[ActivityID] [int] IDENTITY(1,1) NOT NULL,
	[BoxID] [int] NOT NULL,
	[UserID] [nvarchar](max) NULL,
	[StatusId] [int] NOT NULL,
	[ActivityDateTime] [datetime] NOT NULL,
	[Comments] [varchar](250) NULL,
	[ProcessId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Activity] PRIMARY KEY CLUSTERED 
(
	[ActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ActivityDetails]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityDetails](
	[ActivityDetailID] [int] IDENTITY(1,1) NOT NULL,
	[ActivityID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
	[Answer] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[ImageID] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.ActivityDetails] PRIMARY KEY CLUSTERED 
(
	[ActivityDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Applications]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Applications](
	[ApplicationName] [nvarchar](235) NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[OldRoleId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[AuthyId] [nvarchar](max) NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[CreateDate] [datetime] NULL,
	[ConfirmationToken] [nvarchar](128) NULL,
	[LastPasswordFailureDate] [datetime] NULL,
	[PasswordChangedDate] [datetime] NULL,
	[PasswordSalt] [nvarchar](128) NULL,
	[PasswordVerificationToken] [nvarchar](128) NULL,
	[PasswordVerificationTokenExpirationDate] [datetime] NULL,
	[IsEnabled] [int] NOT NULL,
	[ResetPassword] [bit] NOT NULL,
	[PassWordNotCompatible] [bit] NOT NULL,
	[SplitCode] [bit] NOT NULL,
	[PictureUrl] [nchar](100) NULL,
	[OldUserId] [int] NULL,
	[UserDesc] [nchar](100) NULL,
	[AccessFailedCount] [int] NOT NULL,
	[LastLoginDate] [date] NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Boxes]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Boxes](
	[BoxID] [int] IDENTITY(1,1) NOT NULL,
	[BoxName] [nvarchar](100) NOT NULL,
	[DateAvailable] [datetime] NOT NULL,
	[StatusID] [int] NOT NULL,
	[ProcessID] [int] NOT NULL,
	[ImagesLocation] [nvarchar](max) NULL,
	[PercentOfCards] [int] NULL,
 CONSTRAINT [PK_dbo.Boxes] PRIMARY KEY CLUSTERED 
(
	[BoxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Notification]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notification](
	[NotificationID] [int] IDENTITY(1,1) NOT NULL,
	[NotificationDateTime] [datetime] NOT NULL,
	[FromUserId] [nvarchar](max) NULL,
	[ToUserId] [nvarchar](max) NULL,
	[Message] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Notification] PRIMARY KEY CLUSTERED 
(
	[NotificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Process]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Process](
	[ProcessID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessDescription] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Process] PRIMARY KEY CLUSTERED 
(
	[ProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Questions]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questions](
	[QuestionID] [int] IDENTITY(1,1) NOT NULL,
	[Question] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Questions] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Roles]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sessions]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sessions](
	[SessionId] [nvarchar](88) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Expires] [datetime] NOT NULL,
	[LockDate] [datetime] NOT NULL,
	[LockCookie] [int] NOT NULL,
	[Locked] [bit] NOT NULL,
	[SessionItem] [image] NULL,
	[Flags] [int] NOT NULL,
	[Timeout] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Status]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusDescription] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Status] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[IsAnonymous] [bit] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UsersInRoles]    Script Date: 7/17/2020 2:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersInRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [IX_BoxID]    Script Date: 7/17/2020 2:10:34 PM ******/
CREATE NONCLUSTERED INDEX [IX_BoxID] ON [dbo].[Activity]
(
	[BoxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ActivityID]    Script Date: 7/17/2020 2:10:34 PM ******/
CREATE NONCLUSTERED INDEX [IX_ActivityID] ON [dbo].[ActivityDetails]
(
	[ActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Activity] ADD  DEFAULT ((1)) FOR [ProcessId]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_EmailConfirmed]  DEFAULT ((0)) FOR [EmailConfirmed]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_PhoneNumberConfirmed]  DEFAULT ((0)) FOR [PhoneNumberConfirmed]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_TwoFactorEnabled]  DEFAULT ((0)) FOR [TwoFactorEnabled]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_LockoutEnabled]  DEFAULT ((0)) FOR [LockoutEnabled]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_IsEnabled]  DEFAULT ((0)) FOR [IsEnabled]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_ResetPassword]  DEFAULT ((0)) FOR [ResetPassword]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_NotCompatible]  DEFAULT ((0)) FOR [PassWordNotCompatible]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF_AspNetUsers_SplitCode]  DEFAULT ((0)) FOR [SplitCode]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ((0)) FOR [AccessFailedCount]
GO
ALTER TABLE [dbo].[Activity]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Activity_dbo.Boxes_BoxID] FOREIGN KEY([BoxID])
REFERENCES [dbo].[Boxes] ([BoxID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Activity] CHECK CONSTRAINT [FK_dbo.Activity_dbo.Boxes_BoxID]
GO
ALTER TABLE [dbo].[ActivityDetails]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ActivityDetails_dbo.Activity_ActivityID] FOREIGN KEY([ActivityID])
REFERENCES [dbo].[Activity] ([ActivityID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ActivityDetails] CHECK CONSTRAINT [FK_dbo.ActivityDetails_dbo.Activity_ActivityID]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[Roles]  WITH CHECK ADD  CONSTRAINT [RoleApplication] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[Roles] CHECK CONSTRAINT [RoleApplication]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [UserApplication] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [UserApplication]
GO
USE [master]
GO
ALTER DATABASE [TrinityQCDB_Stage] SET  READ_WRITE 
GO
