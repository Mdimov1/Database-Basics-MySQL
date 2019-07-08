/*=========1. Create Database==================*/

CREATE DATABASE `Minions`;


/*=========2. Create Tables====================*/

CREATE TABLE `Minions`(
`Id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`Name` VARCHAR(30) NOT NULL,
`Age` INT
);

CREATE TABLE `Towns`(
`Id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`Name` VARCHAR(30) NOT NULL
);


/*=======3. Alter Minions Table==================*/

ALTER TABLE `Minions`
ADD COLUMN `Town_id` INT NOT NULL;

ALTER TABLE `Minions`
ADD CONSTRAINT FK_minions_towns 
FOREIGN KEY (`Town_id`) REFERENCES `Towns`(`id`);


/*=======4. Insert Records in Both Tables=========*/

INSERT INTO `Towns` (Name) VALUES ('Sofia');
INSERT INTO `Towns` (Name) VALUES ('Plovdiv');
INSERT INTO `Towns` (Name) VALUES ('Varna');

INSERT INTO `Minions`(Name, Age, Town_id) VALUES ('Kevin', 22, 1);
INSERT INTO `Minions`(Name, Age, Town_id) VALUES ('Bob', 15, 4);
INSERT INTO `Minions`(Name, Age, Town_id) VALUES ('Steward', NULL, 2);


/*=======5. Truncate Table Minions================*/
TRUNCATE TABLE `Minions`;


/*=======6. Drop All Tables=======================*/
DROP TABLE `Minions`;
DROP TABLE `Towns`;


/*=======7. Create Table People===================*/

CREATE TABLE `People` 
(
	`Id` INT PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`Name` NVARCHAR(200) NOT NULL,
    `Picture` VARBINARY(2000),
    `Height` FLOAT(2),
    `Weight` FLOAT(2),
    `Gender` CHAR NOT NULL CHECK (`Gender` = 'm' OR `Gender` = 'f'),
    `Birthdate` DATETIME NOT NULL,
    `Biography` NVARCHAR(255)
);

ALTER TABLE `People`
ADD PRIMARY KEY(Id);

INSERT INTO `People`(`Name`, `Gender`, `Birthdate`) 
VALUES ('Martin', 'm', '1995-02-01'),
('Bob', 'm', '1990-03-01'),
('Maria', 'f', '2000-02-08'),
('Stefi', 'f', '1996-05-01'),
('Misha', 'm', '1940-02-01');


/*=======8. Create Table Users===================*/

CREATE TABLE `Users`(
	`Id` INT PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
    `Username` CHAR(30) UNIQUE NOT NULL,
    `Password` CHAR(26) NOT NULL,
    `Profile_Picture` VARBINARY(900),
    `Last_Login_Time` TIMESTAMP,
    `Is_Deleted` NVARCHAR(5) NOT NULL CHECK(Is_Deleted = 'true' OR Is_Deleted = 'false')
);

ALTER TABLE `Users`
ADD PRIMARY KEY(Id);

INSERT INTO `Users`(`Username`, `Password`, `Profile_Picture`, `Is_Deleted`)
VALUES ('Mpetrov','12345',NULL, 'false'),
('MDimo', '12345', NULL, 'true'),
('Ivaan', '1236', NULL, 'false'),
('Gosho', '1345', NULL, 'true'),
('Mariika', '12375', NULL, 'false');


/*=======9. Change Primary Key=========================*/

ALTER TABLE `Users`
DROP PRIMARY KEY;

ALTER TABLE `Users`
ADD CONSTRAINT PK_Users PRIMARY KEY (`Id`, `Username`);


/*=======10. Set Default Value of a Field==============*/

