/* WORKBOOK * Classroom 4 */
DROP TABLE IF EXISTS student_exercise_2;

CREATE TABLE student_exercise_2 (
       roll_no NUMERIC(5) NOT NULL UNIQUE,
       name VARCHAR(30) NOT NULL DEFAULT 'No Name Defined',
       dept VARCHAR(5),
       mark_1 NUMERIC(3),
       mark_2 NUMERIC(3),
       mark_3 NUMERIC(3)
);

-- populate values
INSERT INTO
       student_exercise_2 (roll_no, dept, name, mark_1, mark_2, mark_3)
VALUES
       (1, 'CSE', 'AB', 49, 67, 90),
       (2, 'CSE', 'AB', 95, 70, 100),
       (3, 'CSE', 'BB', 55, 100, 91),
       (4, 'CSE', 'CA', 100, 100, 100),
       (5, 'CSE', 'DD', 100, 89, 83),
       (6, 'EEE', 'AD', 87, 67, 97),
       (7, 'EEE', 'AE', 35, 87, 86),
       (8, 'EEE', 'AF', 67, 74, 93),
       (9, 'EEE', 'AG', 58, 71, 59),
       (10, 'EEE', 'AH', 49, 71, 76),
       (11, 'IT', 'AI', 100, 86, 91),
       (12, 'IT', 'AJ', 66, 57, 100),
       (13, 'IT', 'AK', 87, 63, 80),
       (14, 'IT', 'B2', 74, 69, 84),
       (15, 'MECH', 'B4', 40, 100, 87),
       (16, 'MECH', 'B6', 93, 85, 73),
       (17, 'MECH', 'C8', 100, 91, 35),
       (18, 'MECH', 'A6', 38, 59, 90),
       (19, 'CSE', 'AB', 57, 74, 90),
       (20, 'CSE', 'A*', 71, 81, 90),
       (21, 'CSE', 'YY', 0, 0, NULL);

SELECT
       *
FROM
       student_exercise_2;

-- Aggregate Functions
SELECT
       count(*) AS count,
       avg(mark_1) AS mark_1_avg,
       avg(mark_2) AS mark_2_avg,
       avg(mark_3) AS mark_3_avg
FROM
       student_exercise_2;

SELECT
       min(mark_1) AS min_mark_1,
       max(mark_1) AS max_mark_1
FROM
       student_exercise_2;

-- distinct
SELECT
       DISTINCT dept
FROM
       student_exercise_2;

-- group by
-- Q. show average by department
SELECT
       dept,
       round(avg(mark_1), 2) AS mark_1_avg
FROM
       student_exercise_2
GROUP BY
       dept;

-- Q. show average of each subject for every dept
SELECT
       dept,
       round(avg(mark_1), 2) AS mark_1_avg,
       round(avg(mark_2), 2) AS mark_2_avg,
       round(avg(mark_3), 2) AS mark_3_avg
FROM
       student_exercise_2
GROUP BY
       dept;

-- Q. show average of each subject for every dept only passed students
SELECT
       dept,
       round(avg(mark_1), 2) AS mark_1_avg,
       round(avg(mark_2), 2) AS mark_2_avg,
       round(avg(mark_3), 2) AS mark_3_avg
FROM
       student_exercise_2
GROUP BY
       dept;

-- Q. show average of every subject --
-- where someone has scored a pass mark , also show the number of students passed.
SELECT
       dept,
       count(mark_1) AS mark_1_count,
       round(avg(mark_1), 2) AS mark_1_avg
FROM
       student_exercise_2
WHERE
       mark_1 >= 40
GROUP BY
       dept;

--all subjects
SELECT
       dept,
       count(mark_1) AS mark_1_count,
       count(mark_2) AS mark_2_count,
       count(mark_3) AS mark_3_count,
       round(avg(mark_1), 2) AS mark_1_avg,
       round(avg(mark_2), 2) AS mark_2_avg,
       round(avg(mark_3), 2) AS mark_3_avg
FROM
       student_exercise_2
WHERE
       mark_1 >= 40
       AND mark_2 >= 40
       AND mark_3 >= 40
GROUP BY
       dept;

-- Q. avg total of the department where students have passed in all the subjects
-- here is where CTE is going to be useful
WITH students AS(
       SELECT
              roll_no,
              name,
              IFNULL(mark_1, 0) mark_1,
              IFNULL(mark_2, 0) mark_2,
              IFNULL(mark_3, 0) mark_3,
              dept AS department,
              IFNULL(mark_1, 0) + IFNULL(mark_2, 0) + IFNULL(mark_3, 0) AS total
       FROM
              student_exercise_2
)
SELECT
       department,
       avg(total)
FROM
       students
WHERE
       mark_1 >= 40
       AND mark_2 >= 40
       AND mark_3 >= 40
GROUP BY
       department
ORDER BY
       department DESC;

-- sub queries
-- Q. find the name of the students who scored more than the class average for mark_1
-- class average
SELECT
       avg(mark_1)
FROM
       student_exercise_2;

-- manually
SELECT
       name
FROM
       student_exercise_2
WHERE
       mark_1 > 67.67;

-- using sub queries replaced 67.67 with calculated average
SELECT
       name
