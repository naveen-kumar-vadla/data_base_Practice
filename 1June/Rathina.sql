/* WORKBOOK * Classroom 4 */
DROP TABLE IF EXISTS student_exercise_2;

CREATE TABLE student_exercise_2 (
    roll_no NUMERIC(5) NOT NULL UNIQUE,
    dept VARCHAR(5),
    name VARCHAR(30) NOT NULL DEFAULT 'No Name Defined',
    mark_1 NUMERIC(3),
    mark_2 NUMERIC(3),
    mark_3 NUMERIC(3)
);

-- populate values
INSERT INTO
    student_exercise_2 (roll_no dept name mark_1 mark_2 mark_3)
VALUES
    (1 'CSE' 'AB' 49 67 90) (2 'CSE' 'AB' 95 70 100) (3 'CSE' 'BB' 55 100 91) (4 'CSE' 'CA' 100 100 100) (5 'CSE' 'DD' 100 89 83) (6 'EEE' 'AD' 87 67 97) (7 'EEE' 'AE' 35 87 86) (8 'EEE' 'AF' 67 74 93) (9 'EEE' 'AG' 58 71 59) (10 'EEE' 'AH' 49 71 76) (11 'IT' 'AI' 100 86 91) (12 'IT' 'AJ' 66 57 100) (13 'IT' 'AK' 87 63 80) (14 'IT' 'B2' 74 69 84) (15 'MECH' 'B4' 40 100 87) (16 'MECH' 'B6' 93 85 73) (17 'MECH' 'C8' 100 91 35) (18 'MECH' 'A6' 38 59 90) (19 'CSE' 'AB' 57 74 90) (20 'CSE' 'A*' 71 81 90) (21 'CSE' 'YY' 0, 0, NULL);

SELECT
    *
FROM
    student_exercise_2;

-- Aggregate functions
SELECT
    COUNT(*)
FROM
    student_exercise_2;

SELECT
    MIN(mark_1) min_marks,
    MAX(mark_1) max_marks
FROM
    student_exercise_1;

-- AVG without GROUP BY
SELECT
    AVG(mark_1)
FROM
    student_exercise_2;

SELECT
    DISTINCT dept
FROM
    student_exercise_2;

-- GROUP BY
SELECT
    dept,
    AVG(mark_1) AS mark_1_avg
FROM
    student_exercise_2
GROUP BY
    dept;

-- assuming pass score = 40 SHOW avg of every subject -
--WHERE someone has scored a pass mark.Also SHOW the number of students passed.
SELECT
    dept,
    COUNT(mark_1) AS mark1_count,
    round(AVG(mark_1), 2) AS mark_1_avg
FROM
    student_exercise_2
WHERE
    mark_1 >= 40
GROUP BY
    dept;

-- show avg total for each department - for students who scored pass IN ALL three subjects WITH students AS (
SELECT
    name,
    roll_no,
    mark_1,
    mark_2,
    mark_3,
    (mark_1 + mark_2 + mark_3) AS total,
    dept AS department
FROM
    student_exercise_2;

SELECT
    department,
    AVG(total) AS avg_total
FROM
    students
WHERE
    (
        mark_1 >= 40
        AND mark_2 >= 40
        AND mark_3 >= 40
    )
GROUP BY
    department
ORDER BY
    department DESC;

-- find name of students who scored more than the overall average for mark_1
SELECT
    name
FROM
    student_exercise_2
WHERE
    mark_1 > (
        SELECT
            AVG(mark_1)
        FROM
            student_exercise_2
    );

-- SUB QUERY
-- replaced 67.67 WITH the query below for calculating average
SELECT
    AVG(mark_1)
FROM
    student_exercise_2;

-- same problem solved USING CTE 
WITH students AS(
    SELECT
        name,
        roll_no,
        mark_1,
        mark_2,
        mark_3,
        (mark_1 + mark_2 + mark_3) AS total,
        dept AS department
    FROM
        student_exercise_2
),
overall_averages AS (
    SELECT
        AVG(mark_1) AS mark_1_avg,
        AVG(mark_2) mark_2_avg,
        AVG(mark_3) mark_3_avg,
        AVG(total) avg_total
    FROM
        students
)
SELECT
    name
FROM
    students
WHERE
    total >= (
        SELECT
            avg_total
        FROM
            overall_averages
    );

/* find name, department, rollno, 
 -- who scored more than the department average for mark_1 */
;

-- Window functions (analytical functions)
SELECT
    roll_no,
    name,
    dept,
    mark_1,
    AVG(mark_1) OVER () mark_1_overallaverage,
    AVG(mark_1) OVER (PARTITION by dept) dept_mark1_average,
    RANK() OVER (
        ORDER BY
            mark_1 DESC
    ) rank_overall,
    DENSE_RANK() OVER (
        ORDER BY
            mark_1 DESC
    ) rank_overall_2
FROM
    student_exercise_2
ORDER BY
    rank_overall;

-- equivalent aggregate functions
SELECT
    AVG(mark_1)
FROM
    student_exercise_2;

SELECT
    dept,
    AVG(mark_1)
FROM
    student_exercise_2
GROUP BY
    dept;

/* - find name 
 ,department 
 ,rollno 
 ,who scored more than the department average for mark_1 - Provide details of ALL students AND their rank IN their departments 
 */
SELECT
    name,
    roll_no,
    (mark_1 + mark_2 + mark_3) AS total,
    dept,
    dense_rank() OVER (
        PARTITION by dept
        ORDER BY
            (mark_1 + mark_2 + mark_3) DESC
    ) AS rank
FROM
    student_exercise_2