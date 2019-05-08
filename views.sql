/* ---- START ApplicationDetails_View ----  */

CREATE TABLE ApplicationDetails_View
(
	ApplicationId int NOT NULL,
	ApplicantId int NOT NULL,
	ApplicantName varchar(max),
	ApplicantWorkExperience varchar(max),
	JobId int NOT NULL,
	JobName varchar(max),
	AppliedOn datetime
)

GO

CREATE PROCEDURE RefreshApplicationDetails_View 
AS
DELETE FROM ApplicationDetails_View
INSERT INTO ApplicationDetails_View
SELECT ap.ApplicationId, u.UserID,  u.UserName, a.WorkExperience, j.JobID, j.JobName, ap.ApplicatioLastModifiedDate  
FROM User_T u, Applicant_T a, Application_T ap, Job_T j
WHERE ap.JobID = j.JobID 
AND ap.AUserID = u.UserID
AND a.AUserID= ap.AUserID

GO

EXECUTE RefreshApplicationDetails_View;

SELECT * FROM ApplicationDetails_View;

/* ---- END ApplicationDetails_View ----  */

/* ---- START NumOfCertificates_View ----  */
CREATE TABLE NumOfCertificates_View
(
	UserID int NOT NULL,
	UserName VARCHAR(255),
	UserType CHAR(1),
	CourseName VARCHAR(255),
	NumberOfCertificates int
)

GO

CREATE PROCEDURE RefreshNumOfCertificates_View
AS
delete from NumOfCertificates_View
insert into NumOfCertificates_View
select User_T.UserID, User_T.UserName, 
User_T.UserType, 
Course_T.CourseName, count(CertificateID) NumCertificates
from User_T, Certificate_T,Course_T
where User_T.UserID= Certificate_T.UserID
and Certificate_T.CourseID= Course_T.CourseID
group by User_T.UserID, User_T.UserName, User_T.UserType, Course_T.CourseName

Execute RefreshNumOfCertificates_View;

Select * from NumOfCertificates_View;

/* ---- END NumOfCertificates_View ----  */


/* ---- START OrderServicesCount_View ----  */
CREATE TABLE OrderServicesCount_View
(
	OrderID int NOT NULL, 
	ServiceCount int NOT NULL
)
GO

CREATE PROCEDURE RefreshOrderServicesCount_View 
AS 
DELETE FROM OrderServicesCount_View
INSERT INTO OrderServicesCount_View
SELECT ServiceOrder_T.OrderID, 
COUNT(ServiceOrder_ConsultationService_T.ServiceID) NumberOfServices
FROM ServiceOrder_T, ServiceOrder_ConsultationService_T
WHERE ServiceOrder_T.OrderID = ServiceOrder_ConsultationService_T.OrderID
GROUP BY ServiceOrder_T.OrderID

GO
EXECUTE RefreshOrderServicesCount_View

SELECT * FROM OrderServicesCount_View

/* ---- END OrderServicesCount_View ----  */


/* ---- START OrderDetails_View ----  */
CREATE TABLE OrderDetails_View
(
	OrderID int NOT NULL, 
	AUserID int NOT	NULL,
	UserName VARCHAR(255), 
	ServiceID int NOT NULL,
	ServiceName VARCHAR(1000), 
	ServiceDescription VARCHAR(1000),
	OrderDate date, 
	OrderTime time,
	PaymentID int NOT NULL, 
	PaymentAmount VARCHAR(15)
)

GO

CREATE PROCEDURE RefreshOrderDetails_View 
AS 
DELETE FROM OrderDetails_View
INSERT INTO OrderDetails_View
SELECT ServiceOrder_T.OrderID, Applicant_T.AUserID, User_T.UserName, 
ServiceOrder_ConsultationService_T.ServiceID, ConsultationService_T.ServiceName, ConsultationService_T.ServiceDescription,
ServiceOrder_T.OrderDate, ServiceOrder_T.OrderTime,
Payment_T.PaymentID, Payment_T.PaymentAmount
FROM Applicant_T, User_T, ServiceOrder_T, Payment_T, ConsultationService_T, ServiceOrder_ConsultationService_T
WHERE 
	ServiceOrder_T.AUserID = Applicant_T.AUserID
AND User_T.UserID = Applicant_T.AUserID
AND ServiceOrder_T.PaymentID = Payment_T.PaymentID
AND ServiceOrder_T.OrderID = ServiceOrder_ConsultationService_T.OrderID
AND ConsultationService_T.ServiceID = ServiceOrder_ConsultationService_T.ServiceID

GO

EXECUTE RefreshOrderDetails_View

SELECT * FROM OrderDetails_View ORDER BY OrderID;

/* ---- END OrderDetails_View ----  */


/* ---- START UserDetails_View ----  */
CREATE TABLE UserDetails_View
(
	UserId int NOT NULL,
	UserName varchar(25),
	Email varchar(255),
	UserType char(1),
	CompanyName varchar(255)
)

GO

CREATE PROCEDURE RefreshUserDetails_View 
AS
DELETE FROM UserDetails_View
INSERT INTO UserDetails_View
SELECT u.UserID, u.UserName, u.UserEmail, u.UserType,
c.CompanyName
FROM User_T u, Company_T c
WHERE u.CompanyID = c.CompanyID 

GO

EXECUTE RefreshUserDetails_View;

SELECT * FROM UserDetails_View;

/* ---- END UserDetails_View ----  */


/* ---- START UserSkills_View ----  */
CREATE TABLE UserSkills_View
(
	UserID int NOT NULL,
	UserName VARCHAR(255),
	UserType CHAR(1),
	SkillID int,
	SkillName VARCHAR(255),
	SkillDescription VARCHAR(1000)
)

GO

CREATE PROCEDURE RefreshUserSkills_View
AS
delete from UserSkills_View
insert into UserSkills_View
select User_T.UserID, User_T.UserName, 
User_T.UserType, 
Skill_T.SkillID,
Skill_T.SkillName,
Skill_T.SkillDescription
from User_T, Skill_T, User_Skill_T
where User_T.UserID= User_Skill_T.UserID
and User_Skill_T.SkillID= Skill_T.SkillID

EXECUTE RefreshUserSkills_View;

SELECT * FROM UserSkills_View Order by UserName;

/* ---- END UserSkills_View ----  */
