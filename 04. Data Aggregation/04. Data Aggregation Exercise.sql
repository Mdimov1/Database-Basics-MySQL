USE `Gringotts`;

/* 1. Records’ Count */

SELECT COUNT(`Id`) AS 'Count' FROM `Wizzard_Deposits`;


/* 2. Longest Magic Wand */

/* 2.1 */
SELECT MAX(`Magic_Wand_Size`) AS 'Longest_Magic_Wand'
FROM `Wizzard_Deposits`;

/* 2.2 */
SELECT `Magic_Wand_Size` AS 'Longest_Magic_Wand'
FROM `Wizzard_Deposits`
ORDER BY `Magic_Wand_Size` DESC
LIMIT 1;


/* 3. Longest Magic Wand per Deposit Groups */

SELECT `Deposit_Group`, MAX(`Magic_Wand_Size`) AS 'Longest_Magic_Wand'
FROM `Wizzard_Deposits`
GROUP BY `Deposit_Group`
ORDER BY 'Longest_Magic_Land', `Deposit_Group`;


/* 4. Smallest Deposit Group per Magic Wand Size**/

SELECT `Deposit_Group`
FROM `Wizzard_Deposits`
GROUP BY `Deposit_Group`
ORDER BY AVG(`Magic_Wand_Size`)
LIMIT 1;


/* 5. Deposits Sum */

SELECT `Deposit_Group`, SUM(`Deposit_Amount`) AS 'Total_Sum'
FROM `Wizzard_Deposits`
GROUP BY `Deposit_Group`
ORDER BY `Total_Sum`;


/* 6. Deposits Sum for Ollivander family */

SELECT `Deposit_Group`, SUM(`Deposit_Amount`) AS 'Total_Sum'
FROM `Wizzard_Deposits`
WHERE `Magic_Wand_Creator` = 'Ollivander family'
GROUP BY `Deposit_Group`
ORDER BY `Deposit_Group`;


/* 7. Deposits Filter */

SELECT `Deposit_Group`, SUM(`Deposit_Amount`) AS 'Total_Sum'
FROM `Wizzard_Deposits`
WHERE `Magic_Wand_Creator` = 'Ollivander family'
GROUP BY `Deposit_Group`
HAVING `Total_Sum` < 150000
ORDER BY `Total_Sum` DESC;


/* 8. Deposit charge */

SELECT `Deposit_Group`, `Magic_Wand_Creator`, MIN(`Deposit_Charge`)
FROM `Wizzard_Deposits`
GROUP BY `Deposit_Group`, `Magic_Wand_Creator`
ORDER BY `Magic_Wand_Creator`, `Deposit_Group`;


/* 9. Age Groups */

SELECT
	CASE 
		WHEN `Age` BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN `Age` BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN `Age` BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN `Age` BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN `Age` BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN `Age` BETWEEN 51 AND 60 THEN '[51-60]'
		ELSE '[61+]'
	END AS 'Age_Group', 
	COUNT(`Age`) AS 'Wizard_Count'
FROM `Wizzard_Deposits`
GROUP BY `Age_Group`
ORDER BY `Age_Group`;


/* 10. First Letter */

SELECT LEFT(`First_Name`, 1) AS 'First_Letter'
FROM `Wizzard_Deposits`
WHERE `Deposit_Group` = 'Troll Chest'
GROUP BY `First_Letter`
ORDER BY `First_Letter`;


/* 11. Average Interest */

SELECT `Deposit_Group`, `Is_Deposit_Expired`, 
AVG(`Deposit_Interest`) AS 'Deposit_Interest'
FROM `Wizzard_Deposits`
WHERE `Deposit_Start_Date` > '1985-01-01'
GROUP BY `Deposit_Group`, `Is_Deposit_Expired`
ORDER BY `Deposit_Group` DESC, `Is_Deposit_Expired`;


/* 12. Rich Wizard, Poor Wizard* */

SELECT SUM(diff.next) AS 'Sum_Difference'
FROM (
	SELECT `Deposit_Amount` - 
			(SELECT `Deposit_Amount`
            FROM `Wizzard_Deposits`
            WHERE `Id` = Wd.Id + 1) AS 'Next'
	FROM `Wizzard_Deposits` AS Wd) AS Diff;
    
  
/* 13. Employees Minimum Salaries */

USE `Soft-Uni`;

SELECT `Department_Id`, MIN(Em.Salary) AS 'Minimum_Salary'
FROM `Employees` AS Em
WHERE `Department_Id` IN (2, 5, 7) 
AND `Hire_Date` > '2000/01/01'
GROUP BY `Department_Id`
ORDER BY `Department_Id`;  


/* 14. Employees Average Salaries */

CREATE TABLE High_Paid
AS SELECT * FROM Employees AS e
WHERE e.Salary > 30000;

DELETE FROM High_Paid 
WHERE Manager_Id = 42; 

UPDATE High_Paid 
SET Salary = Salary + 5000
WHERE Department_Id = 1; 

SELECT Department_Id, AVG(hp.Salary) AS 'AVG_Salary'
FROM High_Paid AS hp
GROUP BY `Department_Id`
ORDER BY `Department_Id`;


/* 15. Employees Maximum Salaries */

SELECT `Department_Id`, MAX(`Salary`) AS 'Max_Salary'
FROM `Employees`
GROUP BY `Department_Id`
HAVING NOT `Max_Salary` BETWEEN 30000 AND 70000
ORDER BY `Department_Id`;

/* 16. Employees Count Salaries */

SELECT COUNT(`Salary`) FROM `Employees`
WHERE ISNULL(`Manager_Id`);


/* 17. 3rd Highest Salary* */

/* 17.1 */
WITH `Salary_Rank`
AS (SELECT 
	`Department_Id`, `Salary`,
	DENSE_RANK() OVER (PARTITION BY `Department_Id`
		ORDER BY `Salary` DESC) 
AS `Rank`
FROM `Employees`)
SELECT `Department_Id`, `Salary` AS 'Third_Highest_Salary'
FROM `Salary_Rank`
WHERE `Rank` = 3;

/* 17.2 */
SELECT 
    `Department_Id`,
    (SELECT DISTINCT
            `E2`.`Salary`
        FROM
            `Employees` AS `E2`
        WHERE
            `E2`.`Department_Id` = `E1`.`Department_Id`
        ORDER BY `E2`.`Salary` DESC
        LIMIT 2 , 1) AS `Third_Highest_Salary`
FROM
    `Employees` AS `E1`
GROUP BY `Department_Id`
HAVING `Third_Highest_Salary` IS NOT NULL;


/* 18. Salary Challenge** */

SELECT `E`.`First_Name`, `E`.`Last_Name`, `E`.`Department_Id`
FROM `Employees` AS `E`
	JOIN
    (SELECT `Department_Id`, AVG(`Salary`) AS 'AVG_Salary'
    FROM `Employees`
    GROUP BY `Department_Id`) AS `Avg` ON `E`.`Department_Id` = `Avg`.`Department_Id`
WHERE `Salary` > `Avg`.`AVG_Salary`
ORDER BY `Department_Id`
LIMIT 10;


/* 19. Departments Total Salaries */

SELECT `Department_Id`, SUM(`Salary`) AS `Total_Salary`
FROM `Employees`
GROUP BY `Department_Id`
ORDEr BY `Department_Id`;

