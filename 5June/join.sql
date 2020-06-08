-- SQLite
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

SELECT
  *
FROM
  entrance_exam_results;

SELECT
  *
FROM
  city_bonus_points;

-- Q. roll_no name city marks city_bonus total(marks+city_bonus) for every student
-- Topic : Joins
-- an action of combining two tables is called joins
SELECT
  count(*)
FROM
  entrance_exam_results;

SELECT
  count(*)
FROM
  city_bonus_points;

-- cross join 
-- if you select from two tables it happens by default
SELECT
  *
FROM
  entrance_exam_results,
  city_bonus_points;

SELECT
  *
FROM
  entrance_exam_results
  CROSS JOIN city_bonus_points;

-- cartesian product aka cross join
SELECT
  a.city,
  b.city,
  CASE
    WHEN a.city = b.city THEN 'MATCH'
    ELSE '-'
  END AS MATCH
FROM
  entrance_exam_results a
  JOIN city_bonus_points b;

SELECT
  *
FROM
  entrance_exam_results;

SELECT
  *
FROM
  city_bonus_points;

-- below tab1 and tab2 are table aliases
-- INNER JOIN or EQUI JOIN
-- something which works in equality what ever matches with the data will only displayed
-- if something is outside the join condition it wont get displayed
-- in the below one we are losing two students one is from NULL and one is from hyderabd
-- for both of these two we are not able to get data fron table 2 
SELECT
  tab1.roll_no,
  tab1.city,
  tab1.score,
  tab2.bonus_score,
  (tab1.score + tab2.bonus_score) AS total
FROM
  entrance_exam_results tab1
  JOIN city_bonus_points tab2 ON tab1.city = tab2.city;

-- add left 
-- left join takes everything from left tables and computes
-- left outer join 
-- outer join is any join where the results is coming from outlise like null for unmatched
SELECT
  tab1.roll_no,
  tab1.city,
  tab1.score,
  tab2.city AS tab2_city,
  tab2.bonus_score,
  (tab1.score + tab2.bonus_score) AS total
FROM
  entrance_exam_results tab1
  LEFT JOIN city_bonus_points tab2 ON tab1.city = tab2.city;

-- right and full outer join in not supported in sqlite3
-- but you can do so using changind the tables direction
-- left outer join with city on left
SELECT
  tab1.roll_no,
  tab1.city,
  tab1.score,
  tab2.city AS tab2_city,
  tab2.bonus_score,
  (tab1.score + tab2.bonus_score) AS total
FROM
  city_bonus_points tab2
  LEFT JOIN entrance_exam_results tab1 ON tab1.city = tab2.city;

-- Q. roll_no name city marks city_bonus total(marks+city_bonus) for every student 
-- take zero for null and calculate
SELECT
  tab1.roll_no,
  tab1.city,
  IFNULL(tab1.score, 0) AS score,
  IFNULL(tab2.bonus_score, 0) AS bonus_score,
  (
    IFNULL(tab1.score, 0) + IFNULL(tab2.bonus_score, 0)
  ) AS total
FROM
  entrance_exam_results tab1
  LEFT JOIN city_bonus_points tab2 ON tab1.city = tab2.city;

-- self join 
-- a table which joins with itself
CREATE TABLE exp (id number(1));

INSERT INTO
  exp
VALUES
  (1),
  (2),
  (3);

SELECT
  *
FROM
  exp;

-- you can't directly join with itself
-- this below one gives error
SELECT
  *
FROM
  exp,
  exp;

-- but you can join using table aliased (cross join)
SELECT
  a.id,
  b.id
FROM
  exp a,
  exp b;