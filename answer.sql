-- Week 7 Assignment: Database Design and Normalization
-- Run this script in MySQL 8.0 or a compatible MySQL environment.

-- =========================================================
-- QUESTION 1: Achieving First Normal Form (1NF)
-- =========================================================
-- The original Products column stores multiple values in one cell.
-- In 1NF, each row contains exactly one product for an order.

DROP TABLE IF EXISTS ProductDetail_1NF;
DROP TABLE IF EXISTS ProductDetail;

CREATE TABLE ProductDetail (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Products VARCHAR(255) NOT NULL,
    PRIMARY KEY (OrderID)
);

INSERT INTO ProductDetail (OrderID, CustomerName, Products)
VALUES
    (101, 'John Doe', 'Laptop, Mouse'),
    (102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
    (103, 'Emily Clark', 'Phone');

CREATE TABLE ProductDetail_1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
VALUES
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');

-- Check the 1NF result: each row has one product.
SELECT OrderID, CustomerName, Product
FROM ProductDetail_1NF
ORDER BY OrderID, Product;


-- =========================================================
-- QUESTION 2: Achieving Second Normal Form (2NF)
-- =========================================================
-- Partial dependency:
-- CustomerName depends only on OrderID, which is part of the
-- composite key (OrderID, Product), not on the whole key.
-- Move CustomerName to Orders; keep Product and Quantity in
-- OrderItems, where the composite key identifies each order item.

DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderDetails;

-- Original 1NF table, included to show the supplied data.
CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity)
VALUES
    (101, 'John Doe', 'Laptop', 2),
    (101, 'John Doe', 'Mouse', 1),
    (102, 'Jane Smith', 'Tablet', 3),
    (102, 'Jane Smith', 'Keyboard', 1),
    (102, 'Jane Smith', 'Mouse', 2),
    (103, 'Emily Clark', 'Phone', 1);

-- Orders stores attributes that depend on OrderID alone.
CREATE TABLE Orders (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID)
);

-- OrderItems stores products and quantities for each order.
CREATE TABLE OrderItems (
    OrderID INT NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    CONSTRAINT fk_orderitems_orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders (OrderID)
);

INSERT INTO Orders (OrderID, CustomerName)
VALUES
    (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Emily Clark');

INSERT INTO OrderItems (OrderID, Product, Quantity)
VALUES
    (101, 'Laptop', 2),
    (101, 'Mouse', 1),
    (102, 'Tablet', 3),
    (102, 'Keyboard', 1),
    (102, 'Mouse', 2),
    (103, 'Phone', 1);

-- Check the normalized 2NF data.
SELECT
    o.OrderID,
    o.CustomerName,
    oi.Product,
    oi.Quantity
FROM Orders AS o
INNER JOIN OrderItems AS oi
    ON o.OrderID = oi.OrderID
ORDER BY o.OrderID, oi.Product;
