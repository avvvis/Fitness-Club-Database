
--Club related tabels

CREATE TABLE FitnessClubs (
    FitnessClubID INT PRIMARY KEY,
    Address NVARCHAR(100)
);
CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY,
    Name NVARCHAR(100),
    FitnessClubID INT,
    LastMaintenance DATE,
    PurchaseDate DATE,
    Status ENUM('Operational', 'Maintenance Required', 'Out of Service')
    FOREIGN KEY (FitnessClubID) REFERENCES FitnessClubs(FitnessClubID)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
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


CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    MemberName NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    JoinDate DATE,
    MembershipID INT
    FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID)
);

CREATE TABLE CompanyMembership (
    CompanyMembershipID INT PRIMARY KEY,
    CompanyName NVARCHAR(256),
    MembershipID INT,
    StartDate DATE,
    EndDate DATE
    FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID)
);

CREATE TABLE MembershipSuspensions (
    SuspensionID INT PRIMARY KEY,
    MemberID INT,
    StartDate DATE,
    EndDate DATE,
    Reason NVARCHAR(500)
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE MembershipCancelations (
    CancelationID INT PRIMARY KEY,
    MemberID INT,
    CancelationDate DATE,
    Reason NVARCHAR(500),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
    

--Payment related tables

CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY,
    MemberID INT,
    IssueDate DATE,
    DueDate DATE,
    TotalAmount MONEY,
    Status ENUM('Paid', 'Unpaid', 'Pending')
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)

);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    MemberID INT,
    InvoiceID INT,
    AmountPaid MONEY,
    PaymentDate DATE,
    PaymentMethod ENUM('Credit Card', 'Cash', 'Bank Transfer'),
    DiscountCodeID INT,
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
);

CREATE TABLE DiscountCodes (
    CodeID INT PRIMARY KEY,
    DiscountCode NVARCHAR(20),
    DiscountPercentage INT,
    Status ENUM('Active', 'Inactive')
);

--Trainer related tables
    
CREATE TABLE Trainers (
    TrainerID INT PRIMARY KEY,
    TrainerName NVARCHAR(100),
    Specialization NVARCHAR(100),
    Phone NVARCHAR(20),
    Email NVARCHAR(100) UNIQUE
);

CREATE TABLE TrainerReviews (
    TrainerReviewID INT PRIMARY KEY,
    MemberID INT,
    TrainerID INT,
    Rating INT,
    Comment NVARCHAR(255),
    ReviewDate DATE
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID)
);
  
CREATE TABLE PersonalTrainings (
    TrainingID INT PRIMARY KEY,
    TrainerID INT,
    MemberID INT,
    TrainingDate DATE,
    DurationHours NVARCHAR(80),
    PaymentID INT,
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID),
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);


--Class related tables

CREATE TABLE Classes (
    ClassID INT PRIMARY KEY,
    ClassName NVARCHAR(100),
    ClassLevel INT
);

CREATE TABLE ClassReviews (
    ClassReviewID INT PRIMARY KEY,
    MemberID INT,
    ClassID INT,
    Rating INT,
    DifficultyLevel INT,
    ReviewDate DATE,
    Comment NVARCHAR(255)
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (ClassID) REFERENCES Classes (ClassID)
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
    Status ENUM('Active', 'Completed', 'Dropped'),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);
    
CREATE TABLE ClassSchedules (
    ScheduleID INT PRIMARY KEY,
    ClassID INT,
    TrainerID INT,
    Room INT,
    Day NVARCHAR(20),
    StartTime DATETIME,
    EndTime DATETIME,
    FitnessClubID INT,
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (FitnessClubID) REFERENCES FitnessClubs(FitnessClubID)
);

CREATE TABLE Waitlists (
    WaitListID INT PRIMARY KEY,
    QueueNumber INT,
    EnrollmentID INT,
    Status ENUM('Waiting', 'Confirmed', 'Cancelled'),
    FOREIGN KEY (EnrollmentID) REFERENCES ClassEnrollments(EnrollmentID)
);

CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY,
    EnrollmentID INT,
    MemberID INT,
    ClassID INT,
    AttendanceDate DATE,
    Status ENUM('Present', 'Absent', 'Excused')
    FOREIGN KEY (EnrollmentID) REFERENCES ClassEnrollments(EnrollmentID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);

CREATE TABLE Leaderboard (
    MemberID INT,
    ClassID INT,
    TotalTrainings INT,
    TotalHours DECIMAL(10,2),
    Rank INT,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);

--Additional tables
CREATE TABLE Merch (
    ItemID INT PRIMARY KEY,
    ItemName NVARCHAR(50),
    ItemPrice MONEY
);

CREATE TABLE MerchOrders (
    OrderID INT PRIMARY KEY,
    PaymentID INT,
    MemberID INT,
    ItemID INT,
    Size ENUM('S', 'M', 'L', 'XL'),
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID),
    FOREIGN KEY (ItemID) REFERENCES Merch(ItemID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
    

