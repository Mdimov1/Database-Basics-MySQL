
/* 1. Employees with Salary Above 35000 */

USE `Soft-Uni`;

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT `E`.`First_Name`, `E`.`Last_Name`
	FROM `Employees` AS `E`
	WHERE `E`.`Salary` > 3500
	ORDER BY `E`.`First_Name`, `E`.`Last_Name`, `E`.`Employee_Id`;
END $$
DELIMITER ;

CALL usp_get_employees_salary_above_35000();

DROP PROCEDURE IF EXISTS usp_get_employees_salary_above_35000;


/* 2. Employees with Salary Above Number */

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(salary_limit INT)
BEGIN
	SELECT `E`.`First_Name`, `E`.`Last_Name`
    FROM `Employees` AS `E`
    WHERE `E`.`Salary` >= salary_limit
    ORDER BY `E`.`First_Name`, `E`.`Last_Name`, `E`.`Employee_Id`;
END $$
DELIMITER ;

CALL usp_get_employees_salary_above(20000);

DROP PROCEDURE IF EXISTS usp_get_employees_salary_above;
	
	
/* 3. Town Names Starting With */

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(S TEXT)
BEGIN
	SELECT `T`.`Name` AS `Town_Name`
    FROM `Towns` AS `T`
    WHERE `T`.`Name` LIKE CONCAT(S, '%')
    ORDER BY `T`.`Name`;
END $$
DELIMITER ;

CALL usp_get_towns_starting_with('Ab');

DROP PROCEDURE IF EXISTS usp_get_towns_starting_with;


/* 4. Employees from Town */

DELIMITER $$ 
CREATE PROCEDURE usp_get_employees_from_town(town_name TEXT)
BEGIN
	SELECT `E`.`First_Name`, `E`.`Last_Name`
    FROM `Employees` AS `E`
    JOIN `Addresses` AS `A`
    ON `E`.`Address_Id` = `A`.`Address_Id`
    JOIN `Towns` AS `T`
    ON `A`.`Town_Id` = `T`.`Town_Id`
WHERE `T`.`Name` = town_name
ORDER BY `E`.`First_Name`, `E`.`Last_Name`, `E`.`Employee_Id`;
END $$
DELIMITER ;

CALL usp_get_employees_from_town('Sofia');

DROP PROCEDURE IF EXISTS usp_get_employees_from_town;


/* 5. Salary Level Function */
 
 /* 5.1 */
CREATE FUNCTION ufn_get_salary_level(salary_of_employee INT)
RETURNS VARCHAR(7)
RETURN (
    CASE
		WHEN salary_of_employee < 30000 THEN 'Low'
        WHEN salary_of_employee BETWEEN 30000 AND 50000 THEN 'Average'
        ELSE 'High'
	END 
);

SELECT ufn_get_salary_level(12000);

DROP FUNCTION IF EXISTS ufn_get_salary_level;

/* 5.2 */
DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(salary_of_employee INT)
RETURNS VARCHAR(7)
BEGIN 
	DECLARE salary_level VARCHAR(7);
    IF 
		salary_of_employee < 30000 THEN SET salary_level := 'Low';
    ELSEIF  
     salary_of_employee >= 30000 AND salary_of_employee <= 50000 THEN SET salary_level := 'Average';
	ELSE 
		SET salary_level := 'High';
	END IF;
    RETURN salary_level;
END $$
DELIMITER ;

SELECT ufn_get_salary_level(15000);


/* 6. Employees by Salary Level */

/* 6.1 */
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level TEXT)
BEGIN
    SELECT `E`.`First_Name`, `E`.`Last_Name`
    FROM `Employees` AS e
    WHERE `E`.`Salary` < 30000 AND salary_level = 'Low'
        OR `E`.`Salary` >= 30000 AND `E`.`Salary` <= 50000 AND salary_level = 'Average'
        OR `E`.`Salary` > 50000 AND salary_level = 'High'
    ORDER BY `E`.`First_Name` DESC, `E`.`Last_Name` DESC;
END $$
DELIMITER ;

/* 6.2 */
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level TEXT)
BEGIN
    SELECT `E`.`First_Name`, `E`.`Last_Name`
    FROM `Employees` AS `E`
    WHERE ufn_get_salary_level(`E`.`Salary`) = salary_level
    ORDER BY `E`.`First_Name` DESC, `E`.`Last_Name` DESC;
