DROP TABLE IF EXISTS entrance_exam_results;

CREATE TABLE entrance_exam_results (
  roll_no NUMBER(5) PRIMARY KEY,
  city VARCHAR(10),
  score NUMBER(3) NOT NULL
);

INSERT INTO
  entrance_exam_results
VALUES
  (1, 'BENGALURU', 90),
  (2, 'DELHI', 67),
  (3, 'DELHI', 87),
  (4, 'BENGALURU', 76),
  (5, 'PUNE', 89),
  (6, NULL, 91),
  (7, 'CHENNAI', 77),
  (8, 'HYDERABAD', 80);

DROP TABLE IF EXISTS city_bonus_points;

CREATE TABLE city_bonus_points (city VARCHAR(10), bonus_score NUMBER(2));

INSERT INTO
  city_bonus_points
VALUES
  ('BENGALURU', 10),
  ('DELHI', 9),
  ('PUNE', 11),
  ('CHENNAI', 10),
  ('COIMBATORE', 12),
  ('NAGPUR', 13),
  ('Nagpur', 13);

-- Topic: JOINS
SELECT
  *
FROM
  entrance_exam_results;

SELECT
  *
FROM
  city_bonus_points;

-- 1 BEGALURU 90 + 10 = 100 2 DELHI 67 + 9 = 76 3 DELHI 87 + 9
SELECT
  count(*)
FROM
  entrance_exam_results;

SELECT
  count(*)
FROM
  city_bonus_points;

-- cartesian product aka  CROSS JOIN
SELECT
  a.roll_no,
  a.city,
  b.city,
  CASE
    WHEN a.city = b.city THEN 'MATCH'
    ELSE ' - '
  END AS MATCH
FROM
  entrance_exam_results a,
  city_bonus_points b;

SELECT
  *
FROM
  entrance_exam_results;

-- INNER JOIN
SELECT
  tab1.roll_no,
  tab1.city AS tab1_city,
  tab1.score,
  tab2.bonus_score,
  tab1.score + tab2.bonus_score AS total
FROM
  entrance_exam_results tab1
  JOIN city_bonus_points tab2 ON tab1.city = tab2.city;

-- INNER JOIN with a condition
SELECT
  tab1.roll_no,
  tab1.city AS tab1_city,
  tab1.score,
  tab2.city AS tab2_city,
  tab2.bonus_score,
  (tab1.score + tab2.bonus_score) AS total
FROM
  entrance_exam_results tab1
  JOIN city_bonus_points tab2 ON tab1.city = tab2.city;

--entrance_exam_results  ->   city_bonus_points
--  LEFT OUTER JOIN with a condition
SELECT
  tab1.roll_no,
  tab1.city AS tab1_city,
  tab1.score,
  tab2.city AS tab2_city,
  tab2.bonus_score,
  (tab1.score + tab2.bonus_score) AS total
FROM
  entrance_exam_results tab1
  LEFT JOIN city_bonus_points tab2 ON tab1.city = tab2.city;

-- left outer join with city on the left 
SELECT
  tab1.roll_no,
  tab1.city AS tab1_city,
  tab1.score,
  tab2.city AS tab2_city,
  tab2.bonus_score,
  (tab1.score + tab2.bonus_score) AS total
FROM
  city_bonus_points tab2
  LEFT JOIN entrance_exam_results tab1 ON tab1.city = tab2.city;

SELECT
  *
FROM
  city_bonus_points;

-- example of self join
CREATE TABLE EXP (id NUMBER(10));

INSERT INTO
  exp
VALUES
  (1),
  (2),
  (3);

SELECT
  t1.id,
  t2.id
FROM
  exp t1,
  exp t2;

/*
 JOINS -
 CROSS JOIN,
 INNER JOIN,
 LEFT OUTER JOIN,
 RIGHT OUTER JOIN,
 FULL
 OUTER JOIN
 */