-- CREATE DATABASE HighSchoolDB
USE HighSchoolDB
GO

CREATE TABLE [User]
(
	Id CHAR(9) PRIMARY KEY,
	Username VARCHAR(20) UNIQUE NOT NULL,
	Password VARCHAR(20) NOT NULL,
	Permission VARCHAR(6) NOT NULL
)
GO
CREATE TABLE Student
(
	Id CHAR(9) PRIMARY KEY,
	Fullname NVARCHAR(50) NOT NULL,
	Address NVARCHAR(100) NOT NULL,
	Gender CHAR(1) NOT NULL CHECK (Gender = 'F' OR Gender = 'M'),
	Birthdate DATE NOT NULL,
	CONSTRAINT fk_id_st_id_user FOREIGN KEY (Id) REFERENCES [User](Id)
)
GO

CREATE TABLE PoorStudent
(
	Id CHAR(9) PRIMARY KEY,
	Poorcode CHAR(10) NOT NULL,
	Remuneration NVARCHAR(30) NOT NULL,
	CONSTRAINT fk_id_pst_id_st FOREIGN KEY (Id) REFERENCES Student(Id)
)

CREATE TABLE WoundedStudent
(
	Id CHAR(9) PRIMARY KEY,
	Type NVARCHAR(20) NOT NULL,
	CONSTRAINT fk_wst_st_id FOREIGN KEY(Id) REFERENCES Student(Id)
)

CREATE TABLE Dependents
(
	Id_student CHAR(9),
	Fullname VARCHAR(50),
	Address NVARCHAR(100) NOT NULL,
	Phonenumber CHAR(11) NOT NULL,
	Relationship NVARCHAR(20) NOT NULL,
	PRIMARY KEY(Id_student, Fullname),
	CONSTRAINT fk_id_st_spd_st_id FOREIGN KEY(Id_student) REFERENCES Student(Id)
)
CREATE TABLE Teacher
(
	Id CHAR(9) PRIMARY KEY,
	Fullname NVARCHAR(50) NOT NULL,
	Gender CHAR(1) CHECK(Gender = 'F' OR GENDER = 'M'),
	Email VARCHAR(20) NOT NULL,
	Address NVARCHAR(100) NOT NULL,
	Phonenumber CHAR(11) NOT NULL,
	Identitycardnumber VARCHAR(12) NOT NULL,
	Birthdate DATE NOT NULL,
	Group_id INT NOT NULL,
	CONSTRAINT fk_id_tc_id_user FOREIGN KEY(Id) REFERENCES [User](Id)
)
GO
CREATE TABLE Teacher_degrees
(
	Id CHAR(9),
	Degree NVARCHAR(20),
	PRIMARY KEY(Id, Degree),
	CONSTRAINT fk_id_tc_tcdegree_id_tc FOREIGN KEY(Id) REFERENCES Teacher(Id)
)
CREATE TABLE ContractTeacher
(
	Id CHAR(9) PRIMARY KEY,
	Basicsalary FLOAT NOT NULL,
	Startdate DATE NOT NULL,
	Enddate DATE,
	CONSTRAINT fk_id_tc_cttc_id_tc FOREIGN KEY(Id) REFERENCES Teacher(Id)
)
CREATE TABLE PayrollTeacher
(
	Id CHAR(9) PRIMARY KEY,
	Salary FLOAT NOT NULL,
	Bonus FLOAT,
	Coefficient FLOAT NOT NULL,
	CONSTRAINT fk_id_tc_prtc_tc_id FOREIGN KEY(Id) REFERENCES Teacher(Id)
)

CREATE TABLE Teacher_scores
(
	Id_assessor CHAR(9),
	Id_judged CHAR(9),
	Date DATE,
	Score FLOAT NOT NULL,
	PRIMARY KEY (Id_assessor, Id_judged, Date),
	CONSTRAINT fk_id_assessor_tcscore_id_tc FOREIGN KEY (Id_assessor) REFERENCES Teacher(Id),
	CONSTRAINT fk_id_judged_idscore_id_tc FOREIGN KEY (Id_judged) REFERENCES Teacher(Id)
)

