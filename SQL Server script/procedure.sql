USE HighSchoolDB
GO
CREATE PROC insert_teacher
	@Id CHAR(9),
	@Fullname NVARCHAR(50),
	@Gender CHAR(1),
	@Email VARCHAR(20),
	@Address NVARCHAR(100),
	@Phonenumber CHAR(11),
	@CardId VARCHAR(12),
	@Birthdate DATE,
	@Group_id INT
AS
BEGIN
	-- check fullname is valid
	IF @Fullname LIKE '%[0-9!@#$%^&*();:,<.>/?`|\_~-=]%'
	BEGIN
		PRINT N'Tên giáo viên không chứa số hay các ký tự đặc biệt'
		RETURN
    END
	
	-- check email is valid
	IF @Email NOT LIKE '%_@__%.__%'
	BEGIN
		PRINT N'Email không hợp lệ'
		RETURN
	END

	-- check gender is valid
	IF @Gender NOT IN ('M', 'F')
	BEGIN
		PRINT N'Giới tính phải là M (Nam) hoặc F (Nữ)'
		RETURN
	END

	-- check phone number is valid
	IF ISNUMERIC(@Phonenumber) = 0
	BEGIN
		PRINT N'Số điện thoại không phải là 1 số hợp lệ'
		RETURN
	END
	IF SUBSTRING(@Phonenumber, 2, 1) NOT LIKE '[1-9]'
	BEGIN
		PRINT N'Ký tự thứ 2 của số điện thoại phải khác 0'
		RETURN		
	END
	IF LEN(@Phonenumber) NOT IN (10, 11)
	BEGIN
		PRINT N'Độ dài số điện thoại phải là 10 hoặc 11'
		RETURN
    END

	-- check card id is valid
	IF ISNUMERIC(@CardId) = 0
	BEGIN
		PRINT N'Số CMND không phải là 1 số hợp lệ'
		RETURN
	END
	IF LEN(@CardId) NOT IN (9, 12)
	BEGIN
		PRINT N'Độ dài số CMND phải là 9 hoặc 12'
		RETURN
    END

	-- check age of teacher
	IF YEAR(GETDATE()) - YEAR(@Birthdate) < 22
	BEGIN
		PRINT N'Số tuổi của giáo viên phải không nhỏ hơn 22 tuổi'
		RETURN
    END

	INSERT dbo.Teacher
	(
	    Id,
	    Fullname,
	    Gender,
	    Email,
	    Address,
	    Phonenumber,
	    Identitycardnumber,
	    Birthdate,
	    Group_id
	)
	VALUES
	(   @Id,        -- Id - char(9)
	    @Fullname,       -- Fullname - nvarchar(50)
	    @Gender,        -- Gender - char(1)
	    @Email,        -- Email - varchar(20)
	    @Address,       -- Address - nvarchar(100)
	    @Phonenumber,        -- Phonenumber - char(11)
	    @CardId,        -- Identitycardnumber - varchar(12)
	    @Birthdate, -- Birthdate - date
	    @Group_id          -- Group_id - int
	)
END