END $$
DELIMITER ;

CALL usp_get_employees_by_salary_level('Low');

DROP PROCEDURE IF EXISTS usp_get_employees_by_salary_level;


/* 7. Define Function */

/* 7.1 */
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT 
RETURN Word REGEXP (concat('^[', set_of_letters, ']+$'));

SELECT ufn_is_word_comprised('abcd', 'abc');

DROP FUNCTION IF EXISTS ufn_is_word_comprised;

/* 7.2 */
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT
BEGIN 
	DECLARE indx INT;
    DECLARE symbol VARCHAR(1);
    SET indx := 1;
    
    WHILE indx <= CHAR_LENGTH(word) DO
		SET symbol := SUBSTRING(word, indx, 1);
        IF LOCATE(symbol, set_of_letters) = 0 THEN RETURN 0;
        END IF;
        SET indx := indx + 1;
        END WHILE;
        RETURN 1;
	END $$
    DELIMITER ;
 
 
 
/* 8. Find Full Name */

DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN 
	SELECT CONCAT(`AH`.`First_Name`, ' ', `AH`.`Last_Name`) AS `Full_Name`
    FROM `Account_Holders` AS `AH`
    ORDER BY `Full_Name`, `AH`.`Id`;
END $$
DELIMITER ;

CALL usp_get_holders_full_name;

DROP PROCEDURE IF EXISTS usp_get_holders_full_name;


/* 9. People with Balance Higher Than */

DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(num DECIMAL(19, 7))
BEGIN 	
	SELECT `AH`.`First_Name`, `AH`.`Last_Name`
	FROM `Account_Holders` AS `AH`
    JOIN 
    (SELECT `A`.`Id`, `A`.`Account_Holder_Id`, SUM(`A`.`Balance`) AS 'Total_Balance'
    FROM `Accounts` AS `A`
    GROUP BY (`A`.`Account_Holder_Id`)
	HAVING `Total_Balance` > num) AS `A`
	ON `AH`.`Id` = `A`.`Account_Holder_Id`
    ORDER BY `A`.`Id`;
END $$
DELIMITER ;

CALL usp_get_holders_with_balance_higher_than(7000);

DROP PROCEDURE IF EXISTS usp_get_holders_with_balance_higher_than;


/* 10. Future Value Function */

DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(initial_sum DECIMAL(19, 4),
interest_rate DECIMAL(19, 4), num_of_years INT)
RETURNS DECIMAL(19, 2)
BEGIN 
	RETURN initial_sum * POW((1 + interest_rate), num_of_years);
END $$
DELIMITER ;

SELECT ufn_calculate_future_value(1000, 0.1, 5);

DROP FUNCTION IF EXISTS ufn_calculate_future_value;


/* 11. Calculating Interest */

DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(
account_id INT, interest_rate DECIMAL(19, 4))
BEGIN
	SELECT `A`.`Id` AS `Account_Id`, `AH`.`First_Name`, `AH`.`Last_Name`, 
    `A`.`Balance` AS `Current_Balance`, 
    ufn_calculate_future_value(`A`.`Balance`, interest_rate, 5) AS `Balance_In_5_Years`
    FROM `Account_Holders` AS `AH`
		JOIN `Accounts` AS `A`
		ON `AH`.`Id` = `A`.`Account_Holder_Id`
    WHERE `A`.`Id` = account_id;
END $$
DELIMITER ;

CALL usp_calculate_future_value_for_account(1, 0.1);

DROP PROCEDURE IF EXISTS usp_calculate_future_value_for_account;


/* 12. Deposit Money */

/* 12.1 */
DELIMITER $$ 
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19, 4))
proc_label: BEGIN 
	IF
		money_amount > 0.00 THEN START TRANSACTION;
        
	UPDATE `Accounts` AS `A`
	SET `A`.`Balance` = `A`.`Balance` + money_amount
	WHERE `A`.`Id` = account_id;
	
		IF (SELECT `A`.`Balance` 
			FROM `Accounts` AS `A`
            WHERE `A`.`Id` = account_id) < 0
            THEN ROLLBACK;
		ELSE
			COMMIT;
		END IF;
	END IF;
