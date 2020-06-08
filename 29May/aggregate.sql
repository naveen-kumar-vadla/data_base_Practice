-- Recreate the table
DROP TABLE IF EXISTS student_exercise_1;

CREATE TABLE student_exercise_1 (
  roll_no NUMERIC(5) NOT NULL UNIQUE,
  name VARCHAR(30) NOT NULL DEFAULT 'No Name Defined',
  mark_1 NUMERIC(3),
  mark_2 NUMERIC(3),
  mark_3 NUMERIC(3)
);

-- populate values
INSERT INTO
  student_exercise_1
VALUES
  (1, 'AB', 49, 67, 90),
  (2, 'AB', 95, 70, 100),
  (3, 'BB', 55, 100, 91),
  (4, 'CA', 100, 100, 100),
  (5, 'DD', 100, 89, 83),
  (6, 'AD', 87, 67, 97),
  (7, 'AE', 35, 87, 86),
  (8, 'AF', 67, 74, 93),
  (9, 'AG', 58, 71, 59),
  (10, 'AH', 49, 71, 76),
  (11, 'AI', 100, 86, 91),
  (12, 'AJ', 66, 57, 100),
  (13, 'AK', 87, 63, 80),
  (14, 'B2', 74, 69, 84),
  (15, 'B4', 40, 100, 87),
  (16, 'B6', 93, 85, 73),
  (17, 'C8', 100, 91, 35),
  (18, 'A6', 38, 59, 90),
  (19, 'AB', 57, 74, 90),
  (20, 'A*', 71, 81, 90),
  (21, 'YY', 0, 0, NULL);

SELECT
  *
FROM
  student_exercise_1;

SELECT
  count(*)
FROM
  student_exercise_1;

SELECT
  roll_no,
  name,
  (mark_1 + mark_2 + mark_3) total
FROM
  student_exercise_1;

SELECT
  roll_no,
  name,
  (mark_1 + mark_2 + mark_3) total,
  ROUND((mark_1 + mark_2 + mark_3) / 300.0 * 100, 2) percentage
FROM
  student_exercise_1;

SELECT
  roll_no,
  1 AS not_a_roll_number
FROM
  student_exercise_1;

SELECT
  1 AS not_a_roll_number,
  'Hello' AS greeting
FROM
  student_exercise_1;

SELECT
  count(roll_no)
FROM
  student_exercise_1;

SELECT
  count(mark_3)
FROM
  student_exercise_1;

SELECT
  *
FROM
  student_exercise_1
WHERE
  mark_1 >= 40
  AND mark_2 >= 40
  AND mark_3 >= 40;

SELECT
  roll_no,
  name,
  (mark_1 + mark_2 + mark_3) total
FROM
  student_exercise_1
WHERE
  mark_1 >= 40
  AND mark_2 >= 40
  AND mark_3 >= 40;

SELECT
  roll_no,
  name,
  (mark_1 + mark_2 + mark_3) total
FROM
  student_exercise_1
WHERE
  mark_1 < 40
  OR mark_2 < 40
  OR mark_3 < 40;

SELECT
  count(mark_3) AS mark_3_count,
  count(IFNULL(mark_3, 0)) AS mark_3_count_with_null
FROM
  student_exercise_1;

SELECT
  roll_no,
  CASE
    WHEN mark_1 > 80 THEN 'first class'
    WHEN mark_1 > 60 THEN 'first class'
    WHEN mark_1 > 40 THEN 'third class'
    ELSE 'do better next time'
  END AS category
FROM
  student_exercise_1;

SELECT
  count(*)
FROM
  student_exercise_1
WHERE
  mark_1 >= 40
  OR mark_2 >= 40;

-- roll_no,name,mark_1,200 as maxMarks, mark_1_perc,pass_or_fail
SELECT
  roll_no,
  name,
  mark_1,
  200 AS max_marks,
  (mark_1 / 200.0) * 100 AS mark_1_perc,
  CASE
    WHEN mark_1 >= 40 THEN 'pass'
    ELSE 'fail'
  END AS result
FROM
  student_exercise_1;

SELECT
  roll_no,
  name,
  CASE
    WHEN mark_1 >= 40 THEN mark_1
    ELSE 0
  END AS mark_1,
  CASE
    WHEN mark_1 >= 40 THEN 'pass'
    ELSE 'fail'
  END AS result
FROM
  student_exercise_1;

-- roll_no name mark_1 mark_2 mark_3 total total_percentage result
DROP VIEW IF EXISTS report;

CREATE VIEW report AS
SELECT
  roll_no,
  name,
  IFNULL(mark_1, 0) AS subject_1,
  IFNULL(mark_2, 0) AS subject_2,
  IFNULL(mark_3, 0) AS subject_3,
  (
    IFNULL(mark_1, 0) + IFNULL(mark_2, 0) + IFNULL(mark_3, 0)
  ) AS total,
  ROUND(
    (
      IFNULL(mark_1, 0) + IFNULL(mark_2, 0) + IFNULL(mark_3, 0)
    ) / 300.0 * 100,
    2
  ) AS total_percentage,
  CASE
    WHEN mark_1 >= 40
    AND mark_2 >= 40
    AND mark_3 >= 40 THEN 'pass'
    ELSE 'fail'
  END AS result
FROM
  student_exercise_1;

SELECT
  *
FROM
  report;

-- aggregate avg
SELECT
  avg(IFNULL(mark_1, 0)) AS mark_1_avg,
  sum(IFNULL(mark_1, 0)) / count(IFNULL(mark_1, 0)) AS mark_1_avg2,
  avg(IFNULL(mark_2, 0)) AS mark_2_avg,
  sum(IFNULL(mark_2, 0)) / count(IFNULL(mark_2, 0)) AS mark_2_avg2,
  avg(IFNULL(mark_3, 0)) AS mark_3_avg,
  sum(IFNULL(mark_3, 0)) / count(IFNULL(mark_3, 0)) AS mark_3_avg2
FROM
  student_exercise_1;

SELECT
  avg(IFNULL(mark_1, 0)) AS mark_1_avg,
  sum(IFNULL(mark_1, 0)) / count(IFNULL(mark_1, 0)) AS mark_1_avg2,
  avg(IFNULL(mark_2, 0)) AS mark_2_avg,
  sum(IFNULL(mark_2, 0)) / count(IFNULL(mark_2, 0)) AS mark_2_avg2,
  avg(IFNULL(mark_3, 0)) AS mark_3_avg,
  sum(IFNULL(mark_3, 0)) / count(IFNULL(mark_3, 0)) AS mark_2_avg2
FROM
  student_exercise_1
WHERE
  mark_1 >= 40
  AND mark_2 >= 40
  AND mark_3 >= 40;