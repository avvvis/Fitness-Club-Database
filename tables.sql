
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
    Position NVARCHAR(100),
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
    MembershipID INT,
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

CREATE TABLE ClassTrainers (
    ClassID INT,
    TrainerID INT,
    CONSTRAINT PK_ClassTypes PRIMARY KEY (ClassID, TrainerID),
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

--INSERT STATEMENTS -------------------------------

--------------------------------------------
-- 1. Club related INSERTS
--------------------------------------------
INSERT INTO FitnessClubs (FitnessClubID, Address) VALUES
  (1, 'ul. Główna 1, Warszawa'),
  (2, 'ul. Piękna 2, Kraków'),
  (3, 'ul. Sportowa 3, Poznań');

INSERT INTO Employees (EmployeeID, EmployeeName, Phone, Email, FitnessClubID, Position) VALUES
  (1,  'Adam Nowak',             '600-001-001', 'adam.nowak@example.com',             1, 'Manager'),
  (2,  'Ewa Kowalska',           '600-001-002', 'ewa.kowalska@example.com',           1, 'Trainer'),
  (3,  'Piotr Wiśniewski',       '600-001-003', 'piotr.wisniewski@example.com',       1, 'Receptionist'),
  (4,  'Anna Zielińska',         '600-001-004', 'anna.zielinska@example.com',         1, 'Cleaner'),
  (5,  'Krzysztof Kamiński',     '600-001-005', 'krzysztof.kaminski@example.com',     1, 'Trainer'),
  (6,  'Magdalena Lewandowska',  '600-002-001', 'magdalena.lewandowska@example.com',  2, 'Manager'),
  (7,  'Michał Wójcik',          '600-002-002', 'michal.wojcik@example.com',          2, 'Trainer'),
  (8,  'Karolina Nowicka',       '600-002-003', 'karolina.nowicka@example.com',       2, 'Receptionist'),
  (9,  'Tomasz Kamiński',        '600-002-004', 'tomasz.kaminski@example.com',        2, 'Cleaner'),
  (10, 'Joanna Szymańska',       '600-002-005', 'joanna.szymanska@example.com',       2, 'Trainer'),
  (11, 'Marcin Dąbrowski',       '600-003-001', 'marcin.dabrowski@example.com',       3, 'Manager'),
  (12, 'Agnieszka Kwiatkowska',  '600-003-002', 'agnieszka.kwiatkowska@example.com',  3, 'Trainer'),
  (13, 'Łukasz Nowakowski',      '600-003-003', 'lukasz.nowakowski@example.com',      3, 'Receptionist'),
  (14, 'Monika Woźniak',         '600-003-004', 'monika.wozniak@example.com',         3, 'Cleaner'),
  (15, 'Robert Jabłoński',       '600-003-005', 'robert.jablonski@example.com',       3, 'Trainer');

INSERT INTO Equipment (EquipmentID, Name, FitnessClubID, LastMaintenance, PurchaseDate, Status)
VALUES
  (1, 'Treadmill',         1, '2023-12-01', '2023-01-01', 'Operational'),
  (2, 'Elliptical',        2, '2023-12-05', '2023-02-01', 'Maintenance Required'),
  (3, 'Stationary Bike',   3, '2023-12-10', '2023-03-01', 'Operational'),
  (4, 'Rowing Machine',    1, '2023-12-15', '2023-04-01', 'Out of Service'),
  (5, 'Dumbbells',         2, '2023-12-20', '2023-05-01', 'Operational');

--------------------------------------------
-- 2. Member related INSERTS
--------------------------------------------

INSERT INTO Memberships (MembershipID, MembershipName, PricePerMonth, DurationMonths) VALUES
  (1, 'Basic',     29.99, 1),
  (2, 'Standard',  49.99, 3),
  (3, 'Premium',   69.99, 6),
  (4, 'Corporate', 99.99, 12);

INSERT INTO Memberships (MembershipID, MembershipName, PricePerMonth, DurationMonths) VALUES
  (5, 'Single-Entry', 10.99, 0);

INSERT INTO Members (MemberID, MembershipType, MembershipID, JoinDate) VALUES
  (1,  'Individual', 1, '2023-01-10'),
  (2,  'Individual', 2, '2023-01-15'),
  (3,  'Individual', 3, '2023-01-20'),
  (4,  'Individual', 1, '2023-01-25'),
  (5,  'Individual', 2, '2023-02-01'),
  (6,  'Individual', 3, '2023-02-05'),
  (7,  'Individual', 1, '2023-02-10'),
  (8,  'Individual', 2, '2023-02-15'),
  (9,  'Individual', 3, '2023-02-20'),
  (10, 'Individual', 1, '2023-02-25'),
  (11, 'Individual', 2, '2023-03-01'),
  (12, 'Individual', 3, '2023-03-05'),
  (13, 'Individual', 1, '2023-03-10'),
  (14, 'Individual', 2, '2023-03-15'),
  (15, 'Individual', 3, '2023-03-20'),
  (16, 'Individual', 1, '2023-03-25'),
  (17, 'Individual', 2, '2023-03-30');

INSERT INTO Members (MemberID, MembershipType, MembershipID, JoinDate) VALUES
  (18, 'Company', 4, '2023-01-05'),
  (19, 'Company', 4, '2023-01-10'),
  (20, 'Company', 4, '2023-01-15');

INSERT INTO IndividualMemberships (MemberID, MemberName, Email, Phone, MembershipID) VALUES
  (1,  'Jan Kowalski',          'jan.kowalski@example.com',          '600-0001', 1),
  (2,  'Anna Nowak',            'anna.nowak@example.com',            '600-0002', 2),
  (3,  'Piotr Wiśniewski',      'piotr.wisniewski@example.com',      '600-0003', 3),
  (4,  'Katarzyna Zielińska',   'katarzyna.zielinska@example.com',   '600-0004', 1),
  (5,  'Marek Lewandowski',     'marek.lewandowski@example.com',     '600-0005', 2),
  (6,  'Joanna Kamińska',       'joanna.kaminska@example.com',       '600-0006', 3),
  (7,  'Andrzej Wójcik',        'andrzej.wojcik@example.com',        '600-0007', 1),
  (8,  'Ewa Maj',               'ewa.maj@example.com',               '600-0008', 2),
  (9,  'Tomasz Piotrowski',     'tomasz.piotrowski@example.com',     '600-0009', 3),
  (10, 'Monika Szymańska',      'monika.szymanska@example.com',      '600-0010', 1),
  (11, 'Michał Kamiński',       'michal.kaminski@example.com',       '600-0011', 2),
  (12, 'Olga Nowicka',          'olga.nowicka@example.com',          '600-0012', 3),
  (13, 'Robert Kwiatkowski',    'robert.kwiatkowski@example.com',    '600-0013', 1),
  (14, 'Dorota Kowalska',       'dorota.kowalska@example.com',       '600-0014', 2),
  (15, 'Paweł Lewandowski',     'pawel.lewandowski@example.com',     '600-0015', 3),
  (16, 'Magdalena Nowak',       'magdalena.nowak@example.com',       '600-0016', 1),
  (17, 'Grzegorz Ostrowski',    'grzegorz.ostrowski@example.com',    '600-0017', 2);

INSERT INTO CompanyMemberships (MemberID, CompanyName) VALUES
  (18, 'Alfa'),
  (19, 'Sigma'),
  (20, 'Gamma');

--------------------------------------------
-- 3. Trainer & Payment related INSERTS
--------------------------------------------
INSERT INTO Trainers (TrainerID, TrainerName, Specialization, Phone, Email) VALUES
  (1, 'Ewa Kowalska',          'Yoga',             '600-001-002', 'ewa.kowalska@example.com'),
  (2, 'Krzysztof Kamiński',    'Boxing',           '600-001-005', 'krzysztof.kaminski@example.com'),
  (3, 'Michał Wójcik',         'Pilates',          '600-002-002', 'michal.wojcik@example.com'),
  (4, 'Joanna Szymańska',      'CrossFit',         '600-002-005', 'joanna.szymanska@example.com'),
  (5, 'Agnieszka Kwiatkowska', 'Strength Training','600-003-002', 'agnieszka.kwiatkowska@example.com'),
  (6, 'Robert Jabłoński',      'HIIT',             '600-003-005', 'robert.jablonski@example.com');

INSERT INTO Invoices (InvoiceID, MemberID, IssueDate, DueDate, TotalAmount, Status)
VALUES
  (1, 1, '2023-10-01', '2023-10-15', 29.99, 'Paid'),
  (2, 2, '2023-10-02', '2023-10-16', 49.99, 'Unpaid'),
  (3, 3, '2023-10-03', '2023-10-17', 69.99, 'Pending');

INSERT INTO DiscountCodes (CodeID, DiscountCode, DiscountPercentage, Status)
VALUES
  (1, 'SAVE10', 10, 'Active'),
  (2, 'OFF20',  20, 'Active'),
  (3, 'DEAL15', 15, 'Inactive');

INSERT INTO Payments (PaymentID, MemberID, InvoiceID, AmountPaid, PaymentDate, DiscountCodeID)
VALUES
  (1, 1, 1, 29.99, '2023-10-05', 1),
  (2, 2, 2, 49.99, '2023-10-06', 2),
  (3, 3, 3, 69.99, '2023-10-07', 3);

INSERT INTO PersonalTrainings (TrainingID, TrainerID, MemberID, TrainingDate, DurationHours, PaymentID)
VALUES
  (1, 1, 1, '2023-10-20', 1.0, 1),
  (2, 2, 2, '2023-10-21', 1.5, 2),
  (3, 3, 3, '2023-10-22', 2.0, 3);

--------------------------------------------
-- 4. Class related INSERTS
--------------------------------------------
INSERT INTO Classes (ClassID, ClassName, ClassLevel) VALUES
  (1,  'Yoga Basics',         1),
  (2,  'Advanced Yoga',       2),
  (3,  'Boxing Fundamentals', 3),
  (4,  'Kickboxing',          3),
  (5,  'Pilates',             2),
  (6,  'Zumba',               1),
  (7,  'CrossFit',            4),
  (8,  'Spinning',            3),
  (9,  'HIIT',                4),
  (10, 'Strength Training',   5);

INSERT INTO ClassTrainers (ClassID, TrainerID) VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5),
  (6, 6),
  (7, 1),
  (8, 2),
  (9, 3),
  (10, 4);

