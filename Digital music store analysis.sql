Select first_name, last_name, title from employee
order by levels desc
limit 1

select count(*), billing_country from invoice
group by billing_country
order by count(*) desc


select total from invoice
order by total desc
limit 3

select billing_city, Sum(total) from invoice
group by billing_city
order by Sum(total) desc
limit 1

select First_name, last_name, cus.customer_id, sum(total) as total_ from customer cus
inner join invoice inv
on cus.customer_id = inv.customer_id
group by cus.customer_id
order by sum(total) desc
limit 1





Intermediate - 

--write a query to return email, fist name and last name and genre
-- of all rock music listeners, return your list ordered alphabetically by email 
-- starting with A

select distinct (email), first_name, last_name, genre.name from customer
inner join invoice
on customer.customer_id = invoice.customer_id
inner join invoice_line
on invoice.invoice_id = invoice_line.invoice_id
inner join track
on track.track_id = invoice_line.track_id
inner join genre
on genre.genre_id = track.genre_id
where genre.name = 'Rock'
order by email 

----Lets invite the artist who has written the most rock music. write a query
---that returns artist name and total track count of top 10 rock bands

select * from artist
select * from track

select artist.name, count(track_id) from album 
inner join artist 
on artist.artist_id = album.artist_id
inner join track 
on track.album_id = album.album_id
inner join genre
on genre.genre_id = track.genre_id
where genre.name = 'Rock'
group by artist.name
order by count(track_id) desc
limit 10


---return all the track names that have the song length longer than the average 
---song length return the name and milliseconds for each track

select name, milliseconds from Track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc


Advanced 

---find how much amount spent by each customer on artist, write a query to return
---customer name, artist name and total spent.
with best_selling_artist as(
select artist.artist_id as artist_id, artist.name as artist_name, 
   Sum(invoice_line.unit_price * invoice_line.quantity) as total_sales
	from invoice_line
	inner join track 
	on invoice_line.track_id = track.track_id
	inner join album
	on track.album_id = album.album_id
	inner join artist
	on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
Sum(il.unit_price * il.quantity) as amount_spent from invoice
inner join customer c
on invoice.customer_id = c.customer_id
inner join invoice_line il
on invoice.invoice_id = il.invoice_id
inner join track
on il.track_id = track.track_id
inner join album 
on track.album_id = album.album_id
inner join best_selling_artist bsa
on album.artist_id = bsa.artist_id
group by 1,2,3,4
order by 5 desc


--we want to find out the most popular music genre for each country.
--we determine the most popular genre as the genre with the highest amount 
--of purchases. write a query that returns each country along with the the top 
--genre. for countries where the maximum number of purchases is shared return all 
--genres.

with popular_genre as
(
select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as Rowno
from invoice_line
join invoice on invoice_line.invoice_id = invoice.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 2,3,4
order by 2 asc, 1 desc
)

select * from popular_genre where rowno <=1


