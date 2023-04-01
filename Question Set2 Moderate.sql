-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A


SELECT distinct
	c.email, c.first_name,c.last_name
FROM customer c
JOIN invoice 
	USING (customer_id)
JOIN invoice_line invL
	on invL.invoice_id=invoice.invoice_id
WHERE track_id IN
	(	
		SELECT track_id FROM track
		JOIN genre 
			USING(genre_id)
		WHERE genre.name like 'Rock'
	)
ORDER BY c.email;	


-- 2. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands

SELECT 
	artist.name, count(a.album_id) as track_count
FROM artist
JOIN album a
	USING (artist_id)
JOIN track t
	ON t.album_id = a.album_id
WHERE t.track_id IN
	(
		SELECT track_id FROM track
		JOIN genre g
			USING (genre_id)
		WHERE g.name like 'Rock'
	)
GROUP BY artist.name	
ORDER BY track_count desc
LIMIT 10;	


-- 3. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. 
-- Order by the song length with the longest songs listed first


SELECT 
	track.name, milliseconds 
FROM track
WHERE milliseconds >(SELECT avg(milliseconds) FROM track)
ORDER BY milliseconds desc;
