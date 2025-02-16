-- 1. View -- Average rating of each trainer

CREATE VIEW vwAverageTrainerRating AS
SELECT 
    t.TrainerID,
    t.TrainerName,
    COALESCE(AVG(r.Rating * 1.0), 0) AS AverageRating ---coalesce returns average rating or when null then 0
FROM Trainers t
LEFT JOIN TrainerReviews tr ON t.TrainerID = tr.TrainerID
LEFT JOIN Reviews r ON tr.ReviewID = r.ReviewID
GROUP BY t.TrainerID, t.TrainerName

-- 2. View -- How many transactions used a given promotional code

CREATE VIEW vwPromoCodeTransactions AS
    SELECT 
        dc.DiscountCode,
        COUNT(p.PaymentID) AS NumberOfTransactions
    FROM Payments p
    JOIN DiscountCodes dc ON p.DiscountCodeID = dc.CodeID  
    GROUP BY dc.DiscountCode;

-- 3. View -- Member Attendance 
CREATE VIEW vwMemberAttendance AS
SELECT 
    a.AttendanceID,
    a.MemberID,
    m.MembershipType,
    a.ClassID,
    c.ClassName,
    a.AttendanceDate,
    a.Status
FROM Attendance a
JOIN Members m ON a.MemberID = m.MemberID
JOIN Classes c ON a.ClassID = c.ClassID;

-- 4. View -- Classes with most and least enrollments 

CREATE VIEW vwEnrollmentExtremes AS

--CTE for coutning the number of enrollments for each class
WITH EnrollmentCounts AS (
    SELECT
        c.ClassID,
        c.ClassName,
        COUNT(e.EnrollmentID) AS EnrollmentCount
    FROM Classes c
    LEFT JOIN ClassEnrollments e
        ON c.ClassID = e.ClassID
    GROUP BY c.ClassID, c.ClassName
),
--CTE for maximum and minimumm enrollments
MinMax AS (
    SELECT
        MAX(EnrollmentCount) AS MaxEnrollment,
        MIN(EnrollmentCount) AS MinEnrollment
    FROM EnrollmentCounts
)
--select for viewing only the classes with min or max enrollments
SELECT
    ec.ClassID,
    ec.ClassName,
    ec.EnrollmentCount,
    CASE
        WHEN ec.EnrollmentCount = mm.MaxEnrollment THEN 'MAX'
        WHEN ec.EnrollmentCount = mm.MinEnrollment THEN 'MIN'
    END AS EnrollmentType
FROM EnrollmentCounts ec
CROSS JOIN MinMax mm
WHERE ec.EnrollmentCount = mm.MaxEnrollment
   OR ec.EnrollmentCount = mm.MinEnrollment;


-- 5. View -- Class average rating
CREATE VIEW vwAverageClassRating AS
SELECT
    c.ClassID,
    c.ClassName,
    c.ClassLevel,
    AVG(r.Rating) AS AverageRating
FROM Classes AS c
INNER JOIN ClassesReviews AS cr
    ON c.ClassID = cr.ClassID
INNER JOIN Reviews AS r
    ON cr.ReviewID = r.ReviewID
GROUP BY
    c.ClassID,
    c.ClassName,
    c.ClassLevel;

-- 6. View -- Top 3 members from each group
CREATE VIEW Top3InEachGroup AS
SELECT * FROM Leaderboard AS lb
WHERE lb.Rank <= 3
ORder BY lb.ClassID, lb.Rank

-- 7.View -- Count how many members have individual or company memberships
CREATE VIEW CountMembershipType AS
SELECT COUNT(*), membershiptype FROM Members
GROUP BY membershiptype

-- 8.View -- See how many active members are enrolled in each scheduled class
CREATE VIEW ActiveMembersEnrolled AS
select DISTINCT(classname), COUNT(*) AS ActiveMembersEnrolled from Classes C
JOIN ClassSchedules S ON S.ClassID = C.ClassID
JOIN ClassEnrollments E ON  S.ClassID = E.ClassID
WHERE status = 'Active'
GROUP BY scheduleid

-- 9.View -- Total income each month
SELECT MONTH(P.PaymentDate) AS [Month],SUM(AmountPaid) AS TotalIncome FROM Payments P
GROUP BY MONTH(P.PaymentDate)

-- 10.View -- Locations that need the most maintanance work
SELECT COUNT(*) as NeededMaintenance, e.FitnessClubID, fc.Address AS ClubID FROM Equipment e
JOIN FitnessClubs fc ON fc.FitnessClubID = e.FitnessClubID
WHERE e.Status IN ('Maintenance Required', 'Out of Service')
GROUP BY e.FitnessClubID, fc.Address
ORDER BY COUNT(*) DESC




