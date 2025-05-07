
CREATE TABLE #Campers (
    CamperID INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Email VARCHAR(100),
    Gender CHAR(1),  
    PersonalPhone VARCHAR(20)
);


CREATE TABLE #Camps (
    CampID INT PRIMARY KEY IDENTITY,
    CampTitle VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    Price DECIMAL(10, 2),
    Capacity INT
)
CREATE TABLE #CampVisits (
    VisitID INT PRIMARY KEY IDENTITY,
    CamperID INT,
    CampID INT,
    VisitDate DATE,
    FOREIGN KEY (CamperID) REFERENCES #Campers(CamperID),
    FOREIGN KEY (CampID) REFERENCES #Camps(CampID)
);




INSERT INTO #Campers (FirstName, MiddleName, LastName, DateOfBirth, Email, Gender, PersonalPhone)
VALUES (
    'lakshmi', '', 'Verma',
    '2024-06-07',  
    'lakshmi@example.com',
    'F',
    '9999990000'
);

select * from #Campers;



DECLARE @i INT = 1;
WHILE @i <= 4999
BEGIN
    DECLARE @Gender CHAR(1) = CASE 
        WHEN @i <= 3249 THEN 'F'  
        ELSE 'M' 
    END;

    DECLARE @AgeGroup INT = CASE
        WHEN @i <= 899 THEN 1  
        WHEN @i <= 2249 THEN 2  
        WHEN @i <= 3249 THEN 3  
        ELSE 4
    END;

    DECLARE @Age INT = CASE @AgeGroup
        WHEN 1 THEN FLOOR(RAND()*6) + 7
        WHEN 2 THEN FLOOR(RAND()*2) + 13
        WHEN 3 THEN FLOOR(RAND()*3) + 15
        ELSE FLOOR(RAND()*2) + 18
    END;

    DECLARE @DOB DATE = DATEADD(YEAR, -@Age, GETDATE());

    INSERT INTO #Campers (FirstName, MiddleName, LastName, DateOfBirth, Email, Gender, PersonalPhone)
    VALUES (
        CONCAT('Name', @i), '', CONCAT('Surname', @i),
        @DOB,
        CONCAT('name', @i, '@mail.com'),
        @Gender,
        CONCAT('999999', RIGHT('0000' + CAST(@i AS VARCHAR), 4))
    );

    SET @i += 1;
END;


select * from #Campers;

INSERT INTO #CampVisits (CamperID, CampID, VisitDate)
SELECT CamperID, 1, '2022-06-05'
FROM #Campers
WHERE FirstName = 'Lakshmi';

INSERT INTO #CampVisits (CamperID, CampID, VisitDate)
SELECT CamperID, 2, '2023-07-05'
FROM #Campers
WHERE FirstName = 'Lakshmi';

INSERT INTO #CampVisits (CamperID, CampID, VisitDate)
SELECT CamperID, 3, '2024-06-07'
FROM #Campers
WHERE FirstName = 'Lakshmi';


INSERT INTO #Camps (CampTitle, StartDate, EndDate, Price, Capacity)
VALUES 
('Camp 1', '2022-05-01', '2021-06-10', 2700, 50),
('Camp 2', '2023-02-01', '2023-07-10', 3000, 60),
('Camp 3', '2024-08-01', '2023-06-15', 6000, 70);

select * from #Camps;

SELECT COUNT(*) AS LakshmiVisits
FROM #Campers c
JOIN #CampVisits v ON c.CamperID = v.CamperID
WHERE c.FirstName = 'Lakshmi'
AND v.VisitDate >= DATEADD(YEAR, -3, GETDATE());

SELECT 
    Generation,
    SUM(CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) AS Male,
    SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) AS Female
FROM (
    SELECT 
        Gender,
        CASE 
            WHEN YEAR(DateOfBirth) BETWEEN 1965 AND 1980 THEN 'Gen X'
            WHEN YEAR(DateOfBirth) BETWEEN 1981 AND 1996 THEN 'Millennials'
            WHEN YEAR(DateOfBirth) BETWEEN 1997 AND 2012 THEN 'Gen Z'
            WHEN YEAR(DateOfBirth) >= 2013 THEN 'Gen Alpha'
            ELSE 'Other'
        END AS Generation
    FROM #Campers
) AS GenData
GROUP BY Generation;
