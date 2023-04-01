-- 1. Find how much amount spent by each customer on artists? 
-- Write a query to return customer name, artist name and total spent


With cte1 as
(
	SELECT 
		a.name, a.artist_id,
		sum(inv_line.quantity*inv_line.unit_price) as total_spent_by_customer
	FROM artist a 
	JOIN album 
		USING (artist_id)
	JOIN track t
		ON t.album_id=album.album_id
	JOIN invoice_line inv_line
		ON inv_line.track_id=t.track_id
	
	GROUP BY a.name,a.artist_id
	ORDER BY total_spent_by_customer desc
	LIMIT 1
)

SELECT 
	c.customer_id, c.first_name, c.last_name,
	cte1.name as artist_name, 
	sum(inv_line.quantity*inv_line.unit_price) as total_spent_by_customer
FROM customer c
JOIN invoice inv
	ON inv.customer_id = c.customer_id
JOIN invoice_line inv_line
	ON inv_line.invoice_id = inv.invoice_id
JOIN track t
	ON t.track_id = inv_line.track_id
JOIN album alb
	ON alb.album_id = t.album_id
JOIN cte1
	ON cte1.artist_id=alb.artist_id
GROUP BY 1,4	
ORDER BY total_spent_by_customer desc;

/*

2. We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre with the highest amount of purchases. 
Write a query that returns each country along with the top Genre. 
For countries where the maximum number of purchases is shared return all Genres 

*/
With country_with_totalPurchase as(
	select 
		c.country as country, 
		g.name,
		sum(inl.quantity) as total_purchase
	from customer c
	join invoice i
		using(customer_id)
	join invoice_line inl
		on inl.invoice_id=i.invoice_id
	join track t
		on t.track_id=inl.track_id
	join genre g
		on g.genre_id=t.genre_id
	group by c.country,g.genre_id
	order by total_purchase desc
),
tatalPurchase_with_rowNumber as (
	select 
	*,
	row_number() over(partition by country order by total_purchase desc) as rowNumber
from country_with_totalPurchase
)

select * from tatalPurchase_with_rowNumber
where rowNumber =1;

/*

Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount

*/
with totalSpent_by_customer as (
	select 
		c.country,c.customer_id,c.first_name,c.last_name,
		sum(i.total) as total_amount
	from customer c
	join invoice i
		using(customer_id)
	group by c.country,c.customer_id
	order by total_amount desc
),
denseRank_num as(
	select 
		*,
		dense_rank() over(partition by country order by total_amount desc ) as DenseRankNum
	from totalSpent_by_customer
)
select * from denseRank_num
where DenseRankNum = 1;



