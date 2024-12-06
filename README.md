# NETFLIX-SQL-PROJECTS

![Netflix Logo](https://github.com/SaiKumarGunti08/NETFLIX-SQL-PROJECTS/blob/main/netflix%20image.jpg)

Data Set : Netflix Movies And TV Shows
Source : Kaggel
Software : PostgreSQL Workbench (PGAdmin 4)

## Project Overview :
The project demonstrates proficiency in SQL through analysis of a Netflix dataset. It includes queries to extract insights, perform aggregations, and apply advanced SQL features. This work showcases the ability to solve business problems using data.

```
### 1. Total count of rows
```sql 
SELECT COUNT(*) FROM netflix;
```

### 2. Find the type of content
```sql
SELECT DISTINCT type_of_content FROM netflix;
```

### 3. Count of each content type
```sql
SELECT type_of_content, COUNT(type_of_content) AS count_of_content
FROM netflix
GROUP BY type_of_content;
```

### 4. Find the most common rating for movies and TV shows
```sql
SELECT type_of_content, rating
FROM (
    SELECT type_of_content, rating, COUNT(*),
           RANK() OVER (PARTITION BY type_of_content ORDER BY COUNT(rating) DESC) AS ranking
    FROM netflix
    GROUP BY type_of_content, rating
) AS T1
WHERE ranking = 1;
```

### 5. List all the movies released in a specific year (e.g., 2020)
```sql
SELECT title, release_year
FROM netflix
WHERE type_of_content = 'Movie' AND release_year = 2020;
```

### 6. Top 5 countries with the most content
```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS new_countries, 
       COUNT(show_id) AS count_content
FROM netflix
GROUP BY new_countries
ORDER BY count_content DESC
LIMIT 5;
```

### 7. Longest-duration movies
```sql
SELECT type_of_content, duration
FROM netflix
WHERE type_of_content = 'Movie' AND 
      duration = (SELECT MAX(duration) FROM netflix);
```
### 8. Content added in the last 5 years
```sql
SELECT type_of_content, title, date_added
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
``` 
### 9. Content directed by a specific director (e.g., Rajiv Chilaka)

```sql
SELECT title, type_of_content, director
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```
### 10. TV shows with 5 or more seasons
```sql
SELECT type_of_content, duration
FROM netflix
WHERE type_of_content = 'TV Show' AND 
      SPLIT_PART(duration, ' ', 1)::NUMERIC >= 5;
```
### 11. Count of content in each genre
```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre, 
       COUNT(show_id) AS count_of_content
FROM netflix
GROUP BY genre
ORDER BY count_of_content DESC;
```
### 12. Average number of content releases by India for each year
```sql
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year, 
       COUNT(*) AS content_count,
       ROUND(AVG(COUNT(*)) OVER (PARTITION BY EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY'))), 2) AS avg_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY year
ORDER BY year DESC;
```
### 13. Movies that are documentaries
```sql
SELECT title, listed_in
FROM netflix
WHERE listed_in ILIKE '%Documentaries%' AND type_of_content = 'Movie';
```
### 14. Null values in the "director" column
```sql
SELECT title, type_of_content, director
FROM netflix
WHERE director IS NULL;
```
### 15. Movies Salman Khan acted in over the last 10 years
```sql
SELECT title, release_year
FROM netflix
WHERE casts ILIKE '%Salman Khan%' AND 
      release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
### 16. Actor appearing in the most movies
```sql
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor, 
       COUNT(show_id) AS movie_count
FROM netflix
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 1;
```
### 17. Classify films as "bad content" or "good content"
```sql
SELECT title, description, 
       CASE 
           WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'BAD_CONTENT'
           ELSE 'GOOD_CONTENT'
       END AS content_type
FROM netflix;
```
```