END $$
DELIMITER ;

/* 12.2 */
DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN 
	IF
		money_amount < 0 THEN ROLLBACK;
	ELSE
		UPDATE `Accounts` AS `A`
        SET `A`.`Balance` = `A`.`Balance` + money_amount
        WHERE `A`.`Id` = account_id;
	END IF;
    COMMIT;
END $$
DELIMITER ;

CALL usp_deposit_money(1, 10);


/* 13. Withdraw Money */

DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN 
	IF
		money_amount < 0.00 THEN ROLLBACK;
	ELSEIF 
		(SELECT `A`.`Balance` - money_amount
			FROM `Accounts` AS `A`
		WHERE `A`.`Id` = account_id) < 0.00
        THEN ROLLBACK;
	ELSE
		UPDATE `Accounts` AS `A`
        SET `A`.`Balance` = `A`.`Balance` - money_amount;
	END IF;
    COMMIT;
END $$
DELIMITER ;


/* 14. Money Transfer */

DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19, 4))
BEGIN 
	IF
		amount > 0	
        AND
		(SELECT `A`.`Id`
        FROM `Accounts` AS `A`
        WHERE `A`.`Id` = to_account_id) IS NOT NULL
        AND
        (SELECT `A`.`Id`
        FROM `Accounts` AS `A`
        WHERE `A`.`Id` = from_account_id) IS NOT NULL
        AND
        from_account_id <> to_account_id
        AND
        (SELECT `A`.`Balance`
        FROM `Accounts` AS `A`
        WHERE `A`.`Id` = from_account_id) >= amount
	THEN
		START TRANSACTION;
        
		UPDATE `Accounts` AS `A`
        SET `A`.`Balance` = `A`.`Balance` - amount
        WHERE `A`.`Id` = from_account_id;
        
        UPDATE `Accounts` AS `A`
        SET `A`.`Balance` = `A`.`Balance` + amount
        WHERE `A`.`Id` = to_account_id;
		COMMIT;
    END IF;
END $$
DELIMITER ;


/* 15. Log Accounts Trigger */

CREATE TABLE `Logs`(
	`Log_Id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `Account_Id` INT NOT NULL,
    `Old_Sum` DECIMAL(19, 2) NOT NULL,
    `New_Sum` DECIMAL(19, 2) NOT NULL
);

DELIMITER $$
CREATE TRIGGER `TR_Balance_Updated`
AFTER UPDATE ON `Accounts`
FOR EACH ROW
BEGIN
	IF OLD.`Balance` <> NEW.`Balance`
    THEN 
    INSERT INTO `Logs`
		(`Account_Id`, `Old_Sum`, `New_Sum`)
	VALUES 
		(OLD.`Id`, OLD.`Balance`, OLD.`Balance`);
	END IF;
END $$
DELIMITER ;

CALL usp_transfer_Money(1, 2, 10);

SELECT * FROM `Logs`;

DROP TRIGGER IF EXISTS `Bank`.`TR_Balance_Updated`;
DROP TABLE IF EXISTS `Logs`;


/* 16. Emails Trigger */

CREATE TABLE `Notification_Emails`(
	`Id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `Recipient` INT NOT NULL,
    `Subject` VARCHAR(50),
    `Body` VARCHAR(255)
);

DELIMITER $$
CREATE TRIGGER `TR_Notification_Emails`
AFTER INSERT ON `Logs`
FOR EACH ROW
BEGIN 
	INSERT INTO `Notification_Emails`
		(`Recipient`, `Subject`, `Body`)
	VALUES (
		NEW.`Account_Id`,
        CONCAT('Balance change for account: ', NEW.`Account_Id`),
        CONCAT(`On `, DATE_FORMAT(NOW(), '%b %d %Y at %r'), ' your balance was changed from ',
        ROUND(NEW.`Old_Sum`, 2), ' to ', ROUND(NEW.`New_Sum`, 2), '.'));
END $$
DELIMITER ;
	
SELECT * FROM `Notification_Emails`;

DROP TRIGGER IF EXISTS `Bank`.`TR_Notification_Emails`;
DROP TABLE IF EXISTS `Notification_Emails`;