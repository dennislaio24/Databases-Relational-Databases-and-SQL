/* Schema:

Movie (mID, title, year, director)
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer (rID, name)
English: The reviewer with ID number rID has a certain name.

Rating (rID, mID, stars, ratingDate)
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. */

-- Q1. Find the titles of all movies directed by Steven Spielberg.
SELECT title
FROM Movie
WHERE director = 'Steven Spielberg';

-- Q2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT year
FROM Movie
WHERE year IN (SELECT year FROM Movie M, Rating R WHERE M.mID = R.mID AND stars IN (4, 5))
ORDER BY year;

-- Q3. Find the titles of all movies that have no ratings.
SELECT title FROM Movie
EXCEPT
SELECT title FROM Movie M, Rating R WHERE M.mID = R.mI;

-- Q4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
SELECT name
FROM Reviewer V, Rating R
WHERE V.rID IN (SELECT rID FROM Rating WHERE ratingDate IS NULL);

-- Q5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
SELECT name AS 'reviewer name', title AS 'movie title', stars, ratingDate
FROM Movie M, Reviewer V, Rating R
WHERE M.mID = R.mID AND V.rID = R.rID
ORDER BY name, title, stars;

-- Q6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.
SELECT name, title
FROM Movie
INNER JOIN Rating R1 USING(mID)
INNER JOIN Rating R2 USING(rID)
INNER JOIN Reviewer USING(rID)
WHERE R1.mID = R2.mID AND R1.ratingDate < R2.RatingDate AND R1.stars < R2.stars;

-- Q7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
SELECT title, MAX(stars)
FROM Movie M, Rating R
WHERE M.mID = R.mID
GROUP BY title;

-- Q8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
SELECT title, MAX(stars) - MIN(stars) AS 'rating spread'
FROM Movie M, Rating R
WHERE M.mID = R.mID
GROUP BY title
ORDER BY MAX(stars) - MIN (stars) DESC, title;

-- Q9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
SELECT AVG(Pre1980) - AVG(Pos1980)
FROM
	(SELECT AVG(stars) AS Pre1980 FROM Movie M, Rating R WHERE M.mID = R.mID AND year < 1980 GROUP BY title),
	(SELECT AVG(stars) AS Pos1980 FROM Movie M, Rating R WHERE M.mID = R.mID AND year > 1980 GROUP BY title);
