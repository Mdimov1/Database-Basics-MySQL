USE `Soft-Uni`;

/* 1. Employee Address */

SELECT `e`.`employee_id`, `e`.`job_title`, `e`.`address_id`, `a`.`address_text`
FROM `Employees` AS `e`
	JOIN `Addresses` AS `a`
	ON `e`.`Address_Id` = `a`.`Address_Id`
ORDER BY `e`.`Address_Id`
LIMIT 5;


/* 02.	Addresses with Towns */

SELECT `e`.`First_Name`, `e`.`Last_Name`, `t`.`Name`, `a`.`Address_Text`
FROM `Employees` AS `e`
	JOIN `Addresses` AS `a`
	ON `a`.`Address_Id` = `e`.`Address_Id`
	JOIN `Towns` AS `t`
	ON `t`.`Town_Id` = `a`.`Town_Id`
ORDER BY `e`.`First_Name`, `e`.`Last_Name`
LIMIT 5;


/* 3. Sales Employee */

SELECT `E`.`Employee_Id`, `E`.`First_Name`, `E`.`Last_Name`, `D`.`Name` AS `Department_Name`
FROM `Employees` AS `E`
	JOIN `Departments` AS `D`
    ON `D`.`Department_Id` = `E`.`Department_Id`
    WHERE `D`.`Name` = 'Sales'
ORDER BY `E`.`Employee_Id` DESC;


/* 04. Employee Departments*/

SELECT `E`.`Employee_Id`, `E`.`First_Name`, `E`.`Salary`, `D`.`Name` AS `Department_Name`
FROM `Employees` AS `E`
	JOIN `Departments` AS `D`
    ON `D`.`Department_Id` = `E`.`Department_Id`
    WHERE `E`.`Salary` > 15000
ORDER BY `E`.`Department_Id` DESC
LIMIT 5;


/* 5. Employees Without Project */

/* 5.1 */
SELECT `E`.`Employee_Id`, `E`.`First_Name`
FROM `Employees` AS `E` 
	LEFT JOIN `Employees_Projects` AS `EP`
    ON `EP`.`Employee_Id` = `E`.`Employee_Id`	
    LEFT JOIN `Projects` AS `P`
    ON `P`.`Project_Id` = `EP`.`Project_Id`
WHERE `P`.`Name` IS NULL
ORDER BY `E`.`Employee_Id` DESC
LIMIT 3;

/* 5.2 */
SELECT `E`.`Employee_Id`, `E`.`First_Name`
FROM `Employees` AS `E` 
	LEFT JOIN `Employees_Projects` AS `EP`
    ON `EP`.`Employee_Id` = `E`.`Employee_Id`
WHERE `EP`.`Project_Id` IS NULL
ORDER BY `E`.`Employee_Id` DESC
LIMIT 3;


/* 6. Employees Hired After */

/* 6.1 */
SELECT `E`.`First_Name`, `E`.`Last_Name`, `E`.`Hire_Date`, `D`.`Name` AS `Dept_Name`
FROM `Employees` AS `E`
	JOIN `Departments` AS `D`
    ON `D`.`Department_Id` = `E`.`Department_Id`
WHERE 
	`E`.`Hire_Date` > '1999-01-01'
	HAVING `D`.`Name` = 'Sales' OR `D`.`Name` = 'Finance'
ORDER BY `E`.`Hire_Date`;

/* 6.2 Better Solution */
SELECT `E`.`First_Name`, `E`.`Last_Name`, `E`.`Hire_Date`, `D`.`Name` AS `Dept_Name`
FROM `Employees` AS `E`
	JOIN `Departments` AS `D`
    ON `D`.`Department_Id` = `E`.`Department_Id`
WHERE 
	DATE(`E`.`Hire_Date`) > '1999/1/1'
	AND `D`.`Name` IN ('Sales', 'Finance')
ORDER BY `E`.`Hire_Date`;


/* 7. Employees with Project */

SELECT `E`.`Employee_Id`, `E`.`First_Name`, `P`.`Name` AS `Project_Name`
FROM `Employees` AS `E` 
	JOIN `Employees_Projects` AS `EP`
    ON `EP`.`Employee_Id` = `E`.`Employee_Id`	
    JOIN `Projects` AS `P`
    ON `P`.`Project_Id` = `EP`.`Project_Id`
WHERE 
	DATE(`P`.`Start_Date`) > '2002/08/13'
    AND `P`.`End_Date` IS NULL
ORDER BY `E`.`First_Name`, `P`.`Name`
LIMIT 5;


/* 8. Employee 24 */

SELECT `E`.`Employee_Id`, `E`.`First_Name`, 
IF(YEAR(`P`.`Start_Date`) >= '2005', NULL, `P`.`Name`) AS `Project_Name`
FROM `Employees` AS `E` 
	JOIN `Employees_Projects` AS `EP`
    ON `EP`.`Employee_Id` = `E`.`Employee_Id`	
    JOIN `Projects` AS `P`
    ON `P`.`Project_Id` = `EP`.`Project_Id`
WHERE 
	`E`.`Employee_Id` = 24
ORDER BY `P`.`Name`;


/* 9. Employee Manager */

SELECT `E`.`Employee_Id`, `E`.`First_Name`, `E`.`Manager_Id`, `M`.`First_Name`
FROM `Employees` AS `E`
	JOIN `Employees` AS `M`
    ON	`M`.`Employee_Id` = `E`.`Manager_Id`
WHERE `E`.`Manager_Id` IN (3, 7)
ORDER BY `E`.`First_Name`;


/* 10. Employee Summary */

