CREATE DATABASE ecommerce;
USE ecommerce;
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    Country VARCHAR(50)
);

-- Tạo bảng Suppliers
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactName VARCHAR(100),
    Country VARCHAR(50)
);

-- Tạo bảng Categories
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100)
);

-- Tạo bảng Products với các khóa ngoại
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    Unit VARCHAR(50),
    Price DECIMAL(10, 2),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Tạo bảng Orders với khóa ngoại
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    ShipperID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Tạo bảng OrderDetails với các khóa ngoại
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers (CustomerName, ContactName, Country)
VALUES
('Around the Horn', 'Thomas Hardy', 'UK'),
('Berglunds snabbköp', 'Christina Berglund', 'Sweden'),
('Blauer See Delikatessen', 'Hanna Moos', 'Germany'),
('Blondel père et fils', 'Frédérique Citeaux', 'France'),
('Bólido Comidas preparadas', 'Martín Sommer', 'Spain'),
('Bon app''', 'Laurence Lebihan', 'France'),
('Bottom-Dollar Markets', 'Elizabeth Lincoln', 'Canada'),
('Cactus Comidas para llevar', 'Patricio Simpson', 'Argentina'),
('Centro comercial Moctezuma', 'Francisco Chang', 'Mexico'),
('Chop-suey Chinese', 'Yang Wang', 'Switzerland');

INSERT INTO Suppliers (SupplierName, ContactName, Country)
VALUES
('Grandma Kelly''s Homestead', 'Regina Murphy', 'USA'),
('Tokyo Traders', 'Yoshi Nagase', 'Japan'),
('Cooperativa de Quesos ''Las Cabras''', 'Antonio del Valle Saavedra', 'Spain'),
('Mayumi''s', 'Mayumi Ohno', 'Japan'),
('Pavlova, Ltd.', 'Ian Devling', 'Australia'),
('Specialty Biscuits, Ltd.', 'Peter Wilson', 'UK'),
('PB Knäckebröd AB', 'Lars Peterson', 'Sweden'),
('Refrescos Americanas LTDA', 'Carlos Diaz', 'Brazil'),
('Heli Süßwaren GmbH & Co. KG', 'Petra Winkler', 'Germany'),
('Plutzer Lebensmittelgroßmärkte AG', 'Martin Bein', 'Germany');


INSERT INTO Products (ProductName, SupplierID, CategoryID, Unit, Price)
VALUES
('Chef Anton''s Cajun Seasoning', 2, 2, '48 - 6 oz jars', 22.00),
('Chef Anton''s Gumbo Mix', 2, 2, '36 boxes', 21.35),
('Grandma''s Boysenberry Spread', 3, 2, '12 - 8 oz jars', 25.00),
('Uncle Bob''s Organic Dried Pears', 3, 7, '12 - 1 lb pkgs.', 30.00),
('Northwoods Cranberry Sauce', 3, 2, '12 - 12 oz jars', 40.00),
('Mishi Kobe Niku', 4, 6, '18 - 500 g pkgs.', 97.00),
('Ikura', 4, 8, '12 - 200 ml jars', 31.00),
('Queso Cabrales', 5, 4, '1 kg pkg.', 21.00),
('Queso Manchego La Pastora', 5, 4, '10 - 500 g pkgs.', 38.00),
('Konbu', 6, 8, '2 kg box', 6.00);

INSERT INTO Orders (CustomerID, OrderDate, ShipperID)
VALUES
(4, '2024-05-20', 3),
(5, '2024-05-21', 2),
(6, '2024-05-22', 1),
(7, '2024-05-23', 2),
(8, '2024-05-24', 3),
(9, '2024-05-25', 1),
(10, '2024-05-26', 2),
(1, '2024-05-27', 3),
(2, '2024-05-28', 1),
(3, '2024-05-29', 2);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES
(1, 1, 10),
(1, 2, 5),
(2, 3, 20),
(3, 4, 15),
(4, 5, 12),
(5, 6, 8),
(6, 7, 30),
(7, 8, 25),
(8, 9, 18),
(9, 10, 7);

INSERT INTO Categories (CategoryID ,CategoryName)
VALUES
(1, 'Grains/Cereals'),
(2, 'Condiments'),
(3, 'Confections'),
(4, 'Dairy Products'),
(5, 'Seafood'),
(6, 'Beverages'),
(7, 'Produce'),
(8, 'Meat/Poultry');