FROM
       student_exercise_2
WHERE
       mark_1 > (
              SELECT
                     avg(mark_1)
              FROM
                     student_exercise_2
       );

-- Q. find roll_no,name of students whose total is more than average total
WITH students AS(
       SELECT
              roll_no,
              name,
              IFNULL(mark_1, 0) mark_1,
              IFNULL(mark_2, 0) mark_2,
              IFNULL(mark_3, 0) mark_3,
              dept AS department,
              IFNULL(mark_1, 0) + IFNULL(mark_2, 0) + IFNULL(mark_3, 0) AS total
       FROM
              student_exercise_2
)
SELECT
       roll_no,
       name,
       total
FROM
       students
WHERE
       total >= (
              SELECT
                     avg(total)
              FROM
                     students
       );

-- using multiple CTES
WITH students AS(
       SELECT
              roll_no,
              name,
              IFNULL(mark_1, 0) mark_1,
              IFNULL(mark_2, 0) mark_2,
              IFNULL(mark_3, 0) mark_3,
              dept AS department,
              IFNULL(mark_1, 0) + IFNULL(mark_2, 0) + IFNULL(mark_3, 0) AS total
       FROM
              student_exercise_2
),
overall_averages AS (
       SELECT
              avg(mark_1) AS mark_1_avg,
              avg(mark_2) AS mark_2_avg,
              avg(mark_3) AS mark_3_avg,
              avg(total) AS avg_total
       FROM
              students
)
SELECT
       roll_no,
       name,
       total
FROM
       students
WHERE
       total >=(
              SELECT
                     avg_total
              FROM
                     overall_averages
       );

-- window function
-- OVER () partition by
-- Q. find name,roll_no,dept,total of students who scored more than the dept average
-- SELECT
--        avg(mark_1)
-- FROM
--        student_exercise_2
-- WHERE
--        dept = 'CSE';
SELECT
       roll_no,
       name,
       dept,
       avg(mark_1) over() AS overall,
       avg(mark_1) over(PARTITION by dept) AS dept_avg
FROM
       student_exercise_2;

WITH students AS(
       SELECT
              roll_no,
              name,
              IFNULL(mark_1, 0) mark_1,
              IFNULL(mark_2, 0) mark_2,
              IFNULL(mark_3, 0) mark_3,
              dept,
              IFNULL(mark_1, 0) + IFNULL(mark_2, 0) + IFNULL(mark_3, 0) AS total,
              avg(
                     IFNULL(mark_1, 0) + IFNULL(mark_2, 0) + IFNULL(mark_3, 0)
              ) over(PARTITION by dept) AS dept_avg
       FROM
              student_exercise_2
)
SELECT
       roll_no,
       name,
       dept,
       total,
       dept_avg
FROM
       students
WHERE
       total >= dept_avg;

-- rank ()
-- Q. show all the details of the details and provide an aggregate rank in their department
SELECT
       roll_no,
       name,
       dept,
       mark_1,
       avg(mark_1) over() AS mark_1_overall_avg,
       avg(mark_1) over(PARTITION by dept) AS dept_mark_1_avg,
       rank() over(
              ORDER BY
                     mark_1
       ) rank_overall
FROM
       student_exercise_2
ORDER BY
       rank_overall;

SELECT
       roll_no,
       name,
       dept,
       mark_1,
       avg(mark_1) over() AS mark_1_overall_avg,
       avg(mark_1) over(PARTITION by dept) AS dept_mark_1_avg,
       rank() over(
              ORDER BY
                     mark_1 DESC
       ) rank_overall
FROM
       student_exercise_2
ORDER BY
       rank_overall;

SELECT
       roll_no,
       name,
       dept,
       mark_1,
       avg(mark_1) over() AS mark_1_overall_avg,
       avg(mark_1) over(PARTITION by dept) AS dept_mark_1_avg,
       rank() over(
              ORDER BY
                     mark_1 DESC
       ) rank_overall,
       dense_rank() over(
              ORDER BY
                     mark_1 DESC
       ) rank_overall_2
FROM
       student_exercise_2;

-- Q. Provide details of all the students and their rank in their departments
--with CTE
WITH students AS(
       SELECT
              roll_no,
              name,
              IFNULL(mark_1, 0) mark_1,
              IFNULL(mark_2, 0) mark_2,
              IFNULL(mark_3, 0) mark_3,
              dept,
              IFNULL(mark_1, 0) + IFNULL(mark_2, 0) + IFNULL(mark_3, 0) AS total
       FROM
              student_exercise_2
)
SELECT
       roll_no,
       name,
       dept,
       total,
       dense_rank() over(
              PARTITION BY dept
              ORDER BY
                     total DESC
       ) AS rank
FROM
       students;

--without CTE
SELECT
       roll_no,
       name,
       dept,
       mark_1 + mark_2 + mark_3 AS total,
       dense_rank() over(
              PARTITION BY dept
              ORDER BY
                     (mark_1 + mark_2 + mark_3) DESC
       ) AS rank
FROM
       student_exercise_2;

/* 
 Conclusion :
 -> Aggregate function min and max
 -> distinct
 -> sub queries
 -> relooked at CTE's 
 -> window functions ( over() rank() dense_rank()  )
 */