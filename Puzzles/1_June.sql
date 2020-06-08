-- Problems by Batch mates
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

-- Q. provide pass and fail count of whole class
WITH students_with_result AS(
  SELECT
    CASE
      WHEN (
        mark_1 >= 40
        AND mark_2 >= 40
        AND mark_3 >= 40
      ) THEN 'Pass'
      ELSE 'Fail'
    END AS result
  FROM
    student_exercise_2
)
SELECT
  result,
  count(result) AS count
FROM
  students_with_result
GROUP BY
  result;

-- Q. provide pass count per department
WITH students_with_result AS(
  SELECT
    dept,
    CASE
      WHEN mark_1 >= 40
      AND mark_2 >= 40
      AND mark_3 >= 40 THEN 'Pass'
      ELSE NULL
    END AS is_passed
  FROM
    student_exercise_2
)
SELECT
  dept,
  count(is_passed) AS pass_count
FROM
  students_with_result
GROUP BY
  dept;

-- Q. Provide pass and fail count for each department
WITH students_with_result AS(
  SELECT
    dept,
    CASE
      WHEN (
        mark_1 >= 40
        AND mark_2 >= 40
        AND mark_3 >= 40
      ) THEN 'Pass'
      ELSE NULL
    END AS is_passed,
    CASE
      WHEN (
        mark_1 < 40
        OR mark_2 < 40
        OR mark_3 < 40
      ) THEN 'Fail'
      ELSE NULL
    END AS is_failed
  FROM
    student_exercise_2
)
SELECT
  dept,
  count(is_passed) AS pass_count,
  count(is_failed) AS fail_count
FROM
  students_with_result
GROUP BY
  dept;

-- Q. provide the count of students who scored above avg per department.
WITH students AS(
  SELECT
    roll_no,
    name,
    IFNULL(mark_1, 0) AS mark_1,
    IFNULL(mark_2, 0) AS mark_2,
    IFNULL(mark_3, 0) AS mark_3,
    dept,
    IFNULL(mark_1, 0) + IFNULL(mark_2, 0) + IFNULL(mark_3, 0) AS total,
    avg(
      IFNULL(mark_1, 0) + IFNULL(mark_2, 0) + IFNULL(mark_3, 0)
    ) over(PARTITION by dept) AS dept_avg
  FROM
    student_exercise_2
)
SELECT
  dept,
  count(*) AS pass_count
FROM
  students
WHERE
  total >= dept_avg
GROUP BY
  dept;

-- Q. provide the name, department of students who have scored highest and lowest per department, 
-- and the difference between their total and department_avg_total 
-- (deviation from the department_avg_total)...
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
),
students_deviation AS (
  SELECT
    *,
    total - dept_avg AS deviation,
    min(total - dept_avg) over (PARTITION by dept) AS min,
    max(total - dept_avg) over (PARTITION by dept) AS max
  FROM
    students
)
SELECT
  name,
  dept,
  deviation,
  CASE
    WHEN deviation == max THEN 'highest_scorer'
    WHEN deviation == min THEN 'lowest_scorer'
    ELSE 'normal_scorer'
  END AS title
FROM
  students_deviation
WHERE
  deviation == min
  OR deviation == max;