SELECT `E`.`Employee_Id`, 
CONCAT(`E`.`First_Name`, ' ', `E`.`Last_Name`) AS `Employee_Name`, 
CONCAT(`M`.`First_Name`, ' ', `M`.`Last_Name`) AS `Manager_Name`, 
`D`.`Name` AS `Department_Name`
FROM `Employees` AS `E`
	JOIN `Employees` AS `M`
    ON `E`.`Manager_Id` = `M`.`Employee_Id`
    JOIN `Departments` AS `D`
    ON `E`.`Department_Id` = `D`.`Department_Id`
WHERE `E`.`Manager_Id` IS NOT NULL
ORDER BY `E`.`Employee_Id`
LIMIT 5;


/* 11. Min Average Salary */

SELECT AVG(`E`.`Salary`) AS `Min_Average_Salary`
FROM `Employees` AS `E`
WHERE `E`.`Department_Id` IS NOT NULL
GROUP BY `E`.`Department_Id`
ORDER BY `Min_Average_Salary`
LIMIT 1;


/* 12. Highest Peaks in Bulgaria */

USE `Geography`;

SELECT `C`.`Country_Code`, `M`.`Mountain_Range`, `P`.`Peak_Name`, `P`.`Elevation`
FROM `Countries` AS `C`
	JOIN `Mountains_Countries` AS `MC`
    ON `C`.`Country_Code` = `MC`.`Country_Code`
    JOIN `Mountains` AS `M`
    ON `MC`.`Mountain_Id` = `M`.`Id`
    JOIN `Peaks` AS `P`
    ON `MC`.`Mountain_Id` = `P`.`Mountain_Id`
WHERE `P`.`Elevation` > 2835 AND `C`.`Country_Code` = 'BG'
ORDER BY `P`.`Elevation` DESC;
   
   
/* 13. Count Mountain Ranges */

SELECT `C`.`Country_Code`, COUNT(`MC`.`Mountain_Id`) AS `Mountain_Range`
FROM `Countries` AS `C`
	JOIN `Mountains_Countries` AS `MC`
    ON `C`.`Country_Code` = `MC`.`Country_Code`
WHERE `C`.`Country_Code` IN ('BG', 'RU', 'US')
GROUP BY `C`.`Country_Code`
ORDER BY `Mountain_Range` DESC;
	
    
/* 14. Countries with Rivers */

SELECT `C`.`Country_Name`, `R`.`River_Name`
FROM `Countries` AS `C`
	LEFT JOIN `Countries_Rivers` AS `CR`
	ON `CR`.`Country_Code` = `C`.`Country_Code`
    LEFT JOIN `Rivers` AS `R`
    ON `R`.`Id` = `CR`.`River_Id`
WHERE `C`.`Continent_Code` = 'AF'
ORDER BY `C`.`Country_Name`
LIMIT 5;


/* 15. *Continents and Currencies */

/* 15.1 */
SELECT `Sel2`.`Continent_Code`, `Sel2`.`Currency_Code`, `Sel2`.`Currency_Usage` 
FROM (
	SELECT `C`.`Continent_Code`, `C`.`Currency_Code`, 
	COUNT(`C`.`Currency_Code`) AS `Currency_Usage`, 
	DENSE_RANK() OVER (PARTITION BY `C`.`Continent_Code` 
	ORDER BY COUNT(`C`.`Currency_Code`) DESC) AS `R` 
	FROM `Countries` AS `C`
	GROUP BY `C`.`Continent_Code`, `C`.`Currency_Code`) AS `Sel2`
WHERE `Sel2`.`R` = 1 AND `Sel2`.`Currency_Usage` <> 1;

/* 15.2 */
SELECT 
	`C`.`Continent_Code`,
    `C`.`Currency_Code`,
    COUNT(*) AS 'Currency_Usage'
FROM
    `Countries` AS `C`
GROUP BY `C`.`Continent_Code`, `C`.`Currency_Code`
HAVING `Currency_Usage` > 1
    AND `Currency_Usage` = (SELECT 
        COUNT(*) AS `CN`
    FROM
        `Countries` AS `C2`
    WHERE
        `C2`.`Continent_Code` = `C`.`Continent_Code`
    GROUP BY `C2`.`Currency_Code`
    ORDER BY `CN` DESC
    LIMIT 1)
ORDER BY `C`.`Continent_Code`, `C`.`Continent_Code`;


/* 16. Countries without any Mountains */

SELECT COUNT(*) AS `Country_Count`
FROM `Countries` AS `C`
	LEFT JOIN `Mountains_Countries` AS `MC`
    ON `C`.`Country_Code` = `MC`.`Country_Code`
WHERE `MC`.`Mountain_Id` IS NULL;


/* 17. Highest Peak and Longest River by Country */

SELECT `C`.`Country_Name`, 
MAX(`P`.`Elevation`) AS `Highest_Peak_Elevation`, 
MAX(`R`.`Length`) AS `Longest_River_Length`
FROM `Countries` AS `C`
	LEFT JOIN `Mountains_Countries` AS `MC`
    ON `C`.`Country_Code` = `MC`.`Country_Code`
    LEFT JOIN `Peaks` AS `P`
    ON `MC`.`Mountain_Id` = `P`.`Mountain_Id`
	LEFT JOIN `Countries_Rivers` AS `CR`
    ON `C`.`Country_Code` = `CR`.`Country_Code`
    LEFT JOIN `Rivers` AS `R`
    ON `CR`.`River_Id` = `R`.`Id`
GROUP BY `C`.`Country_Name`
ORDER BY `Highest_Peak_Elevation` DESC, `Longest_River_Length` DESC,
`C`.`Country_Name`
LIMIT 5;
    