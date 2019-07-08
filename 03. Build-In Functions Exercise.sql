/*1. Find Names of All Employees by First Name*/

USE `Soft_Uni`;

SELECT `First_Name`, `Last_Name` FROM `Employees`
WHERE 'First_Name' REGEXP '^Sa'
ORDER BY `Employee_Id`;


/*2. Find Names of All employees by Last Name*/

SELECT `First_Name`, `Last_Name` FROM `Employees`
WHERE `Last_Name` LIKE '%ei%'
ORDER BY `Employee_Id`;


/*3. Find First Names of All Employees*/

SELECT `First_Name` FROM `Employees`
WHERE 
`Department_Id` IN (3, 10) 
	AND YEAR(`hire_date`) >= 1995
	AND YEAR(`hire_date`) <= 2005
ORDER BY `Employee_Id`;


/*4. Find All Employees Except Engineers*/

SELECT `First_Name`, `Last_Name` FROM `Employees`
WHERE 
`Job_Title` NOT LIKE '%engineer%'
ORDER BY `Employee_Id`;


/*5. Find Towns with Name Length*/

SELECT `Name` FROM `Towns`
WHERE LENGTH(`Name`) BETWEEN 5 AND 6
ORDER BY `Name`;


/*6. Find Towns Starting With*/

SELECT `Town_Id`, `Name` FROM `Towns`
WHERE
`Name` REGEXP '^M' OR
`Name` REGEXP '^K' OR
`Name` REGEXP '^B' OR 
`Name` REGEXP '^E'
ORDER BY `Name`;


/*7. Find Towns Not Starting With*/

SELECT `Town_Id`, `Name` FROM `Towns`
WHERE
SUBSTRING(`Name`, 1, 1) NOT IN ('R', 'B', 'D')
ORDER BY `Name`;


/*8. Create View Employees Hired After 2000 Year*/

CREATE VIEW `V_EMPLOYEES_HIRED_AFTER_2000` 
AS SELECT `First_Name`, `Last_Name` FROM `Employees`
WHERE YEAR(`Hire_Date`) > 2000;


/*9. Length of Last Name*/

SELECT `First_Name`, `Last_Name` FROM `Employees`
WHERE LENGTH(`Last_Name`) = 5; 


/*10. Countries Holding ‘A’ 3 or More Times*/

USE `Geography`;

SELECT `Country_Name`, `ISO_Code` FROM `Countries`
WHERE
(LENGTH(`Country_Name`) - LENGTH(REPLACE(LOWER(`Country_Name`), 'a', ''))) >= 3
ORDER BY `ISO_Code`;


/*11. Mix of Peak and River Names*/

SELECT `Peak_Name`, `River_Name`,
LOWER(CONCAT(`Peak_Name`, SUBSTRING(`River_Name`, 2))) AS MIX FROM `Peaks`, `Rivers`
WHERE
RIGHT(`Peak_Name`, 1) = LEFT(`River_Name`, 1)
ORDER BY MIX;


/*12. Games from 2011 and 2012 year*/

USE `Diablo`;

SELECT `Name`, DATE_FORMAT(`Start`, '%Y-%m-%d') FROM `Games`
WHERE
YEAR(`Start`) BETWEEN 2011 AND 2012 
ORDER BY `Start`, `Name`
LIMIT 50;


/*13. User Email Providers*/

SELECT `User_Name`, SUBSTRING_INDEX(`email`, '@', - 1) AS 'Email_Provider' 
FROM `Users`
ORDER BY `Email_Provider`, `User_Name`;


/*14. Get Users with IP Address Like Pattern*/

SELECT `User_Name`, `Ip_Address` FROM `Users`
WHERE `Ip_Address` LIKE '___.1%.%.___'
ORDER BY `User_Name`;


/*15. Show All Games with Duration and Part of the Day*/

SELECT `Name` AS 'Game',
CASE
	WHEN HOUR(`Start`) BETWEEN 0 AND 11 THEN "Morning"
    WHEN HOUR(`Start`) BETWEEN 12 AND 17 THEN "Afternoon"
    ELSE "Evening"
END AS 'Part_Of_The_Day',
CASE
	WHEN `Duration` <= 3 THEN "Extra Short"
    WHEN `Duration` BETWEEN 4 AND 6 THEN "Short"
    WHEN `Duration` BETWEEN 7 AND 10 THEN "Long"
    ELSE "Extra Long" 
END AS 'Duraton'
FROM `Games`;


/*16. Orders Table*/

SELECT `Product_Name`, `Order_Date`,
DATE_ADD(`Order_Date`, INTERVAL 3 DAY) AS 'Pay_Due',
DATE_ADD(`Order_Date`, INTERVAL 1 MONTH) AS 'Deliver_Due'
FROM `Orders`;
