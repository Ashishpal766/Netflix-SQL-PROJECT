-- Netflix Project 
CREATE TABLE netflix
(
	show_id VARCHAR(7),
	
	type VARCHAR(20),
	
	title VARCHAR(180),
	
	director VARCHAR(250),
	
	casts VARCHAR(1050),
	
	country VARCHAR(600),
	
	date_added VARCHAR(60),
	
	release_year INT,
	
	rating VARCHAR(20),
	
	duration VARCHAR(20),
	
	listed_in VARCHAR(300),
	
	description VARCHAR(600)
)

SELECT * FROM netflix;

SELECT COUNT(*) AS "Total_count" FROM netflix;

-- UNIQUE TYPES OF MOVIES 
SELECT DISTINCT(type)  AS "types of movies"
FROM netflix;

-- Unique country

SELECT country,
	COUNT(*) AS "Total country"
	FROM netflix
	GROUP BY country


-- 1. Count the number of movies and tv shows
SELECT type,
	COUNT(*) as "No of Movies and Tv shows"
	FROM netflix
	GROUP BY type


-- 2. Find the most common rating for movies and Tv shows
 
SELECT 
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) As "Ranking"
FROM netflix
GROUP BY 1,2


-- 3. List all movies released in a specific year(e.g., 2020)

SELECT * FROM netflix
WHERE type = 'Movie' AND release_year =2020


-- 4. Find the top 5 countries with the  most content on Netflix

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) AS "New Country",
	COUNT(show_id) AS "Total_content"
FROM netflix
GROUP BY 1
ORDER BY 2 DESC LIMIT 5



-- 5. Find the longest movies

SELECT * FROM netflix
WHERE
	type ='Movie'
	AND 
	duration =(SELECT MAX(duration) FROM netflix)


-- 6. Find the content added in the last 5 years 

SELECT * FROM netflix
WHERE
	TO_DATE(date_added,'Month, DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

	
-- 7. Find all the movies / TV shows by directed "Rajiv Chilaka"

SELECT * FROM netflix
WHERE director = 'Rajiv Chilaka'




-- 8. List all TV shows with more than 5 seasons

SELECT
	 *
	-- SPLIT_PART(duration, ' ', 1) AS sessions
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1):: numeric >5 



-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1


-- 10. -- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !
SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5



-- 11.  List all movies that are Documentaries

SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	listed_in = 'Documentaries'




-- 12. Find all content without a director

SELECT * FROM netflix
WHERE director IS NULL



-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND 
	release_year >EXTRACT(YEAR FROM  CURRENT_DATE) - 10





-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


WITH new_table
AS
(
SELECT
*,
	CASE 
	WHEN 
	description ILIKE '%kill%'
	OR 
	description ILIKE '%violence%' THEN 'Bad_Content'
	ELSE 'Good_Content'
	END category
FROM netflix
)
SELECT
	category,
	COUNT(*) AS Total_Content
FROM new_table
GROUP BY 1





	