#Question 1: Display product names and supplier names for all products with price >15.00
SELECT p.ProductName, s.SupplierName, p.Price 
FROM Products p 
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE p.Price >15;
#Question 2:Find orders by customers at Mexico
SELECT o.OrderID, c.CustomerName , c.CustomerID 
FROM Orders o
JOIN Customers c ON o.CustomerID =c.CustomerID
WHERE c.Country LIKE 'Mexico';
#Question 3: Find oders are fulfilled by countries
SELECT Or , COUNT(o.OrderID)
FROM Customers c 
JOIN Orders o ON c.CustomerID =o.CustomerID
GROUP BY c.Country ;
#Question 4:
SELECT s.SupplierName, SUM(od.quantity)  
FROM Suppliers s
JOIN Products p ON s.SupplierID =p.SupplierID 
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY s.SupplierName;
#Question 5: Display product name and products price higher  product name "Chang"?
SELECT p.* 
FROM Products p
HAVING  p.Price >  (
	SELECT p2.Price
	FROM Products p2
	WHERE p2.ProductName LIKE '%Chang%'
);
#Question 6:Find total quantity sell out in 2024 year
SELECT SUM(od.Quantity) total_quantity
FROM OrderDetails od 
JOIN Orders o ON od.OrderID = o.OrderID 
WHERE o.OrderDate >= '2024-05-01' AND o.OrderDate < '2024-06-01';
#Question 7: Find customers name don't have order
WITH CustomerNull AS(
	SELECT DISTINCT o.CustomerID 
	FROM Orders o
)
SELECT *
FROM Customers c
LEFT JOIN  CustomerNull cn ON c.CustomerID = cn.CustomerID
WHERE cn.CustomerID IS NULL; 
#Question 8: Display orders with price total > 200
SELECT o.*, (od.Quantity * p.Price) price_total
FROM Orders o 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
JOIN Products p ON od.ProductID =p.ProductID
WHERE od.Quantity * p.Price > 200;
#Question 9: Find product name and AVG quantity by order per order
WITH OrderQuantity AS (
	SELECT od2.OrderID, AVG(od2.quantity) quantity_avg
	FROM OrderDetails od2
	GROUP BY od2.OrderID
)
SELECT p.ProductName, oq.quantity_avg
FROM OrderDetails od 
JOIN Products p ON od.ProductID = p.ProductID 
JOIN OrderQuantity oq ON od.OrderID = oq.OrderID;
#Question 10: Find customer with the highest order price
SELECT c.CustomerName, SUM(p.Price * od.Quantity) total_sum
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID 
JOIN Products p ON p.ProductID = od.ProductID 
GROUP BY c.CustomerName
ORDER BY total_sum DESC
LIMIT 1;
#Question 11: Find order with the highest total price in top 10
SELECT od.OrderID , SUM(p.Price * od.Quantity) total_sum
FROM OrderDetails od 
JOIN Products p ON p.ProductID = od.ProductID 
GROUP BY od.OrderID
ORDER BY total_sum DESC
LIMIT 10;
#Question 12: 
WITH OrderCOUNT AS(
	SELECT COUNT(c2.CustomerID) quantity_count
	FROM Customers c2 
	JOIN Orders o2 ON c2.CustomerID = o2.CustomerID
	GROUP BY c2.CustomerName
),
OrderAVG AS (
	SELECT AVG(oc.quantity_count) quantity_avg
	FROM OrderCOUNT oc
)
SELECT c.CustomerName, COUNT(*) order_count
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerName
HAVING order_count > (SELECT * FROM OrderAVG);
#Question 13: 
WITH OrderSUM AS(
	SELECT SUM(p2.Price * od2.Quantity) order_sum
	FROM OrderDetails od2
	JOIN Products p2 ON od2.ProductID = p2.ProductID
	GROUP BY od2.OrderID
),
TotalAVG AS(
	SELECT AVG(os.order_sum)
	FROM OrderSUM os
)

SELECT p.ProductName, (p.Price * od.Quantity)  order_total
FROM Products p 
JOIN OrderDetails od ON p.ProductID = od.ProductID
HAVING order_total > (SELECT * FROM TotalAVG);
#Question 14: 
WITH checked AS (
	SELECT c2.CustomerID, c2.Country
	FROM Customers c2
	HAVING c2.Country NOT LIKE 'UK'
)
SELECT p.ProductID, p.ProductName
FROM ecommerce.Products p 
JOIN ecommerce.OrderDetails od ON od.ProductID = p.ProductID
JOIN ecommerce.Orders o ON od.OrderID = o.OrderID
JOIN checked c ON c.CustomerID = o.CustomerID;
#Question 15:
SELECT s.*, od.Quantity 
FROM ecommerce.Suppliers s 
JOIN ecommerce.Products p ON s.SupplierID = p.SupplierID 
JOIN ecommerce.OrderDetails od ON p.ProductID = od.ProductID
ORDER BY (od.Quantity) DESC
LIMIT 1;
