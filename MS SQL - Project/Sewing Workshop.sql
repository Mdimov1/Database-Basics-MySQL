/* I. Create DB for sewing workshop */

CREATE DATABASE Sewing_Workshop; 
 
GO
USE Sewing_Workshop;

GO
CREATE TABLE Services(
	Service_Id INT CHECK (Service_Id > 0) PRIMARY KEY NOT NULL,
    Service_Name NVARCHAR(50) NOT NULL,
    Necessary_Time_In_Hours INT NOT NULL,
    Service_Price INT NOT NULL
);

GO
CREATE TABLE Orders(
	Order_Id INT CHECK (Order_Id > 0) PRIMARY KEY IDENTITY NOT NULL,
    Order_Date DATE NOT NULL,
    Order_Status VARCHAR(50) NOT NULL,
    Order_Term INT NOT NULL,
    Service_Id INT CHECK(Service_Id > 0) NOT NULL,
    CONSTRAINT FK_Orders_Servicers 
    FOREIGN KEY (Service_Id) 
    REFERENCES Services (Service_Id)
);

GO
CREATE TABLE Tailors(
	Tailor_Id INT CHECK (Tailor_Id > 0) PRIMARY KEY IDENTITY NOT NULL,
    Tailor_Name NVARCHAR(50) NOT NULL,
    Tailor_Age INT NULL,
    Finished_Orders INT NULL,
    Order_Id INT CHECK (Order_Id > 0) NOT NULL,
    CONSTRAINT FK_Tailors_Orders 
    FOREIGN KEY (Order_Id) 
    REFERENCES Orders (Order_Id)
);
 
/* Insert data into tables */

GO
INSERT INTO Services(Service_Id, Service_Name, Necessary_Time_In_Hours, Service_Price) 
VALUES
(1, 'Restitching a frayed seam', 10, 5),
(2, 'Shortening dress', 20, 19),
(3, 'Hemming a dress', 5, 12),
(4, 'Button replacement', 5, 1),
(5, 'Altering a leather jacket', 60, 70),
(6, 'Altering wedding gowns', 50, 45),
(7, 'Creating a Dress', 120, 200); 

GO
INSERT INTO Orders(Order_Date, Order_Status, Order_Term, Service_Id)
VALUES
('2017-06-15', 'Finished', 20, 2),
('2018-07-10', 'Finished', 50, 3),
('2019-06-09', 'Finished', 30, 1),
('2019-08-15', 'In processing', 15, 5),
('2019-08-26', 'In processing', 35, 2),
('2019-09-05', 'Not started', 70, 1),
('2019-09-11', 'In processing', 7, 3),
('2016-11-02', 'Finished', 16, 7);


INSERT INTO Tailors(Tailor_Name, Tailor_Age, Finished_Orders, Order_Id)
VALUES
('Gosho', 20, 2,5),
('Petr', 3, 5,2),
('Sashka', 40, 30,1),
('Ivan', 27, 6,5),
('Maria', 34, 39,7),
('Martin', 22, 31,2),
('Gogo', 52, 14,1),
('Beni', 40, 26,4);


/* 
II. Create the following requests, transactions, and stored procedures

Select all orders for the selected day.
*/

GO
SELECT * FROM Orders
WHERE CONVERT(DATE, Order_Date) = ('2017-06-15');


/* Select all servises in the sewing workshop, sorted by price of services in descending order*/

GO 
SELECT Service_Name, Service_Price 
FROM Services
ORDER BY Service_Price DESC;


/* Select all orders not searched on time.*/

GO
SELECT * FROM Orders
WHERE (DATEDIFF(day, CAST(GETDATE() As date), Order_Date)) > Order_Term
AND Order_Status = 'Finished';


/* Create a query to select all orders that must be completed in one to three days */

GO
SELECT * 
FROM Orders AS o 
JOIN Services AS s ON o.Service_Id = s.Service_Id
WHERE s.Necessary_Time_In_Hours < 24       --24 because, one working day have 8 hours
AND o.Order_Status = 'In processing';


/* Decrease the price of the selected service by ten percent */

GO
UPDATE Services
SET Service_Price = Service_Price - Service_Price*0.1
WHERE Service_Name = 'Altering a leather jacket';

/* Select information for the work of a tailor in the workshop */

GO
SELECT TOP(1) * 
FROM Tailors;

GO
SELECT TOP(1) Finished_Orders 
FROM Tailors;


/* Select a average price of services in sewing workshop. */

GO
SELECT AVG(Service_Price) AS AVG_Price_Of_Services
FROM Services;


/* Select all completed orders and sum the total price of all services. */

GO
SELECT o.Order_Date, s.Service_Name
FROM Orders o
INNER JOIN Services s
ON o.Service_Id = s.Service_Id
WHERE o.Order_Status = 'Finished';

GO
SELECT SUM(Service_Price) AS Total_Sum
FROM Services s
INNER JOIN Orders o
ON o.Service_Id = s.Service_Id
WHERE o.Order_Status = 'Finished';


/* Select information about all the tailors and the number of tailors. */

GO
SELECT Tailor_Name, Tailor_Age
FROM Tailors;

GO
SELECT COUNT(Tailor_Id) AS Number_Of_Tailors
FROM Tailors;


/* Make a transaction that increases by X% two different services,
offered by the sewing studio. Confirm the transaction. */

GO
BEGIN TRANSACTION;
UPDATE Services 
SET Service_Price = Service_Price + Service_Price*0.5
WHERE Service_Name = 'Restitching a frayed seam' 
AND Service_Name = 'Hemming a dress';
COMMIT;


/* Create a stored procedure to updating data for a selected order. */

GO
CREATE SCHEMA Sewing_Workshop;

GO
CREATE PROCEDURE Sewing_Workshop.USP_Modificate_Order
@id int, @new_date DATE, @order_stat varchar(50), @term varchar(50), @service_code int
AS 
UPDATE Orders
SET Order_Status = @order_stat,
	Order_Date = @new_date,
	Order_Term = @term,
    Service_Id = @service_code
WHERE Order_Id = @id;

GO
EXEC Sewing_Workshop.USP_Modificate_Order @id = 1, @new_date = '2019-06-15', @order_stat = 'Not Started', @term = 20, @service_code = 2;