ALTER TABLE `Users` 
	MODIFY COLUMN `Last_Login_Time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
 
 
 /*=======11. Set Unique Field==========================*/

ALTER TABLE `Users`
	DROP PRIMARY KEY,
	ADD CONSTRAINT PRIMARY KEY (`Id`),
	ADD CONSTRAINT UNIQUE (`Username`);


/*=======12. Movies Database===========================*/

CREATE DATABASE `Movies`;

CREATE TABLE `Directors`(
	`Id` INT PRIMARY KEY NOT NULL,
    `Director_Name` VARCHAR(50) NOT NULL,
    `Notes` NVARCHAR(255)
);

INSERT INTO `Directors`(`Id`, `Director_Name`) 
VALUES
(1, 'Director One'),
(2, 'Director Two'),
(3, 'Director Three'),
(4, 'Director Four'),
(5, 'Director Five');

CREATE TABLE `Genres`(
	`Id` INT PRIMARY KEY NOT NULL,
    `Genre_Name` VARCHAR(50) NOT NULL,
    `Notes` NVARCHAR(255)
);

INSERT INTO `Genres`(`Id`, `Genre_Name`)
VALUES
(1, 'Genre One'),
(2, 'Genre Two'),
(3, 'Genre Three'),
(4, 'Genre Four'),
(5, 'Genre Five');

CREATE TABLE `Categories`(
	`Id` INT PRIMARY KEY NOT NULL,
    `Category_Name` NVARCHAR(50) NOT NULL,
    `Notes` NVARCHAR(255)
);

INSERT INTO `Categories`(`Id`, `Category_Name`)
VALUES
(1, 'Category One'),
(2, 'Category Two'),
(3, 'Category Three'),
(4, 'Category Four'),
(5, 'Category Five');

CREATE TABLE `Movies`(
	`Id` INT PRIMARY KEY NOT NULL,
    `Title` NVARCHAR(255) NOT NULL,
    `Director_Id` INT FOREIGN KEY REFERENCES `Directors`(Id),
    `Copyright_Year` INT,
    `Length` NVARCHAR(50),
    `Genre_Id` INT FOREIGN KEY REFERENCES `Genres`(Id),
    `Category_Id` INT FOREIGN KEY REFERENCES `Categories`(Id)
    `Rating` INT,
    `Notes` NVARCHAR(255)
);
INSERT INTO `Movies`(`Id`, `Title`, `Director_Id`, `Genre_Id`, `Category_Id`)
VALUES
(1, 'Title One', 2, 3, 4),
(2, 'Title Two', 3, 4, 5),
(3, 'Title Three', 1, 2, 3),
(4, 'Title Four', 4, 5, 6),
(5, 'Title Five', 7, 8, 9);


/*=======13. Car Rental Database=======================*/

CREATE DATABASE `Car_Rental`;

CREATE TABLE `Categories`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Category NVARCHAR(50) NOT NULL,
	Daily_Rate INT NULL,
    Weekly_Rate INT NULL,
    Monthly_Rate INT NULL,
    Weekend_Rate INT NULL
);

INSERT INTO `Categories`(Category, Daily_Rate, Weekly_Rate, Monthly_Rate, Weekend_Rate)
VALUES
('First Category', 2, 3, 4, 5),
('First Category', 3, 4, 5, 6),
('First Category', 4, 5, 6, 7);

CREATE TABLE `Cars`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Plate_Number INT UNIQUE NOT NULL,
    Make NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    Car_Year INT NOT NULL,
    Category_Id INT NOT NULL,
    Doors INT NOT NULL,
    Picture BLOB NULL,
    Car_Condition NVARCHAR(50) NULL,
	Available INT NULL
    );
    
INSERT INTO `Cars`(Plate_Number, Make, Model, Car_Year, Category_Id, Doors, Picture, Car_Condition, Available)
VALUES
('AB2050BE', 'AUDI', 'A7', 1997, 2, 2, NULL, NULL, NULL),
('XC4662BT', 'SEAT', 'LEON', 2005, 3, 4, NULL, NULL, NULL),
('BA0907EH', 'BMW', 'M5', 2007, 1, 2, NULL, NULL, NULL);

CREATE TABLE `Employees`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    First_Name NVARCHAR(50) NOT NULL,
    Last_Name NVARCHAR(50) NOT NULL,
    Title NVARCHAR(50) NULL,
    Note NVARCHAR(255) NULL
);

INSERT INTO `Employees`(First_Name, Last_Name, Title, Note)
VALUES
('Milen', 'Tsvetkov', NULL, NULL),
('Grigor', 'Ivanov', NULL, NULL),
('Marta', 'Dimitrova', NULL, NULL);

CREATE TABLE `Customers`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Driver_License_Number NVARCHAR(50) UNIQUE NOT NULL,
    Full_Name NVARCHAR(100) NOT NULL,
    Adress NVARCHAR(100) NULL,
    City NVARCHAR(50) NULL,
    Zip_Code NVARCHAR(50) NULL,
    Notes NVARCHAR(255) NULL
);

INSERT INTO `Customers`(Driver_License_Number, Full_Name, Adress, City, Zip_Code, Notes)
VALUES 
('DA2D1D41DA2122', 'Name One', 'Adress One', NULL, NULL, NULL),
('HJDGHE43332122', 'Name Two', 'Adress Two', NULL, NULL, NULL),
('HGD41DA2777777', 'Name Three', 'Adress Three', NULL, NULL, NULL);

CREATE TABLE `Rental_Order`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
    Employee_Id INT UNIQUE NOT NULL, 
    Customer_Id INT UNIQUE NOT NULL, 
    Car_Id INT UNIQUE NOT NULL, 
    Car_Condition INT NULL, 
    Tank_Level INT NOT NULL,
	Kilometrage_Start INT NOT NULL, 
    Kilometrage_End INT NOT NULL, 
    Total_Kilometrage BIGINT NOT NULL, 
    Start_Date DATE NOT NULL, 
    End_Date DATE NOT NULL,
	Total_Days INT NULL, 
    Rate_Applied INT NULL, 
    Tax_Rate INT NULL, 
    Order_Status NVARCHAR(50) NULL, 
    Notes NVARCHAR(255) NULL
);

INSERT INTO `Rental_Order`(Employee_Id, Customer_Id, Car_Id, Car_Condition, Tank_Level, 
Kilometrage_Start, Kilometrage_End, Total_Kilometrage, Start_Date, End_Date, Total_Days, 
Rate_Applied, Tax_Rate, Order_Status, Notes)
VALUES 
(20, 11, 30, 10, 600, 120000, 130000, 10000, '2019-01-01', '2019-01-11', 10, NULL, NULL, NULL, NULL),
(70, 12, 21, 30, 100, 120000, 130000, 10000, '2019-03-01', '2019-03-11', 10, NULL, NULL, NULL, NULL),
(22, 13, 50, 60, 260, 120000, 130000, 10000, '2019-04-01', '2019-04-11', 10, NULL, NULL, NULL, NULL);


/*=======14. Hotel Database============================*/

CREATE DATABASE `Hotel`;

CREATE TABLE `Employees`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    First_Name NVARCHAR(50) NOT NULL, 
    Last_Name NVARCHAR(50) NOT NULL, 
    Title NVARCHAR(100) NULL, 
    Notes NVARCHAR(255) NULL
);

INSERT INTO `Employees`(First_Name, Last_Name, Title, Notes)
VALUES 
('Petar', 'Ivanov', 'Manager', NULL),
('Ivancho', 'Ivanov', 'Director', NULL),
('Petko', 'Tonov', 'Employee', NULL);

CREATE TABLE `Customers`(
	Account_Number INT UNIQUE AUTO_INCREMENT, 
    First_Name NVARCHAR(50) NOT NULL, 
    Last_Name NVARCHAR(50) NOT NULL, 
    Phone_Number NVARCHAR(50) NOT NULL, 
    Emergency_Name NVARCHAR(50) NULL,
	Emergency_Number NVARCHAR(50) NULL, 
    Notes NVARCHAR(255) NULL
);

INSERT INTO `Customers`(Account_Number, First_Name, Last_Name, Phone_Number, Emergency_Name, 
Emergency_Number, Notes)
VALUES
(232322423, 'Dani', 'Ivanov', 08989333333, NULL, NULL, NULL),
(232543422, 'Daniela', 'Petrova', 0898955555, NULL, NULL, NULL),
(232323411, 'Preslava', 'Petrova', 0898944444, NULL, NULL, NULL);

CREATE TABLE `Room_Status`(
	Room_Status NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(255) NULL
);
INSERT INTO `Room_Status`(Room_Status, Notes)
VALUES
('free', null),
('busy', null),
('wait', null);

CREATE TABLE `Room_Types`(
	Room_Type NVARCHAR(20) NOT NULL,
    Notes NVARCHAR(255) NULL
);

INSERT INTO `Room_Type`(Room_Type, Notes)
VALUES
('small', null),
('big', null),
('middle', null);

CREATE TABLE `Bed_Types`(
	Bed_Type NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(255) NULL
);

INSERT INTO `Bed_Types`(Bed_Type, Notes)
VALUES
('small', null),
('big', null),
('middle', null);

CREATE TABLE `Rooms`(
	Room_Number INT UNIQUE NOT NULL, 
    Room_Type NVARCHAR(10) NOT NULL, 
    Bed_Type NVARCHAR(20) NOT NULL, 
    Rate INT NOT NULL, 
    Room_Status NVARCHAR(20) NOT NULL, 
    Notes NVARCHAR(255) NULL
);

INSERT INTO `Rooms`(Room_Number, Room_Type, Bed_Type, Rate, Room_Status, Notes)
VALUES
(102, 'small', 'small', 12, 'free', null),
(103, 'big', 'big', 12, 'busy', null),
(104, 'middle', 'small', 12, 'free', null);

CREATE TABLE `Payment`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
    Employee_Id INT UNIQUE NOT NULL, 
    Payment_Date DATE NOT NULL, 
    Account_Number INT UNIQUE NOT NULL, 
    First_Date_Occupied DATE NOT NULL,
    Last_Date_Occupied DATE NOT NULL, 
    Total_Days INT NOT NULL, 
    Amount_Charged INT NOT NULL, 
    Tax_Rate INT NULL, 
    Tax_Amount INT NULL, 
    Payment_Total INT NULL,
	Notes NVARCHAR(255) NULL
);

INSERT INTO `Payment`(Employee_Id, Payment_Date, Account_Number, First_Date_Occupied, 
Last_Date_Occupied, Total_Days, Amount_Charged, Tax_Rate, Tax_Amount, Payment_Total, Notes)
VALUES
(3, '2008-03-12', 43545445, '2008-04-10', '2008-04-14', 4, 25, NULL, NULL, NULL, NULL),
(2, '2018-03-12', 43545345, '2018-03-10', '2018-03-14', 4, 45, NULL, NULL, NULL, NULL),
(1, '2018-03-12', 43545425, '2018-03-10', '2018-03-14', 4, 55, NULL, NULL, NULL, NULL);


CREATE TABLE `Occupancies`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
    Employee_Id INT UNIQUE NOT NULL, 
    Date_Occupied DATE NOT NULL, 
    Account_Number INT UNIQUE NOT NULL, 
    Room_Number INT NOT NULL, 
    Rate_Applied INT NULL,
	Phone_Charge INT NULL, 
    Notes NVARCHAR(255) NULL
);

INSERT INTO `Occupancies`(Employee_Id, Date_Occupied, Account_Number, 
Room_Number, Rate_Applied, Phone_Charge, Notes)
VALUES 
(2, '2009-05-05', 75534564, 102, NULL, NULL, NULL),
(1, '2009-04-05', 65645344, 101, NULL, NULL, NULL),
(3, '2009-03-05', 57433885, 100, NULL, NULL, NULL);


/*=======15. Create SoftUni Database===================*/

CREATE DATABASE `Soft_Uni`;
USE `Soft_Uni`;

CREATE TABLE `Towns`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Name NVARCHAR(50) NOT NULL,
	CONSTRAINT `Pk_Towns` PRIMARY KEY (`Id`)
); 

CREATE TABLE `Addresses`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Address_Text NVARCHAR(50) NOT NULL,
    Town_Id INT UNIQUE NOT NULL,
	CONSTRAINT `Pk_Addresses` PRIMARY KEY (`Id`),
	CONSTRAINT `Fk_Addresses_towns` FOREIGN KEY (`Town_Id`)
		REFERENCES `Towns` (`Id`)
);

CREATE TABLE `Departments`(
	Id 	INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Name NVARCHAR(50) NOT NULL,
	CONSTRAINT `Pk_Departments` PRIMARY KEY (`Id`)
);

CREATE TABLE `Employees`(
	Id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
    First_Name NVARCHAR(50) NOT NULL, 
    Middle_Name NVARCHAR(50) NULL, 
    Last_Name NVARCHAR(50) NOT NULL, 
    Job_Title NVARCHAR(50) NOT NULL, 
    Department_Id INT UNIQUE NOT NULL, 
    Hire_Date DATE,
	Salary INT NOT NULL, 
    Address_Id INT UNIQUE NOT NULL,
	CONSTRAINT `Pk_Employees` PRIMARY KEY (`Id`),
	CONSTRAINT `Fk_Employees_Departments` FOREIGN KEY (`Department_Id`)
		REFERENCES `Departments` (`Id`),
	CONSTRAINT `Fk_Employees_Addresses` FOREIGN KEY (`Address_Id`)
		REFERENCES `Addresses` (`Id`)
);


/*=======16. Basic Insert===============================/

INSERT INTO `Towns` (`Name`) 
	VALUES
		('Sofia'),
		('Plovdiv'),
		('Varna'),
		('Burgas');

INSERT INTO `Departments` (`Name`) 
	VALUES
		('Engineering'),
		('Sales'),
		('Marketing'),
		('Software Development'),
		('Quality Assurance');

INSERT INTO `Employees`
		(`First_Name`, `Middle_Name`, `Last_Name`, `Job_Title`, `Department_Id`, `Hire_Date`, `Salary`)
	VALUES
		('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
		('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
		('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
		('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
		('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);


/*=======17. Basic Select All Fields===================*/

SELECT * FROM `Towns`;
SELECT * FROM `Departments`;
SELECT * FROM `Employees`;


/*=======18. Basic Select All Fields and Order Them====*/

SELECT * FROM `Towns`
ORDER BY `Name`;
SELECT * FROM `Departments`
ORDER BY `Name`;
SELECT * FROM `Employees`
ORDER BY `Salary` DESC;


/*=======19. Basic Select Some Fields===================*/

SELECT `Name` FROM `Towns`
ORDER BY `Name`;
SELECT `Name` FROM `Departments`
ORDER BY `Name`;
SELECT `First_Name`, `Last_Name`, `Job_Title`, `Salary` FROM `Employees`
ORDER BY `Salary` DESC;


/*=======20. Increase Employees Salary===================*/

UPDATE `Employees` SET `Salary` = Employees.Salary * 1.10;
SELECT `Salary` FROM `Employees`;


/*=======21. Decrease Tax Rate==========================*/

USE `Hotel`;

UPDATE `Payments` AS P SET `Tax_Rate` = P.Tax_Rate - 0.03*P.Tax_Rate;
SELECT `Tax_Rate` FROM `Payments`;

/*=======22. Delete All Records==========================*/

USE `Hotel`;

TRUNCATE `Occupancies`;
