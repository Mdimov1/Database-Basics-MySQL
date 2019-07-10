/*1. Find All Information About Departments*/

USE `Soft-Uni`;

SELECT * FROM `Departments`
ORDER BY `Department_Id`;


/*2. Find all Department Names*/

SELECT `Name` FROM `Departments`
ORDER BY `Department_Id`;


/*3. Find Salary of Each Employee*/

SELECT `First_Name`, `Last_Name`, `Salary` FROM `Employees`
ORDER BY `Employee_Id`;


/*4. Find Full Name of Each Employee*/

SELECT `First_Name`, `Middle_Name`, `Last_Name` FROM `Employees`
ORDER BY `Employee_Id`;


/*5. Find Email Address of Each Employee*/

CREATE VIEW `Full_Email_Address` AS
SELECT 
CONCAT(`First_Name`, '.', `Last_Name`, '@softuni.bg') 
FROM `Employees`;
SELECT * FROM `Full_Email_Address`;


/*6. Find All Different Employee’s Salaries*/ 

SELECT DISTINCT `Salary` FROM `Employees`
ORDER BY `Employee_Id`;


/*7. Find all Information About Employees */ 

SELECT * FROM `Employees` 
WHERE `Job_Title` = 'Sales Representative'
ORDER BY `Employee_Id`;


/*8. Find Names of All Employees by Salary in Range*/ 

SELECT `First_Name`, `Last_Name`, `Job_Title` FROM `Employees`
WHERE `Salary` BETWEEN 20000 AND 30000
ORDER BY `Employee_Id`;


/*9. Find Names of All Employees */

CREATE VIEW `Full_Name` AS SELECT 
CONCAT(`First_Name`, ' ', `Middle_Name`, ' ', `Last_Name`) 
FROM `Employees`
WHERE
`Salary` IN (25000, 14000, 12500, 23600);

SELECT * FROM `Full_Name`;


/*10. Find All Employees Without Manager*/

SELECT `First_Name`, `Last_Name` FROM `Employees`
WHERE Manager_Id IS NULL;


/*11. Find All Employees with Salary More Than*/

SELECT `First_Name`, `Last_Name`, `Salary` FROM `Employees`
WHERE 
`Salary` > 50000
ORDER BY `Salary` DESC;


/*12. Find 5 Best Paid Employees*/

SELECT `First_Name`, `Last_Name` FROM `Employees`
ORDER BY Salary DESC LIMIT 5;


/*13. Find All Employees Except Marketing*/

SELECT `First_Name`, `Last_Name` FROM `Employees`
WHERE Department_Id != 4;


/*14. Sort Employees Table*/

SELECT * FROM `Employees`
ORDER BY Salary DESC,
First_Name, Last_Name DESC,
Middle_Name, Employee_Id;


/*15. Create View Employees with Salaries*/

CREATE VIEW `V_EMPLOYEES_SALARIES` AS SELECT
`First_Name`, `Last_Name`, `Salary`
FROM `Employees`;


/*16. Create View Employees with Job Titles*/

CREATE VIEW `V_EMPLOYEES_JOB_TITLE` AS 
SELECT `First_Name` + ' ' + ISNULL (`Middle_Name`, '') + ' ' +  `Last_Name`
AS `Full_Name`, `Job_Title`
FROM `Employees`;


/*17. Distinct Job Titles*/

SELECT DISTINCT `Job_Title` FROM `Employees`
ORDER BY `Job_Title`;  


/*18. Find First 10 Started Projects*/

SELECT `Project_Id`, `Name`, `Description`, `Start_Date`, `End_Date` FROM `Projects`
ORDER BY `Start_Date`, `Name`, `Project_Id` LIMIT 10;


/*19. Last 7 Hired Employees*/

SELECT `First_Name`, `Last_Name`, `Hire_Date` FROM `Employees`
ORDER BY `Hire_Date`DESC LIMIT 7;

	
/*20. Increase Salaries*/

UPDATE `Employees`
SET `Salary` = `Salary` + `Salary`*12.0/100.0
WHERE `Job_Title` IN ('Engineering', 'Tool_Design', 'Marketing','Information_Services');
SELECT `Salary` FROM `Employees`;


/*21. All Mountain Peaks*/

SELECT Peak_Name FROM Peaks
ORDER BY Peak_Name;


/*22. Biggest Countries by Population */

SELECT `Country_Name`, `Population` FROM `Countries`
WHERE ContinentCode = 'EU'
ORDER BY `Population` DESC, `Country_Name` LIMIT 30;


/*23. Countries and Currency (Euro / Not Euro)*/

SELECT Country_Name, Country_Code, 
CASE Currency_Code
	WHEN 'EUR' THEN 'Euro'
    ELSE 'Not Euro'
END AS Currency FROM Countries
ORDER BY Country_Name;


/*24. All Diablo Characters */

SELECT `Name` FROM Characters
ORDER BY `Name`;