INSERT INTO ClassEnrollments (EnrollmentID, MemberID, ClassID, Status) VALUES
  (1, 1, 1, 'Active'),
  (2, 2, 2, 'Active'),
  (3, 3, 3, 'Completed'),
  (4, 4, 4, 'Dropped'),
  (5, 5, 5, 'Active'),
  (6, 6, 6, 'Completed'),
  (7, 7, 7, 'Active'),
  (8, 8, 8, 'Dropped');

INSERT INTO ClassSchedules (ScheduleID, ClassID, TrainerID, Room, Day, StartTime, EndTime, FitnessClubID) VALUES
  (1,  1, 1, 1, 'Monday',    '08:00', '09:00', 1),
  (2,  2, 2, 1, 'Tuesday',   '09:15', '10:15', 1),
  (3,  3, 3, 1, 'Wednesday', '10:30', '11:30', 1),
  (4,  4, 4, 1, 'Thursday',  '11:45', '12:45', 1),
  (5,  5, 5, 1, 'Friday',    '13:00', '14:00', 1),
  (6,  6, 1, 1, 'Saturday',  '14:15', '15:15', 1),
  (7,  7, 2, 1, 'Sunday',    '15:30', '16:30', 1),
  (8,  8, 3, 1, 'Monday',    '16:45', '17:45', 1),
  (9,  9, 4, 1, 'Tuesday',   '18:00', '19:00', 1),
  (10, 10, 5, 1, 'Wednesday', '19:15', '20:15', 1);

