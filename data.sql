---6/24
CREATE TABLE Locations 
(
  LocationID INT PRIMARY KEY,
  LocationCity NVARCHAR(30),
  LocationAdress NVARCHAR(100),
  PostalCode NVARCHAR(6) 
)
CREATE TABLE Classes 
(
  ClassesID INT PRIMARY KEY,
  ClassesName NVARCHAR(30),
  TrainerID INT,
  ClassLevel INT
)
CREATE TABLE Trainers 
(
  TrainerID INT PRIMARY KEY,
  TrainerName NVARCHAR(30),
  TrainerSurname NVARCHAR(30),
  DateOfBirth DATA,
  DateOfEmployment DATA,
  Salary INT
)
CREATE TABLE Employees 
(
  EmployeeID INT PRIMARY KEY,
  EmployeeName NVARCHAR(30),
  EmployeeSurname NVARCHAR(30),
  EmployeePosition NVARCHAR(30),
  DateOfBirth DATA,
  DateOfEmployment DATA,
  Salary INT
)
CREATE TABLE Customers 
(
  CustomerID INT PRIMARY KEY,
  CustomerName NVARCHAR(30),
  CustomerSurname NVARCHAR(30),
  DateOfBirth DATA,
  BegininOfMembership DATA
)
CREATE TABLE Promotion 
(
  PromotionID INT PRIMARY KEY,
  PromotionName NVARCHAR(30),
  TypeOfPromotion NVARCHAR(1),
  PromotionValue INT 
)
