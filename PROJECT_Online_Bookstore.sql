-- Create Database
CREATE database Online_Bookstore


-- Switch to the database
--OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'D:\All Excel Practice Files\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'D:\All Excel Practice Files\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'D:\All Excel Practice Files\Orders.csv' 
CSV HEADER;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:
--METHOD-1
SELECT * FROM BOOKS
WHERE GENRE IN('Fiction')

--METHOD-2
SELECT * FROM BOOKS
WHERE GENRE='Fiction'

-- 2) Find books published after the year 1950:
SELECT * FROM BOOKS
WHERE PUBLISHED_YEAR>1950

-- 3) List all customers from the Canada:
SELECT * FROM Customers
WHERE COUNTRY='Canada'


-- 4) Show orders placed in November 2023:
SELECT * FROM ORDERS
WHERE ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30'

-- 5) Retrieve the total stock of books available:
SELECT SUM(STOCK) AS TOTAL_STOCK FROM BOOKS;

-- 6) Find the details of the most expensive book:

SELECT * FROM BOOKS ORDER BY PRICE DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM ORDERS
WHERE quantity>1

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM ORDERS
WHERE TOTAL_AMOUNT>20

-- 9) List all genres available in the Books table:
SELECT DISTINCT(GENRE) AS DISTINCT_GENRES FROM BOOKS


-- 10) Find the book with the lowest stock:
SELECT * FROM BOOKS ORDER BY STOCK ASC LIMIT 1; 


-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(TOTAL_AMOUNT) AS total_revenue FROM ORDERS;

-- Advance Questions : 

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve the total number of books sold for each genre:

SELECT *FROM ORDERS;
SELECT * FROM Books;

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id= b.book_id
GROUP BY b.Genre;



-- 2) Find the average price of books in the "Fantasy" genre:

SELECT avg(price) as avg_price FROM BOOKS
WHERE GENRE='Fantasy'

-- 3) List customers who have placed at least 2 orders:
SELECT * FROM Customers;
SELECT * FROM Orders;

--m1
SELECT customer_id, COUNT (Order_id) AS ORDER_COUNT
FROM orders
GROUP BY customer_id
HAVING COUNT(Order_id) >=2;

--m2
SELECT o.customer_id, c.name, COUNT (o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT (Order_id) >=2;


-- 4) Find the most frequently ordered book:
SELECT * FROM Orders;
SELECT * FROM Books;

--M-1
SELECT BOOK_ID ,COUNT(ORDER_ID) AS  NO_OF_TIMES_ORDERED
FROM ORDERS 
GROUP BY BOOK_ID
ORDER BY NO_OF_TIMES_ORDERED DESC
LIMIT 1

--M-2
SELECT B.BOOK_ID ,B.TITLE,COUNT(ORDER_ID) AS  NO_OF_TIMES_ORDERED
FROM ORDERS O
JOIN BOOKS B ON O.BOOK_ID=B.BOOK_ID
GROUP BY B.BOOK_ID,B.TITLE
ORDER BY NO_OF_TIMES_ORDERED DESC 
LIMIT 1


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM Books;

SELECT * FROM BOOKS
WHERE GENRE='Fantasy'
ORDER BY PRICE DESC 
LIMIT 3;



-- 6) Retrieve the total quantity of books sold by each author:
SELECT * FROM Books;
SELECT * FROM Orders;

SELECT B.AUTHOR,SUM(O.QUANTITY) AS total_quantity
FROM BOOKS B
JOIN ORDERS O ON B.BOOK_ID=O.BOOK_ID
GROUP BY B.AUTHOR;

-- 7) List the cities where customers who spent over $30 are located:
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT DISTINCT R.CITY,O.TOTAL_AMOUNT
FROM CUSTOMERS R JOIN ORDERS O ON R.CUSTOMER_ID=O.CUSTOMER_ID
WHERE O.TOTAL_AMOUNT>30

-- 8) Find the customer who spent the most on orders:
SELECT * FROM Customers;
SELECT * FROM Orders;

--M-1
SELECT O.CUSTOMER_ID,C.NAME,SUM(O.TOTAL_AMOUNT) AS SPENT_MOST
FROM ORDERS O 
JOIN CUSTOMERS C ON O.CUSTOMER_ID=C.CUSTOMER_ID
GROUP BY O.CUSTOMER_ID,C.NAME
ORDER BY SPENT_MOST DESC
LIMIT 1;

--M-2
SELECT C.CUSTOMER_ID,C.NAME,SUM(O.TOTAL_AMOUNT) AS SPENT_MOST
FROM ORDERS O 
JOIN CUSTOMERS C ON O.CUSTOMER_ID=C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY SPENT_MOST DESC
LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE (SUM (o.quantity), 8) AS Order_quantity,
b.stock- COALESCE (SUM (O.quantity), 0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;