INSERT INTO ClassSchedules (ScheduleID, ClassID, TrainerID, Room, Day, StartTime, EndTime, FitnessClubID) VALUES
  (11, 1, 1, 1, 'Monday',    '10:00', '11:00', 2),
  (12, 2, 2, 1, 'Tuesday',   '11:15', '12:15', 2),
  (13, 3, 3, 1, 'Wednesday', '12:30', '13:30', 2),
  (14, 4, 4, 1, 'Thursday',  '13:45', '14:45', 2),
  (15, 5, 5, 1, 'Friday',    '15:00', '16:00', 2),
  (16, 6, 1, 1, 'Saturday',  '16:15', '17:15', 2),
  (17, 7, 2, 1, 'Sunday',    '17:30', '18:30', 2),
  (18, 8, 3, 1, 'Monday',    '18:45', '19:45', 2),
  (19, 9, 4, 1, 'Tuesday',   '20:00', '21:00', 2),
  (20, 10, 5, 1, 'Wednesday', '21:15', '22:15', 2);

INSERT INTO ClassSchedules (ScheduleID, ClassID, TrainerID, Room, Day, StartTime, EndTime, FitnessClubID) VALUES
  (21, 1, 1, 2, 'Monday',    '07:00', '08:00', 3),
  (22, 2, 2, 2, 'Tuesday',   '08:15', '09:15', 3),
  (23, 3, 3, 2, 'Wednesday', '09:30', '10:30', 3),
  (24, 4, 4, 2, 'Thursday',  '10:45', '11:45', 3),
  (25, 5, 5, 2, 'Friday',    '12:00', '13:00', 3),
  (26, 6, 1, 2, 'Saturday',  '13:15', '14:15', 3),
  (27, 7, 2, 3, 'Sunday',    '14:30', '15:30', 3),
  (28, 8, 3, 3, 'Monday',    '15:45', '16:45', 3),
  (29, 9, 4, 3, 'Tuesday',   '17:00', '18:00', 3),
  (30, 10, 5, 3, 'Wednesday', '18:15', '19:15', 3);

