CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY,
    MemberID INT,
    IssueDate DATE,
    DueDate DATE,
    TotalAmount MONEY,
    Status ENUM('Paid', 'Unpaid', 'Pending')
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    MemberID INT,
    InvoiceID INT,
    AmountPaid MONEY,
    PaymentDate DATE,
    PaymentMethod ENUM('Credit Card', 'Cash', 'Bank Transfer'),
    DiscountCode NVARCHAR(20),
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID)
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    MemberName NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    JoinDate DATE,
    MembershipID INT
);

CREATE TABLE Memberships (
    MembershipID INT PRIMARY KEY,
    MembershipName NVARCHAR(100),
    PricePerMonth DECIMAL(10,2),
    DurationMonths INT
);

CREATE TABLE CompanyMembership (
    CompanyMembershipID INT PRIMARY KEY,
    CompanyName NVARCHAR(256),
    MembershipID INT,
    StartDate DATE,
    EndDate DATE
);

CREATE TABLE MembershipSuspensions (
    SuspensionID INT PRIMARY KEY,
    MemberID INT,
    StartDate DATE,
    EndDate DATE,
    Reason NVARCHAR(500)
);

CREATE TABLE MembershipCancelations (
    CancelationID INT PRIMARY KEY,
    MemberID INT,
    CancelationDate DATE,
    Reason NVARCHAR(500)
);
    
CREATE TABLE Leaderboard (
    MemberID INT,
    ClassID INT,
    TotalTrainings INT,
    TotalHours DECIMAL(10,2),
    Rank INT
);
    
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
);
    
CREATE TABLE ClassReviews (
    ClassReviewID INT PRIMARY KEY,
    MemberID INT,
    ClassID INT,
    Rating INT,
    DifficultyLevel INT,
    ReviewDate DATE,
    Comment NVARCHAR(255)
);

CREATE TABLE ClassTypes (
    ClassID INT,
    TrainerID INT
);
    
CREATE TABLE ClassTypes (
    ClassID INT PRIMARY KEY,
    ClassName NVARCHAR(100),
    ClassLevel INT
);
    
CREATE TABLE ClassEnrollments (
    EnrollmentID INT PRIMARY KEY,
    MemberID INT,
    ClassID INT,
    Status ENUM('Active', 'Completed', 'Dropped')
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
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID)
);

CREATE TABLE Waitlist (
    WaitListID INT PRIMARY KEY,
    QueueNumber INT,
    EnrollmentID INT,
    Status ENUM('Waiting', 'Confirmed', 'Cancelled'),
    FOREIGN KEY (EnrollmentID) REFERENCES ClassEnrollments(EnrollmentID)
);
    
CREATE TABLE PersonalTrainings (
    TrainingID INT PRIMARY KEY,
    TrainerID INT,
    MemberID INT,
    Date DATE,
    DurationHours NVARCHAR(80),
    PaymentID INT,
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID),
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID)
);
    
CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY,
    Name NVARCHAR(100),
    FitnessClubID INT,
    LastMaintenance DATE,
    PurchaseDate DATE,
    Status ENUM('Operational', 'Maintenance Required', 'Out of Service')
);
    
CREATE TABLE FitnessClubs (
    FitnessClubID INT PRIMARY KEY,
    City NVARCHAR(100)
);
    
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    Phone NVARCHAR(12),
    Email NVARCHAR(100),
    FitnessClubID INT,
    Position NVARCHAR(100)
);
    
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
    FOREIGN KEY (ItemID) REFERENCES Merch(ItemID)
);
    
CREATE TABLE PromotionCodes (
    CodeID INT PRIMARY KEY,
    DiscountCode NVARCHAR(20),
    DiscountPercentage INT,
    Status ENUM('Active', 'Inactive')
);

CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY,
    EnrollmentID INT,
    MemberID INT,
    ClassID INT,
    AttendanceDate DATE,
    Status ENUM('Present', 'Absent', 'Excused')
);
