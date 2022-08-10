/* Schema:

Highschooler (ID, name, grade)
English: There is a high school student with unique ID and a given first name in a certain grade.

Friend (ID1, ID2)
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).

Likes (ID1, ID2)
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. */

-- Q1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
DELETE FROM Highschooler
WHERE grade = 12;

-- Q2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
DELETE FROM Likes
WHERE ID1 IN (SELECT Likes.ID1 FROM Friend F INNER JOIN Likes ON F.ID1 = Likes.ID1 AND F.ID2 = Likes.ID2) AND ID2 NOT IN (SELECT Likes.ID1 FROM Friend F INNER JOIN Likes ON F.ID1 = Likes.ID1 AND F.ID2 = Likes.ID2);
