/* Schema:

Highschooler (ID, name, grade)
English: There is a high school student with unique ID and a given first name in a certain grade.

Friend (ID1, ID2)
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).

Likes (ID1, ID2)
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. */

-- Q1. Find the names of all students who are friends with someone named Gabriel.
SELECT H1.name
FROM Highschooler H1
INNER JOIN Friend ON H1.ID = Friend.ID1
INNER JOIN Highschooler H2 ON H2.ID = Friend.ID2
WHERE H2.name = 'Gabriel';

-- Q2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
INNER JOIN Likes ON H1.ID = Likes.ID1
INNER JOIN Highschooler H2 ON H2.ID = Likes.ID2
WHERE (H1.grade - H2.grade) >= 2;

-- Q3. For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2, Likes L1, Likes L2
WHERE (H1.ID = L1.ID1 AND H2.ID = L1.ID2) AND (H2.ID = L2.ID1 AND H1.ID = L2.ID2) AND H1.name < H2.name
ORDER BY H1.name, H2.name;

-- Q4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
SELECT name, grade
FROM Highschooler
WHERE ID NOT IN (SELECT DISTINCT ID1 FROM Likes UNION SELECT DISTINCT ID2 FROM Likes);

-- Q5. For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2, Likes
WHERE (H1.ID = Likes.ID1 AND H2.ID = Likes.ID2) AND H2.ID NOT IN (SELECT DISTINCT ID1 FROM Likes);

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
INNER JOIN Likes ON H1.ID = Likes.ID1
INNER JOIN Highschooler H2 ON H2.ID = Likes.ID2
WHERE H2.ID NOT IN (SELECT ID1 FROM Likes);

-- Q6. Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.
SELECT name, grade
FROM Highschooler H1
WHERE ID NOT IN (SELECT ID1 FROM Friend INNER JOIN Highschooler H1 ON ID1 = H1.ID INNER JOIN Highschooler H2 ON ID2 = H2.ID WHERE H1.grade <> H2.grade)
ORDER BY grade, name;

-- Q7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.
SELECT DISTINCT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Likes L, Friend F1, Friend F2
WHERE (H1.ID = L.ID1 AND H2.ID = L.ID2) AND H2.ID NOT IN (SELECT ID2 FROM Friend WHERE ID1 = H1.ID) AND (H1.ID = F1.ID1 AND H3.ID = F1.ID2) AND (H2.ID = F2.ID1 AND H3.ID = F2.ID2);

SELECT DISTINCT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1
INNER JOIN Likes L ON H1.ID = L.ID1
INNER JOIN Highschooler H2 ON H2.ID = L.ID2
INNER JOIN Friend F1 ON H1.ID = F1.ID1
INNER JOIN Highschooler H3 ON H3.ID = F1.ID2 AND H3.ID = F2.ID2
INNER JOIN Friend F2 ON H2.ID = F2.ID1
WHERE H2.ID NOT IN (SELECT ID2 FROM Friend WHERE ID1 = H1.ID);

-- Q8. Find the difference between the number of students in the school and the number of different first names.
SELECT COUNT(*) - COUNT(DISTINCT name)
FROM Highschooler;

-- Q9. Find the name and grade of all students who are liked by more than one other student.
SELECT name, grade
FROM Highschooler H1
INNER JOIN Likes ON H1.ID = Likes.ID2
GROUP BY name
HAVING COUNT(name) > 1;

SELECT name, grade
FROM Highschooler H1, Likes
WHERE H1.ID = Likes.ID2
GROUP BY name
HAVING COUNT(name) > 1;
