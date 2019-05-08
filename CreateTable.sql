/* Create Company Table */
CREATE TABLE Company_T
( 
	CompanyID int CHECK(CompanyID>0) NOT NULL,
	CompanyName varchar(255) NOT NULL,
	Industry varchar(255),
	CONSTRAINT Company_PK PRIMARY KEY (CompanyID)
);

/* Create Course Table */
CREATE TABLE Course_T 
(	CourseID int CHECK(CourseID >0) not null,
	CourseName varchar(255) not null,
	CourseContent varchar(1000),
	CONSTRAINT Course_PK PRIMARY KEY (CourseID)
);

/* Create Skill Table */
CREATE TABLE Skill_T
(
	SkillID int CHECK(SkillID>0) NOT NULL,
	SkillName varchar(255) NOT NULL,
	SkillDescription varchar(max),
	CONSTRAINT Skill_PK PRIMARY KEY(SkillID)
);

/* Create User Table */
CREATE TABLE User_T
(	
	UserID int CHECK(UserID>0) NOT NULL,
	UserName varchar(255) NOT NULL,
	UserType char(1) CHECK(UserType in('A', 'R', 'C')) NOT NULL,
	UserEmail varchar(255),
	UserAddress varchar(255),
	CompanyID int CHECK(CompanyID>0) NOT NULL,
	UserContactNumber varchar(12),
	UserDateOfBirth date,
	CONSTRAINT User_PK PRIMARY KEY (UserID),
	CONSTRAINT User_Company_FK FOREIGN KEY (CompanyID) REFERENCES Company_T(CompanyID)
);

/* Create Applicant Table */
CREATE TABLE Applicant_T
(
	AUserID int CHECK(AUserID>0) NOT NULL,
	WorkExperience varchar(255),
	ExpectedSalary decimal(10,2) CHECK(ExpectedSalary>0),
	CONSTRAINT Applicant_PK PRIMARY KEY (AUserID),
	CONSTRAINT Applicant_FK FOREIGN KEY (AUserID) REFERENCES User_T(UserID)
);

/* Create Consultant Table */
CREATE TABLE Consultant_T
(
	CUserID int CHECK(CUserID>0) NOT NULL,
	ConsultantSpecialization varchar(255), 
	ConsultantSucessRate varchar(255),
	CONSTRAINT Consultant_PK PRIMARY KEY (CUserID),
	CONSTRAINT Consultant_FK FOREIGN KEY (CUserID) REFERENCES User_T(UserID)
);

/* Create Recruiter Table */
CREATE TABLE Recruiter_T 
(	RUserID int CHECK(RUserID >0) not null,
	Department varchar(255),
	CONSTRAINT Recruiter_PK PRIMARY KEY (RUserID),
	CONSTRAINT Recruiter_FK FOREIGN KEY (RUserID) REFERENCES User_T(UserID)
);

/* Create User Recommendation Table */
CREATE TABLE Recommendation_T
( 
	RecommendationID int CHECK(RecommendationID>0) NOT NULL,
	RecommendationContent varchar(1000),
	UserID int CHECK(UserID>0) NOT NULL,
	CONSTRAINT Recommendation_PK PRIMARY KEY (RecommendationID),
	CONSTRAINT Recommendation_FK Foreign key (UserID) REFERENCES User_T(UserID)
);

/* Create User_Skill_T M2M Table */

CREATE TABLE User_Skill_T(
	UserSkillID int CHECK(UserSkillID >0 ) NOT NULL,
	UserID int NOT NULL,
	SkillID int NOT NULL,
	CONSTRAINT User_Skill_PK PRIMARY KEY (UserSkillID),
	CONSTRAINT User_Skill_FK1 FOREIGN KEY (UserID) REFERENCES User_T(UserID),
	CONSTRAINT User_Skill_FK2 FOREIGN KEY (SkillID) REFERENCES Skill_T(SkillID)
)

/* Create User's Certificate Table */
CREATE TABLE Certificate_T 
(	CertificateID int CHECK(CertificateID >0) not null,
	UserId int,
	CourseID int,
	DateCompleted date,
	CONSTRAINT Certificate_PK PRIMARY KEY (CertificateID),
	CONSTRAINT Certificate_FK1 FOREIGN KEY (UserId) REFERENCES User_T(UserId),
	CONSTRAINT Certificate_FK2 FOREIGN KEY (CourseID) REFERENCES Course_T(CourseID)
);