GO
CREATE TABLE [Group]
(
	Id INT PRIMARY KEY,
	Name NVARCHAR(20) NOT NULL,
	Date DATE NOT NULL
)
GO
CREATE TABLE GroupLeader
(
	Id_leader CHAR(9),
	start_date DATE,
	Id_group INT NOT NULL,
	PRIMARY KEY(Id_leader, start_date),
	CONSTRAINT fk_id_grleader_id_group FOREIGN KEY(Id_group) REFERENCES [Group](Id)
)
GO
CREATE TABLE Subject
(
	Id CHAR(6) PRIMARY KEY,
	name NVARCHAR(30) NOT NULL,
	num_periods INT NOT NULL,
	syllabus NVARCHAR(50) NOT NULL,
	ratio_score_15 INT NOT NULL,
	ratio_score_45 INT NOT NULL,
	ratio_score_final INT NOT NULL,
	Id_group INT NOT NULL,
	CONSTRAINT fk_idsub_id_group FOREIGN KEY(Id_group) REFERENCES [Group](Id)
)
GO
CREATE TABLE Teacher_Subject
(
	Id_teacher CHAR(9),
	Id_subject CHAR(6),
	PRIMARY KEY(Id_teacher, Id_subject)
)
GO
CREATE TABLE Building
(
	Id CHAR(4) PRIMARY KEY,
	name NVARCHAR(20) NOT NULL,
	start_date DATE
)
GO
CREATE TABLE Room
(
	Id_building CHAR(4),
	Id_room CHAR(6),
	name NVARCHAR(20) NOT NULL,
	capacity INT,
	PRIMARY KEY(Id_building, Id_room),
	CONSTRAINT fk_id_buildingroom_id_build FOREIGN KEY(Id_building) REFERENCES Building(Id)
)
GO
CREATE TABLE Year
(
	Id CHAR(10),
	name VARCHAR(15) NOT NULL,
	PRIMARY KEY(Id)
)
GO
CREATE TABLE Semester
(
	Id_Year CHAR(10),
	Id_Semester CHAR(5),
	name VARCHAR(15) NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE,
	PRIMARY KEY(Id_year, Id_Semester),
	CONSTRAINT fk_id_yearsemester_id_year FOREIGN KEY(Id_Year) REFERENCES Year(Id)
)
GO
CREATE TABLE Class
(
	Id CHAR(9) PRIMARY KEY,
	name NVARCHAR(20) NOT NULL,
	Id_Year CHAR(10) NOT NULL,
	Id_building CHAR(4),
	Id_room CHAR(6),
	Id_monitor CHAR(9),
	Id_form_teacher CHAR(9),
	CONSTRAINT fk_id_yearclass_id_year FOREIGN KEY(Id_year) REFERENCES YEAR(Id),
	CONSTRAINT fk_id_buildingroom_class_id_room FOREIGN KEY(Id_building, Id_room) REFERENCES Room(Id_building, Id_room),
	CONSTRAINT fk_id_monitorclass_id_student FOREIGN KEY(Id_monitor) REFERENCES Student(Id),
	CONSTRAINT fk_id_formteacherclass_id_teacher FOREIGN KEY(Id_form_teacher) REFERENCES Teacher(Id)
)
GO
CREATE TABLE Join_Class
(
	Id_class CHAR(9),
	Id_student CHAR(9),
	conduct NVARCHAR(10),
	title NVARCHAR (15) NOT NULL,
	PRIMARY KEY(Id_class, Id_student),
	CONSTRAINT fk_class_joinclass_id_class FOREIGN KEY(Id_class) REFERENCES Class(Id),
	CONSTRAINT fk_id_student_joinclass_id_student FOREIGN KEY(Id_student) REFERENCES Student(Id)
)
GO
CREATE TABLE Scores
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	final_exam_score FLOAT NOT NULL,
	Id_year CHAR(10) NOT NULL,
	Id_semester CHAR(5) NOT NULL,
	Id_class CHAR(9) NOT NULL,
	Id_subject CHAR(6) NOT NULL,
	Id_student CHAR(9) NOT NULL,
	CONSTRAINT fk_id_semesterscores_id_semester FOREIGN KEY(Id_year, Id_semester) REFERENCES Semester(Id_Year, Id_Semester),
	CONSTRAINT fk_id_classscores_id_class FOREIGN KEY(Id_class) REFERENCES Class(Id),
	CONSTRAINT fk_id_subscores_id_sub FOREIGN KEY(Id_subject) REFERENCES Subject(Id),
	CONSTRAINT fk_id_studentscores_id_student FOREIGN KEY(Id_student) REFERENCES Student(Id)
)
GO
CREATE TABLE Scores_15_mintues
(
	Id_score INT,
	time INT IDENTITY(1, 1),
	score FLOAT NOT NULL,
	PRIMARY KEY(Id_score, time),
	CONSTRAINT fk_id_score_15_id_score FOREIGN KEY(Id_score) REFERENCES Scores(Id)
	
)
CREATE TABLE Scores_45_minutes
(
	Id_score INT,
	time INT IDENTITY(1, 1),
	score FLOAT NOT NULL,
	PRIMARY KEY(Id_score, time),
	CONSTRAINT fk_id_score_45_id_score FOREIGN KEY(Id_score) REFERENCES Scores(Id)
)
GO
CREATE TABLE Scheduler
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Id_year CHAR(10) NOT NULL,
	Id_semester CHAR(5) NOT NULL,
	Id_class CHAR(9) NOT NULL CONSTRAINT fk_id_classscheduler_id_class REFERENCES Class(Id),
	Id_teacher CHAR(9) NOT NULL CONSTRAINT fk_id_tearcherscheduler_id_teacher REFERENCES Teacher(Id),
	Id_subject CHAR(6) NOT NULL CONSTRAINT fk_id_subjectscheduler_id_subject REFERENCES Subject(Id),
	CONSTRAINT fk_id_semesterscheduler_id_semester FOREIGN KEY(Id_year, Id_semester) REFERENCES Semester(Id_Year, Id_Semester)
)
GO
CREATE TABLE TeachingTime
(
	Id_scheduler INT,
	day NVARCHAR(20),
	session NVARCHAR(20),
	start_hour TIME,
	end_hour TIME NOT NULL,
	PRIMARY KEY(Id_scheduler, day, session, start_hour),
	CONSTRAINT fk_id_scheduler_teachingtime_id_scheduler FOREIGN KEY(Id_scheduler) REFERENCES Scheduler(Id)
)
