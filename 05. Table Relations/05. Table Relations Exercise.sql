USE `Soft-Uni`;

/* 1. One-To-One Relationship */

CREATE TABLE `Persons`(
	`Person_Id` INT UNSIGNED UNIQUE AUTO_INCREMENT NOT NULL,
    `First_Name` VARCHAR(30) NOT NULL,
    `Salary` DECIMAL(7, 2) NOT NULL,
    `Passport_Id` INT UNIQUE NOT NULL
);

CREATE TABLE `Passports`(
	`Passport_Id` INT UNSIGNED UNIQUE AUTO_INCREMENT PRIMARY KEY NOT NULL,
    `Passport_Number` VARCHAR(10) UNIQUE NOT NULL
)AUTO_INCREMENT = 101;

INSERT INTO 
`Persons` (`First_Name`, `Salary`, `Passport_Id`)
VALUES 
	('Roberto', 43300.00, 102),
	('Tom', 56100.00, 103),
	('Yana', 60200.00, 101);
    
INSERT INTO 
`Passports` (`Passport_Number`)
VALUES 
	('N34FG21B'),
	('K65LO4R7'),
	('ZE657QP2');

ALTER TABLE `Persons`
ADD CONSTRAINT `PK_Persons`
	PRIMARY KEY (`Person_Id`),
ADD CONSTRAINT `FK_Persons_Passports`
	FOREIGN KEY (`Passport_Id`) 
	REFERENCES `Passports` (`Passport_Id`);


/* 2. One-To-Many Relationship */

CREATE TABLE `Manufacturers`(
	`Manufacturer_Id` INT UNSIGNED UNIQUE AUTO_INCREMENT NOT NULL,
    `Name` VARCHAR(50) NOT NULL,
    `Established_On` DATE NOT NULL
);

CREATE TABLE `Models`(
	`Model_Id` INT UNSIGNED UNIQUE AUTO_INCREMENT NOT NULL,
    `Name` VARCHAR(20) NOT NULL,
    `Manufacturer_Id` INT NOT NULL
)AUTO_INCREMENT = 101;

ALTER TABLE `Manufacturers`
	ADD CONSTRAINT `PK_Manufacturers` 
	PRIMARY KEY (`Manufacturer_Id`);

ALTER TABLE `Models`
ADD CONSTRAINT `PK_Models`
	PRIMARY KEY (`Model_Id`),
ADD CONSTRAINT `FK_Models_Manufacturers`
	FOREIGN KEY (`Manufacturer_Id`)
    REFERENCES `Manufacturers` (`Manufacturer_Id`);
    
INSERT INTO `Manufacturers` (`Name`, `Established_On`)
VALUES 
	('BMW', '1916-03-01'),
	('Tesla', '2003-01-01'),
	('Lada', '1966-05-01');

INSERT 
INTO `Models` (`Name`, `Manufacturer_Id`)
VALUES
	('X1', 1),
	('i6', 1),
	('Model S', 2),
	('Model X', 2),
	('Model 3', 2),
	('Nova', 3);


/* 03. Many-To-Many Relationship */

CREATE TABLE `Students`(
	`Student_Id` INT UNSIGNED UNIQUE AUTO_INCREMENT NOT NULL,
	`Name` NVARCHAR(50) NOT NULL
); 

CREATE TABLE `Exams`(
	`Exam_Id` INT UNSIGNED UNIQUE AUTO_INCREMENT NOT NULL,
    `Name` NVARCHAR(50) UNIQUE NOT NULL
)AUTO_INCREMENT = 101;

CREATE TABLE `Students_Exams`(
	`Student_Id` INT UNSIGNED NOT NULL,
    `Exam_Id` INT UNSIGNED NOT NULL
);

ALTER TABLE `Students`
	ADD 
		CONSTRAINT `PK_Studenst`
		PRIMARY KEY (`Student_Id`);
	
ALTER TABLE `Exams`
	ADD 
		CONSTRAINT `PK_Exams`
        PRIMARY KEY (`Exam_Id`);
		
ALTER TABLE `Students_Exams`
	ADD 
		CONSTRAINT `PK_Students_Exams`
		PRIMARY KEY (`Student_Id`, `Exam_Id`),
	ADD 
		CONSTRAINT `FK_Students_Exams_Students`
		FOREIGN KEY (`Student_Id`)
		REFERENCES `Students` (`Student_Id`),
	ADD
		CONSTRAINT `FK_Students_Exams_Exams`
        FOREIGN KEY (`Exam_Id`)
        REFERENCES `Exams` (`Exam_Id`);
	
INSERT INTO `Students`(`Name`)
VALUES 
	('Mila'),
    ('Toni'),
    ('Ron');
    
INSERT INTO `Exams` (`Name`)
VALUES 
	('Spring MVC'),
	('Neo4j'),
	('Oracle 11g');

