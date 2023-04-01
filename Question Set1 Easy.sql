-- 1. Who is the senior most employee based on job title?

SELECT * FROM employee order by levels desc limit 1;


-- 2. Which countries have the most Invoices?

SELECT count(*) as cnt,
		billing_country
FROM invoice
GROUP BY billing_country
ORDER BY cnt desc;

-- 3. What are top 3 values of total invoice?

SELECT * FROM invoice ORDER BY total desc LIMIT 3;

-- 4. Which city has the best customers? 
-- We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals

SELECT 
	billing_city, 
	sum(total) as total_bill_per_city
FROM invoice 
GROUP BY billing_city
ORDER BY total_bill_per_city desc
LIMIT 1;
	
	
-- 5. Who is the best customer? 
-- The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money	


SELECT 
	c.customer_id,
	c.first_name, c.last_name, 
	sum(inv.total) as total_invoice_by_customer
FROM invoice inv
JOIN customer c  
	ON inv.customer_id=c.customer_id
GROUP BY c.customer_id
ORDER BY total_invoice_by_customer desc
LIMIT 1;







	