/* Create Applicant's Resume Table */
CREATE TABLE Resume_T
(
	ResumeID int CHECK(ResumeID>0) NOT NULL,
	FileType varchar(4),
	DateOfCreation datetime,
	FileSize decimal(6,2),
	FileName varchar(255) NOT NULL,
	FileContent varchar(max),
	AUserID int CHECK(AUserID>0),
	CONSTRAINT Resume_PK PRIMARY KEY (ResumeID),
	CONSTRAINT Resume_User_FK FOREIGN KEY(AUserID) REFERENCES Applicant_T(AUserID)
);


/* Create User History Table */
CREATE TABLE UserHistory_T(
	UserHistoryID int CHECK(UserHistoryID > 0 ) NOT NULL,
	ActivityDescription varchar(1000) ,
	UserID int NOT NULL,
	CONSTRAINT UserHistory_PK PRIMARY KEY (UserHistoryID),
	CONSTRAINT UserHistory_FK FOREIGN KEY (UserID) REFERENCES User_T(UserID),
)

/* Create Users Message Table */
CREATE TABLE Message_T
(
	MessageID int CHECK(MessageID>0) NOT NULL,
	Content varchar(max) NOT NULL,
	MessageTimestamp Datetime,
	SentTo int CHECK(SentTo>0) NOT NULL,
	SentBy int CHECK(SentBy>0) NOT NULL,
	CONSTRAINT Message_PK PRIMARY KEY (MessageID),
	CONSTRAINT Message_UserID_FK FOREIGN KEY (SentTo) REFERENCES User_T(UserID),
	CONSTRAINT Message_SentBy_FK FOREIGN KEY (SentBy) REFERENCES User_T(UserID)
);


/* Create ConsultantSuggestedCourse Table - m2m table for course suggested by consultants */
CREATE TABLE ConsultantSuggestedCourse_T(
	Consultant_CourseId int CHECK(Consultant_CourseId > 0 ) NOT NULL,
	CUserID int NOT NULL,
	CourseID int NOT NULL,
	CONSTRAINT ConsultantSuggestedCourse_PK PRIMARY KEY (Consultant_CourseId),
	CONSTRAINT ConsultantSuggestedCourse_FK1 FOREIGN KEY (CUserID) REFERENCES Consultant_T(CUserId),
	CONSTRAINT ConsultantSuggestedCourse_FK2 FOREIGN KEY (CourseID) REFERENCES Course_T(CourseID)
)

/* Create Job Table */

CREATE TABLE Job_T
(
	JobID int CHECK(JobID>0) NOT NULL,
	JobType char(1) CHECK(Jobtype in ('F','I', 'C')) NOT NULL,
	JobName varchar(255),
	JobDescription varchar(1000),
	JobLocation varchar(255),
	RUserID int CHECK(RUserID>0) NOT NULL,
	CONSTRAINT Job_PK PRIMARY KEY (JobID),
	CONSTRAINT Job_Recruiter_FK FOREIGN KEY (RUserID) REFERENCES Recruiter_T(RUserID)
);


/* Create Intern Table -- SubType of JOB */ 
CREATE TABLE Intern_T
(
	IJobID int CHECK(IJobID>0) NOT NULL,
	HoursWorked decimal(6,2) CHECK (HoursWorked>0),
	BillingRate decimal(6,2) CHECK(BillingRate>0),
	CONSTRAINT Intern_PK PRIMARY KEY (IJobID),
	CONSTRAINT Intern_FK FOREIGN KEY (IJobId) REFERENCES Job_T(JobID)
);


/* Create Contract Table -- SubType of JOB */
CREATE TABLE Contract_T
(
	CJobID int CHECK(CJobID>0) NOT NULL,
	HoursWorked decimal(6,2) CHECK(HoursWorked>0),
	BillingRate decimal(6,2) CHECK(BillingRate>0), 
	ContractStartDate date NOT NULL,
	ContractEndDate date NOT NULL,
	CONSTRAINT Contract_PK PRIMARY KEY (CJobID),
	CONSTRAINT Contract_FK FOREIGN KEY (CJobId) REFERENCES Job_T(JobID)
);