INSERT INTO `Students_Exams`
VALUES  
		(1, 101),
		(1, 102),
		(2, 101),
		(3, 103),
		(2, 102),
		(2, 103);


/* 4. Self-Referencing */

CREATE TABLE `Teachers`(
	`Teacher_Id` INT UNSIGNED UNIQUE AUTO_INCREMENT NOT NULL,
    `Name` VARCHAR(30) NOT NULL,
    `Manager_Id` INT UNSIGNED DEFAULT NULL
)AUTO_INCREMENT = 101;

INSERT INTO `Teachers` (`Name`, `Manager_Id`)
VALUES 
	('John', NULL),
    ('Maya', 106),
    ('Silvia', 106),
    ('Ted', 105),
    ('Mark', 101),
    ('Greta', 101);
    
ALTER TABLE `Teachers`
	ADD 
		CONSTRAINT `PK_Teachers`
		PRIMARY KEY (`Teacher_Id`),
    ADD 
		CONSTRAINT `FK_Manager_Id_Teacher_Id`
        FOREIGN KEY (`Manager_Id`)
        REFERENCES `Teachers` (`Teacher_Id`);
	
    
    
/* 5. Online Store Database */

CREATE DATABASE `Online-Store`;
USE  `Online-Store`;

CREATE TABLE `Item_Types`(
	`Item_Type_Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(50) NOT NULL
);

CREATE TABLE `Items` (
	`Item_Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(50) NOT NULL,
    `Item_Type_Id` INT NOT NULL,
    CONSTRAINT `FK_Items_Item_Types`
        FOREIGN KEY (`Item_Type_Id`)
        REFERENCES `Item_Types` (`Item_Type_Id`)
);

CREATE TABLE `Cities`(
	`City_Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(50) NOT NULL
);

CREATE TABLE `Customers`(
	`Customer_Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(50) NOT NULL,
    `Birthday` DATE,
    `City_Id` INT NOT NULL,
     CONSTRAINT `FK_Customers_Cities`
        FOREIGN KEY (`City_Id`)
        REFERENCES `Cities` (`City_Id`)
);

CREATE TABLE `Orders`(
	`Order_Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Customer_Id` INT NOT NULL,
    CONSTRAINT `FK_Orders_Customers`
        FOREIGN KEY (`Customer_Id`)
        REFERENCES `Customers` (`Customer_Id`)
);

CREATE TABLE `Order_Items`(
	`Order_Id` INT NOT NULL,
    `Item_Id` INT NOT NULL,
    CONSTRAINT `PK_Order_Items`
        PRIMARY KEY (`Order_Id`, `Item_Id`),
	CONSTRAINT `FK_Order_Items_Orders`
        FOREIGN KEY (`Order_Id`)
        REFERENCES `Orders` (`Order_Id`),
	CONSTRAINT `FK_Order_Items_Items`
        FOREIGN KEY (`Item_Id`)
        REFERENCES `Items` (`Item_Id`)
);

        
/* 6. University Database */

CREATE DATABASE `University`;
USE `University`;

CREATE TABLE `Majors`(
	`Major_Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(50) NOT NULL
);

CREATE TABLE `Subjects`(
	`Subject_Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Subject_Name` VARCHAR(50) NOT NULL 
);

CREATE TABLE `Students`(
	`Student_Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Student_Number` VARCHAR(12) NOT NULL,
    `Student_Name` VARCHAR(50) NOT NULL,
    `Major_Id` INT NOT NULL,
    CONSTRAINT `FK_Majors`
    FOREIGN KEY (`Major_Id`)
    REFERENCES `Majors` (`Major_Id`)
);

CREATE TABLE `Payments`(
	`Payment_Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Payment_Date` DATE NOT NULL,
    `Payment_Amount` DECIMAL(8, 2),
    `Student_Id` INT NOT NULL,
    CONSTRAINT `FK_Payments`
    FOREIGN KEY (`Student_Id`)
    REFERENCES `Students` (`Student_Id`)
);

CREATE TABLE `Agenda`(
	`Student_Id` INT NOT NULL,
    `Subject_Id` INT NOT NULL,
    CONSTRAINT `PK_Subjects_Students`
		PRIMARY KEY(`Student_Id`, `Subject_Id`),
    CONSTRAINT `FK_Subjects`
		FOREIGN KEY (`Subject_Id`)
		REFERENCES `Subjects` (`Subject_Id`),
    CONSTRAINT `FK_Students`
		FOREIGN KEY (`Student_Id`) 
		REFERENCES `Students` (`Student_Id`)
);


/* 9. Peaks in Rila */

USE `Geography`;

SELECT M.`Mountain_Range`, P.`Peak_Name`, P.`Elevation` AS `Peak_Elevation`
FROM
	`Mountains` AS M
	JOIN `Peaks` AS P ON M.`Id` = P.`Mountain_Id`
WHERE 
	`Mountain_Range` = 'Rila'
ORDER BY `Peak_Elevation` DESC;
