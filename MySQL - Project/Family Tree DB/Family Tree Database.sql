CREATE DATABASE `Family_Tree`;
USE `Family_Tree`;

CREATE TABLE `Families`(
	`Family_Id` INT(10) UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `Name` VARBINARY(50) NOT NULL,
    `Description` VARBINARY(255) NULL,
    `Note` VARBINARY(255) NULL
);

CREATE TABLE `Roles`(
	`Role_Code` INT(10) UNSIGNED PRIMARY KEY NOT NULL,
    `Role_Description` VARBINARY(50)
);

CREATE TABLE `Relationship_Types`(
	`Relationship_Type_Code` INT(10) UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `Relationship_Type_Description` VARBINARY(50) NOT NULL
);

CREATE TABLE `Persons`(
	`Person_Id` INT(10) UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `First_Name` VARBINARY(30) NOT NULL,
    `Last_Name` VARBINARY(30) NOT NULL,
    `Gender` CHAR(5) NOT NULL,
    `Age` TINYINT UNSIGNED NULL,
    `Note` VARBINARY(255) NULL
);

CREATE TABLE `Relationships`(
	`Relationship_Id` INT(10) UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `Family_Id` INT(10) UNSIGNED UNIQUE NOT NULL,
    `Person_1_Id` INT(10) UNSIGNED UNIQUE NOT NULL,
	`Person_2_Id` INT(10) UNSIGNED UNIQUE NOT NULL,
	`Relationship_Type_Code` INT(10) UNSIGNED UNIQUE NOT NULL,
    `Person_1_Role_Code` INT(10) UNSIGNED UNIQUE NOT NULL,
    `Person_2_Role_Code` INT(10) UNSIGNED UNIQUE NOT NULL,
	`Note` VARBINARY(255) NULL,
	CONSTRAINT `FK_Relationships_Families`
    FOREIGN KEY (`Family_Id`)
    REFERENCES `Families` (`Family_Id`),
	CONSTRAINT `FK_Relationships_Roles_1`
    FOREIGN KEY (`Person_1_Role_Code`)
    REFERENCES `Roles` (`Role_Code`),
	CONSTRAINT `FK_Relationships_Roles_2`
    FOREIGN KEY (`Person_2_Role_Code`)
    REFERENCES `Roles` (`Role_Code`),
	CONSTRAINT `FK_Relationships_Relationship_Types` 
    FOREIGN KEY (`Relationship_Type_Code`)
    REFERENCES `Relationship_Types` (`Relationship_Type_Code`),
    CONSTRAINT `PK_Relationsips_Persons_1`
    FOREIGN KEY (`Person_1_Id`)
    REFERENCES `Persons` (`Person_Id`),
    CONSTRAINT `PK_Relationsips_Persons_2`
    FOREIGN KEY (`Person_2_Id`)
    REFERENCES `Persons` (`Person_Id`)
);