/* Create FullTime Table -- SubType of JOB */ 
CREATE TABLE FullTime_T
(
	FJobID int CHECK(FJobID>0) NOT NULL,
	Salary decimal(10,2) CHECK(Salary>0),
	StockOption int CHECK (StockOption>0),
	CONSTRAINT FullTime_PK PRIMARY KEY (FJobID),
	CONSTRAINT FullTime_FK FOREIGN KEY (FJobId) REFERENCES Job_T(JobID)
);


/* Create ConsultationService_T Table -- Services Provided */
CREATE TABLE ConsultationService_T
(
	ServiceID int CHECK(ServiceID>0) NOT NULL,
	ServiceName varchar(1000) NOT NULL,
	ServiceDescription varchar(1000),
	Servicefee decimal(5,2) CHECK(Servicefee>0) NOT NULL,
	CONSTRAINT ConsultationService_PK PRIMARY KEY (ServiceID)
);


/* Create Consultant_ConsultationService M2M Table -- Service Provided by Consultant */
CREATE TABLE Consultant_ConsultationService_T
(
	Consultant_ConsultationServiceId int CHECK(Consultant_ConsultationServiceId > 0 ) NOT NULL,
	CUserID int NOT NULL,
	ServiceID int NOT NULL,
	CONSTRAINT Consultant_ConsultationService_PK PRIMARY KEY (Consultant_ConsultationServiceId),
	CONSTRAINT Consultant_ConsultationService_FK1 FOREIGN KEY (CUserID) REFERENCES Consultant_T(CUserId),
	CONSTRAINT Consultant_ConsultationService_FK2 FOREIGN KEY (ServiceID) REFERENCES ConsultationService_T(ServiceID)
)

CREATE TABLE Payment_T
(
	PaymentID int CHECK(PaymentID>0) NOT NULL,
	PaymentType varchar(15),
	PaymentAmount varchar(15),
	PaymentDate datetime,
	CONSTRAINT Payment_PK PRIMARY KEY(PaymentID)
);

CREATE TABLE ServiceOrder_T
(
	OrderID int CHECK(OrderID>0) NOT NULL,
	OrderDate date,
	OrderTime time,
	AUserID int CHECK(AUserID>0) NOT NULL,
	PaymentID int,
	CONSTRAINT ServiceOrder_PK Primary key (OrderID),
	CONSTRAINT ServiceOrder_FK2 Foreign key(AUserID) REFERENCES Applicant_T(AUserID),
	CONSTRAINT ServiceOrder_FK3 Foreign Key(PaymentID) References Payment_T(PaymentID) 
);


CREATE TABLE ServiceOrder_ConsultationService_T
(
	SOrder_ConsultationServiceID int CHECK(SOrder_ConsultationServiceID >0 ) NOT NULL,
 	OrderID int NOT NULL,
 	ServiceID int NOT NULL,
	CONSTRAINT ServiceOrder_ConsultationService_PK PRIMARY KEY (SOrder_ConsultationServiceID),
	CONSTRAINT ServiceOrder_ConsultationService_FK1 FOREIGN KEY (OrderID) REFERENCES ServiceOrder_T(OrderID),
	CONSTRAINT ServiceOrder_ConsultationService_FK2 FOREIGN KEY (ServiceID) REFERENCES ConsultationService_T(ServiceID)
)

CREATE TABLE Application_T
(
	ApplicationID int CHECK(ApplicationID > 0) NOT NULL,
	AUserID int CHECK(AUserID > 0) NOT NULL,
	JobID int CHECK(JobID > 0) NOT NULL,
	ResumeID int CHECK(ResumeID > 0) NOT NULL,
	ApplicatioLastModifiedDate datetime NULL,
	CONSTRAINT Application_PK PRIMARY KEY (ApplicationID),
	CONSTRAINT Application_FK1 FOREIGN KEY (AUserID) REFERENCES Applicant_T(AUserID),
	CONSTRAINT Application_FK2 FOREIGN KEY (JobID) REFERENCES Job_T(JobID),
	CONSTRAINT Application_FK3 FOREIGN KEY (ResumeID) REFERENCES Resume_T(ResumeID)
)
