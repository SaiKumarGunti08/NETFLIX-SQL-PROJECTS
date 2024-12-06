SELECT * FROM netflix;
-- Business Problems

-- 1.Total Contant OF ROWS

SELECT COUNT(*) FROM netflix; 

-- 2.FIND THE TYPE OF CONTENT 
-- 2 METHODS

SELECT type_of_content
FROM netflix
GROUP BY type_of_content;

SELECT DISTINCT(type_of_content)
FROM netflix;

-- 3.COUNT OF EACH CONTENT

SELECT type_of_content,COUNT(type_of_content) count_of_content
FROM netflix
GROUP BY type_of_content;

-- 4.FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOWS
SELECT 
	type_of_content,
	rating
FROM
(
SELECT
	type_of_content,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type_of_content ORDER BY COUNT(rating) DESC ) AS ranking
FROM netflix
GROUP BY 1,2) AS T1
WHERE
	ranking=1;

-- 5.LIST ALL THE MOVIES REALESED IN A SPECIFIC YEAR(eg.2020)

SELECT * FROM netflix;

SELECT 
	type_of_content,
	title,
	release_year
FROM netflix
WHERE type_of_content='Movie'
		AND release_year = 2020;

-- 6.FIND THE TOP 5 COUNTRIES WITH MOST CONTENT ON NETFLIX

SELECT * FROM netflix;

SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(country,','))) new_countries,
	COUNT(show_id) count_content
FROM netflix
GROUP BY new_countries
ORDER BY count_content DESC
LIMIT 5;

-- 7.FIND THE LONGEST DURATION MOVIES

SELECT 
	type_of_content,
	duration
FROM netflix
WHERE type_of_content='Movie'
	AND duration=(SELECT MAX(duration) FROM netflix);


-- 8.FIND THE CONTENT ADDED IN LAST 5 YEARS

SELECT 
	type_of_content,
	title,
	date_added
FROM netflix
WHERE type_of_content='Movie' 
		AND TO_DATE(date_added,'Month DD,YYYY')>=CURRENT_DATE-INTERVAL '5 years';


-- 9.FIND THE CONTENT DIRECTED BY (DIRECTOR NAME) eg.Rajiv Chilaka
SELECT 
	title,
	type_of_content,
	director
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';


-- 10.FIND THE TV SHOWS HAVING SEASONS MORE or try equal THAT 5 SEASONS

SELECT type_of_content,duration
FROM netflix
WHERE type_of_content='TV Show'
	AND SPLIT_PART(duration,' ',1)::numeric >=5;

-- 11.FIND THE COUNT OF CONTENT IN EACH GENRE

SELECT * FROM netflix;

SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(listed_in,','))) genre,
	COUNT(show_id) count_of_content
FROM netflix
GROUP BY 1
ORDER BY 1;

-- 12.FIND EACH YEAR AND THE AVERAGE NUMBER OF CONTENT RELEASED BY INDIA IN NETFLIX

SELECT COUNT(show_id)
FROM netflix
WHERE release_year=2019;

SELECT release_year,COUNT(*)
FROM netflix
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY release_year  DESC;


SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS year,
	COUNT(*),
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India')::numeric * 100,2) Avg_content
FROM netflix
WHERE country='India'
GROUP BY 1;




--13.LIST ALL THE MOVIES THAT ARE DOCUMENTARIES
SELECT 
	title,
	listed_in
FROM netflix
WHERE listed_in ILIKE '%documentaries%'
	AND type_of_content='Movie';

-- 14.FIND NULL VALUE IN DIRECTOR COLUMN 

SELECT title,type_of_content,director
FROM netflix
WHERE director IS NULL;

-- 15.FIND HOW MANY MOVIES 'SALMAN KHAN' ACTED IN LAST 10 YEARS

-- On Date_Added

SELECT type_of_content,title,date_added 
FROM netflix
WHERE 
	casts ILIKE '%salman Khan%'
	AND 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY'))> EXTRACT(YEAR FROM CURRENT_DATE)-10
ORDER BY date_added;

-- release_date

SELECT type_of_content,title,casts,release_year 
FROM netflix
WHERE 
	casts ILIKE '%salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10
ORDER BY date_added;

-- 16.FIND THE ACTOR APPERED IN MOST NUMBER OF MOVIES

SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) actors,
	COUNT(show_id) movies_count
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY actors
ORDER BY movies_count DESC
LIMIT 10;

-- 17.FIND THE FILM WHICH HAS DESCRIPTION AS KILL OR VIOLANCE  IN IT THE CONSIDER IT AS BAD_CONTENT ELSE GOOD CONTENT.

SELECT type_of_content,title,description,
	CASE
		WHEN
			description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'BAD_CONTENT'
			ELSE 'GOOD_CONTENT'
		END CONTENT_TYPE
FROM netflix;


-- Finding the good and bad content.

WITH new_table
AS
(
SELECT type_of_content,title,description,
	CASE
		WHEN
			description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'BAD_CONTENT'
			ELSE 'GOOD_CONTENT'
		END CONTENT_TYPE
FROM netflix
)

SELECT 
	CONTENT_TYPE,
	COUNT(*) count_of_content
FROM new_table
GROUP BY CONTENT_TYPE
ORDER BY count_of_content DESC;
	