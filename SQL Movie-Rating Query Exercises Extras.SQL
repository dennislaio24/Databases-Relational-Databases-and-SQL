/* Schema:

Movie (mID, title, year, director)
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer (rID, name)
English: The reviewer with ID number rID has a certain name.

Rating (rID, mID, stars, ratingDate)
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. */

-- Q1. Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT name
FROM Movie M, Reviewer V, Rating R
WHERE M.mID = R.mID AND V.rID = R.rID AND title = 'Gone with the Wind';

-- Q2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
SELECT name, title, stars
FROM Movie M, Reviewer V, Rating R
WHERE M.mID = R.mID AND V.rID = R.rID AND name = director;

-- Q3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
SELECT name FROM reviewer
UNION
SELECT title FROM Movie;

-- Q4. Find the titles of all movies not reviewed by Chris Jackson.
SELECT title FROM Movie
EXCEPT
SELECT title FROM Movie M, Reviewer V, Rating R WHERE M.mID = R.mID AND V.rID = R.rID AND name = 'Chris Jackson';

-- Q5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
SELECT V1.name, V2.name
FROM Reviewer V1, Reviewer V2, Rating R1, Rating R2
WHERE R1.mID = R2.mID AND R1.rID = V1.rID AND R2.rID = V2.rID AND V1.name < V2.name
GROUP BY V1.name, V2.name;

-- Q7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
SELECT title, AVG(stars) AS average
FROM Movie
INNER JOIN Rating USING(mId)
GROUP BY mId
ORDER BY average DESC, title;