INSERT INTO Waitlists (WaitListID, QueueNumber, EnrollmentID, Status) VALUES
  (1, 1, 1, 'Waiting'),
  (2, 2, 2, 'Confirmed'),
  (3, 3, 3, 'Cancelled'),
  (4, 4, 4, 'Waiting'),
  (5, 5, 5, 'Confirmed');

INSERT INTO Attendance (AttendanceID, EnrollmentID, MemberID, ClassID, AttendanceDate, Status) VALUES
  (1, 1, 1, 1, '2023-10-10', 'Present'),
  (2, 2, 2, 2, '2023-10-11', 'Absent'),
  (3, 3, 3, 3, '2023-10-12', 'Excused'),
  (4, 4, 4, 4, '2023-10-13', 'Present'),
  (5, 5, 5, 5, '2023-10-14', 'Present');

INSERT INTO Leaderboard (MemberID, ClassID, TotalTrainings, TotalHours, Rank) VALUES
  (1, 1, 10, 10.00, 1),
  (2, 1, 8,  8.50,  2),
  (3, 2, 7,  7.00,  1),
  (4, 2, 5,  5.50,  2),
  (5, 3, 12, 12.00, 1);

--------------------------------------------
-- 5. Reviews related INSERTS
--------------------------------------------
INSERT INTO Reviews (ReviewID, MemberID, Rating, ReviewDate, Comment) VALUES
  (1, 1, 5, '2023-09-25', 'Great trainer!'),
  (2, 2, 4, '2023-09-26', 'Very professional'),
  (3, 3, 5, '2023-09-27', 'Outstanding session'),
  (4, 4, 3, '2023-09-28', 'Decent, but room for improvement'),
  (5, 5, 4, '2023-09-29', 'Enjoyed the class'),
  (6, 6, 2, '2023-09-30', 'Too difficult'),
  (7, 7, 5, '2023-10-01', 'Excellent class'),
  (8, 8, 3, '2023-10-02', 'Good, but expected more');

INSERT INTO TrainerReviews (ReviewID, TrainerID) VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4);

INSERT INTO ClassesReviews (ReviewID, ClassID, DifficultyLevel) VALUES
  (5, 1, 3),
  (6, 2, 2),
  (7, 3, 5),
  (8, 4, 4);

--------------------------------------------
-- 6. Additional INSERTS (Merch)
--------------------------------------------
INSERT INTO Merch (ItemID, ItemName, ItemPrice) VALUES
  (1, 'T-Shirt',      19.99),
  (2, 'Water Bottle',  9.99),
  (3, 'Gym Bag',      29.99),
  (4, 'Cap',          14.99),
  (5, 'Shorts',       24.99),
  (6, 'Socks',         4.99),
  (7, 'Jacket',       39.99),
  (8, 'Headband',      7.99);

INSERT INTO MerchOrders (OrderID, PaymentID, MemberID, ItemID, Size) VALUES
  (1, 1, 1, 1, 'M'),
  (2, 2, 2, 2, 'L'),
  (3, 3, 3, 3, 'S'),
  (4, 1, 4, 4, 'XL'),
  (5, 2, 5, 5, 'M');
