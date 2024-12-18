INSERT INTO `SELECT s.*, od.Quantity 
FROM ecommerce.Suppliers s 
JOIN ecommerce.Products p ON s.SupplierID = p.SupplierID 
JOIN ecommerce.OrderDetails od ON p.ProductID = od.ProductID
ORDER BY (od.Quantity) DESC
LIMIT 1` (SupplierName,ContactName,Country,Quantity) VALUES
	 ('Mayumi''s','Mayumi Ohno','Japan',30);
