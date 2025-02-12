--1)Procedure for updating maintenance date of gym equipment
CREATE PROCEDURE UpdateEquipmentMaintenanceDate
    @EquipmentID INT,
    @NewMaintenanceDate DATE
AS
BEGIN
    SET NOCOUNT ON

    UPDATE Equipment
    SET LastMaintenance = @NewMaintenanceDate
    WHERE EquipmentID = @EquipmentID
END
GO;


--2)Procedure for adding a review
CREATE PROCEDURE AddReview
    @ReviewType NVARCHAR(50),
    @ReviewID INT, 
    @MemberID INT,
    @Rating INT,
    @ReviewDate DATE,
    @Comment Nvarchar(500),
    @TrainerID INT = NULL,
    @ClassID INT = NULL,
    @DifficultyLevel INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    IF (@ReviewType = 'Trainer' ) OR (@ReviewType = 'Class')
        BEGIN
            INSERT INTO Reviews (ReviewID, MemberID, Rating, ReviewDate, Comment)
            VALUES (@ReviewId, @MemberID, @Rating, @ReviewDate, @Comment)
            IF(@ReviewType = 'Trainer')
                INSERT INTO TrainerReviews(ReviewID, TrainerID) 
                VALUES (@ReviewID,@TrainerID)
            ELSE
                INSERT INTO ClassesReviews (ReviewID, ClassID, DifficultyLevel)
                VALUES (@ReviewID, @ClassID, @DifficultyLevel)
        END
    ELSE
        BEGIN
            Print 'Wrong ReviewType - choose from: [Trainer], [Class]'
        END
    
END
GO;

--3)Procedure for updating the leaderboard
CREATE PROCEDURE UpdateLeaderboard
    @AttendanceID INT,
    @DurationHours DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MemberID INT,
            @ClassID INT,
            @Status NVARCHAR(20);

    SELECT @MemberID = MemberID, 
           @ClassID = ClassID, 
           @Status = Status
    FROM Attendance
    WHERE AttendanceID = @AttendanceID;

    IF (@Status = 'Present')
    BEGIN
        IF EXISTS
        (
            SELECT 1  --checking if member e
            FROM Leaderboard
            WHERE MemberID = @MemberID AND ClassID = @ClassID
        )
        BEGIN  
            UPDATE Leaderboard
            SET TotalTrainings = TotalTrainings + 1,
                TotalHours = TotalHours + @DurationHours
            WHERE MemberID = @MemberID AND ClassID = @ClassID;
        END
        ELSE 
        BEGIN 
            INSERT INTO Leaderboard (MemberID, ClassID, TotalTrainings, TotalHours, Rank)
            VALUES (@MemberID, @ClassID, 1, @DurationHours, 0);
        END;

        ;WITH Ranked AS
        (
            SELECT LeaderboardID, ROW_NUMBER() OVER (ORDER BY TotalHours DESC) AS NewRank
            FROM Leaderboard
            WHERE ClassID = @ClassID
        )
        UPDATE L
        SET L.Rank = R.NewRank
        FROM Leaderboard L 
        JOIN Ranked R ON L.LeaderboardID = R.LeaderboardID;
    END
    ELSE
    BEGIN
        PRINT 'Attendance status is not Present.';
    END
END;
GO;

--4)Cancelation of the memebers that havent paid duedate
CREATE Procedure CancelOverDueMembers
AS
BEGIN
    SET NOCOUNT ON

    UPDATE M
    SET M.MembershipID = NULL
    FROM Members M
    WHERE EXISTS
    (
        SELECT 1 FROM Invoices I
        WHERE I.MemberID = M.MemberID
        AND I.DueDate < GETDATE() AND I.Status IN ('Unpaid','Pending')
    )
    --adding this action into MemberShipActions
    INSERT INTO MembershipActions(MemberID, ActionType, StartDate, EndDate, CancelationDate, Reason)
    SELECT DISTINCT M.MemberID, 'Cancelation' AS ActionType, NULL AS StartDate, NULL AS EndDate, GETDATE() AS CancelationDate,
    'Membership canceled due to overdue payment' AS Reason
    FROM Members M
    WHERE M.MembershipID IS NULL
    AND EXISTS
    (
        SELECT 1 FROM INVOICES I
        WHERE I.MemberID = M.MemberID
        AND I.DueDate < GETDATE() AND I.Status IN ('Unpaid', 'Pending')
    )
END
GO;
--5) Updating the waitlist based on enrollments
CREATE PROCEDURE usp_UpdateWaitlistForClass
    @ClassID INT,
    @MaxCapacity INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentEnrollments INT,
            @AvailableSpots INT;
    --Counting available spots
    SELECT @CurrentEnrollments = COUNT(*)
    FROM ClassEnrollments
    WHERE ClassID = @ClassID
      AND Status = 'Active';

    SET @AvailableSpots = @MaxCapacity - @CurrentEnrollments;
    --if there are some then update waitlist
    IF @AvailableSpots > 0
    BEGIN
        ;WITH cteWaitlist AS (
            SELECT TOP (@AvailableSpots) w.WaitListID
            FROM Waitlists w
            INNER JOIN ClassEnrollments ce ON w.EnrollmentID = ce.EnrollmentID
            WHERE ce.ClassID = @ClassID
              AND w.Status = 'Waiting'
            ORDER BY w.QueueNumber ASC
        )--setting the status as confirmed
        UPDATE Waitlists
        SET Status = 'Confirmed'
        WHERE WaitListID IN (SELECT WaitListID FROM cteWaitlist);
    END
    --updating the queuenumber
    ;WITH UpdatedQueue AS (
        SELECT w.WaitListID,
               ROW_NUMBER() OVER (ORDER BY w.QueueNumber ASC) AS NewQueueNumber
        FROM Waitlists w
        INNER JOIN ClassEnrollments ce ON w.EnrollmentID = ce.EnrollmentID
        WHERE ce.ClassID = @ClassID
          AND w.Status = 'Waiting'
    )
    UPDATE w
    SET w.QueueNumber = uq.NewQueueNumber
    FROM Waitlists w
    INNER JOIN UpdatedQueue uq ON w.WaitListID = uq.WaitListID;
END;
