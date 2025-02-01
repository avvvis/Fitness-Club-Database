
--Club related tabels
CREATE TABLE FitnessClubs (
    FitnessClubID INT PRIMARY KEY,
    Address NVARCHAR(255) NOT NULL
);

CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY,
    Name NVARCHAR(100),
    FitnessClubID INT,
    LastMaintenance DATE,
    PurchaseDate DATE,
    Status NVARCHAR(50) NOT NULL CHECK (Status IN ('Operational', 'Maintenance Required', 'Out of Service')),
    FOREIGN KEY (FitnessClubID) REFERENCES FitnessClubs(FitnessClubID) ON DELETE CASCADE
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    Phone NVARCHAR(20) UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    FitnessClubID INT,
    Position NVARCHAR(100)
    FOREIGN KEY (FitnessClubID) REFERENCES FitnessClubs(FitnessClubID)
);

--Member related tables

CREATE TABLE Memberships (
    MembershipID INT PRIMARY KEY,
    MembershipName NVARCHAR(100),
    PricePerMonth DECIMAL(10,2),
    DurationMonths INT
);

--Parent table for all members - both indivduals and comapnies

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    MembershipType NVARCHAR(20) CHECK (MembershipType IN ('Individual', 'Company')),
    MembershipID INT,
    JoinDate DATE,
    FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID) ON DELETE CASCADE
);


--subclass for indvidual members(inherits from Members)
CREATE TABLE IndividualMemberships (
    MemberID INT PRIMARY KEY,
    MemberName NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    MembershipID INT
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
);
--subclass for company membersips (inherits from Members)

CREATE TABLE CompanyMemberships (
    MemberID INT PRIMARY KEY,
    CompanyName NVARCHAR(256),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
);


CREATE TABLE MembershipActions (
    ActionID INT PRIMARY KEY,
    MemberID INT,
    ActionType NVARCHAR(20) CHECK (ActionType IN ('Suspension', 'Cancelation')),
    StartDate DATE NULL,
    EndDate DATE NULL,
    CancelationDate DATE NULL,
    Reason NVARCHAR(500),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
);  

--Payment related tables

CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY,
    MemberID INT,
    IssueDate DATE,
    DueDate DATE,
    TotalAmount MONEY,
    Status  NVARCHAR(20) NOT NULL CHECK (Status IN ('Paid', 'Unpaid', 'Pending')),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) 

);
CREATE TABLE DiscountCodes (
    CodeID INT PRIMARY KEY,
    DiscountCode NVARCHAR(20),
    DiscountPercentage INT,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN('Active', 'Inactive'))
);
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    MemberID INT,
    InvoiceID INT,
    AmountPaid MONEY,
    PaymentDate DATE,
    DiscountCodeID INT,
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID) ON DELETE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (DiscountCodeID) REFERENCES DiscountCodes(CodeID) ON DELETE SET NULL
);

--Trainer related tables

CREATE TABLE Trainers (
    TrainerID INT PRIMARY KEY,
    TrainerName NVARCHAR(100),
    Specialization NVARCHAR(100),
    Phone NVARCHAR(20) UNIQUE,
    Email NVARCHAR(100) UNIQUE
);

CREATE TABLE PersonalTrainings (
    TrainingID INT PRIMARY KEY,
    TrainerID INT,
    MemberID INT,
    TrainingDate DATE,
    DurationHours DECIMAL(3,1),
    PaymentID INT,
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID),
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);


--Class related tables

CREATE TABLE Classes (
    ClassID INT PRIMARY KEY,
    ClassName NVARCHAR(100),
    ClassLevel INT NOT NULL CHECK (ClassLevel BETWEEN 1 AND 5)
);

CREATE TABLE ClassTypes (
    ClassID INT,
    TrainerID INT
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID)
);

CREATE TABLE ClassEnrollments (
    EnrollmentID INT PRIMARY KEY,
    MemberID INT,
    ClassID INT,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Active', 'Completed', 'Dropped')),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);

CREATE TABLE ClassSchedules (
    ScheduleID INT PRIMARY KEY,
    ClassID INT,
    TrainerID INT,
    Room NVARCHAR(10),
    Day NVARCHAR(10) NOT NULL CHECK (Day IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    StartTime TIME,
    EndTime TIME,
    FitnessClubID INT,
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (FitnessClubID) REFERENCES FitnessClubs(FitnessClubID)
);

CREATE TABLE Waitlists (
    WaitListID INT PRIMARY KEY,
    QueueNumber INT,
    EnrollmentID INT,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Waiting', 'Confirmed', 'Cancelled')), 
    FOREIGN KEY (EnrollmentID) REFERENCES ClassEnrollments(EnrollmentID) ON DELETE CASCADE
);

CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY,
    EnrollmentID INT,
    MemberID INT ,
    ClassID INT,
    AttendanceDate DATE,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Present', 'Absent', 'Excused')),
    FOREIGN KEY (EnrollmentID) REFERENCES ClassEnrollments(EnrollmentID) ON DELETE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE,
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID) ON DELETE CASCADE
);


CREATE TABLE Leaderboard (
    LeaderboardID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT,
    ClassID INT,
    TotalTrainings INT,
    TotalHours DECIMAL(10,2),
    Rank INT NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    UNIQUE (ClassID, Rank)

);
--Reviews - parent class for trainerReviews and ClassReviews

CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY,
    MemberID INT ,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    ReviewDate DATE NOT NULL,
    Comment NVARCHAR(255) NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
);
--subclasses :

CREATE TABLE TrainerReviews (
    ReviewID INT PRIMARY KEY,
    TrainerID INT NOT NULL,
    FOREIGN KEY (ReviewID) REFERENCES Reviews(ReviewID) ON DELETE CASCADE,
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID) ON DELETE CASCADE
);

CREATE TABLE ClassesReviews (
    ReviewID INT PRIMARY KEY,
    ClassID INT NOT NULL,
    DifficultyLevel INT NOT NULL CHECK (DifficultyLevel BETWEEN 1 AND 5), 
    FOREIGN KEY (ReviewID) REFERENCES Reviews(ReviewID) ON DELETE CASCADE,
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID) ON DELETE CASCADE
);

--Additional tables

CREATE TABLE Merch (
    ItemID INT PRIMARY KEY,
    ItemName NVARCHAR(50) NOT NULL,
    ItemPrice DECIMAL(10,2) NOT NULL CHECK (ItemPrice >= 0)  
);

CREATE TABLE MerchOrders (
    OrderID INT PRIMARY KEY,
    PaymentID INT , 
    MemberID INT,
    ItemID INT,
    Size NVARCHAR(10) NOT NULL CHECK (Size IN ('S', 'M', 'L', 'XL')),
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID),
    FOREIGN KEY (ItemID) REFERENCES Merch(ItemID) ON DELETE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
);


