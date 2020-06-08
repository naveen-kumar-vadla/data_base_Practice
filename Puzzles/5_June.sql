-- Date : 08-06-2020
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

-- 1Q. Provide roll_no, city, score, bonus("N/A" if not available) and total(count bonus as 0 if not available)
SELECT
  tab1.roll_no,
  tab1.city,
  IFNULL(tab1.score, "N/A") AS score,
  IFNULL(tab2.bonus_score, "N/A") AS bonus_score,
  (
    IFNULL(tab1.score, 0) + IFNULL(tab2.bonus_score, 0)
  ) AS total
FROM
  entrance_exam_results tab1
  LEFT JOIN city_bonus_points tab2 ON tab1.city = tab2.city;

-- 2Q. Provide roll_no, city, bonus of students whose city's bonus point is more than or equal to 10 (consider null as 0)
SELECT
  tab1.roll_no,
  tab1.city,
  IFNULL(tab2.bonus_score, "N/A") AS bonus_score
FROM
  entrance_exam_results tab1
  LEFT JOIN city_bonus_points tab2 ON tab1.city = tab2.city
WHERE
  tab2.bonus_score >= 10;

-- 3Q. Provide name of cities which doesn't have any candidate ('= NULL' will not work, use 'IS NULL')
SELECT
  tab1.city
FROM
  city_bonus_points tab1
  LEFT JOIN entrance_exam_results tab2 ON tab1.city = tab2.city
WHERE
  tab2.city IS NULL;

-- 4Q. Sort cities(present in tbl2) with candidate count based on their candidate count in descending order
SELECT
  tab1.city,
  count(tab2.city) AS candidate_count
FROM
  city_bonus_points tab1
  LEFT JOIN entrance_exam_results tab2 ON tab1.city = tab2.city
GROUP BY
  tab1.city
ORDER BY
  candidate_count DESC;

-- 5Q. Show total score of each city(which has minimum 1 candidate)
--(sort them on descending order by total)(if city name is not present for a student it will be considered as 'OTHER CITIES')
WITH students AS (
  SELECT
    IFNULL(tab2.city, "Other Cities") AS city,
    IFNULL(tab1.score, 0) + IFNULL(tab2.bonus_score, 0) AS total
  FROM
    entrance_exam_results tab1
    LEFT JOIN city_bonus_points tab2 ON tab1.city = tab2.city
)
SELECT
  city,
  sum(total) AS city_total
FROM
  students
GROUP BY
  city
ORDER BY
  city_total DESC;

-- 6Q. Rank cities based on their city total(same clauses as the last one)
WITH students AS (
  SELECT
    IFNULL(tab2.city, "Other Cities") AS city,
    IFNULL(tab1.score, 0) + IFNULL(tab2.bonus_score, 0) AS total
  FROM
    entrance_exam_results tab1
    LEFT JOIN city_bonus_points tab2 ON tab1.city = tab2.city
)
SELECT
  city,
  sum(total) AS city_total,
  dense_rank() over (
    ORDER BY
      sum(total) DESC
  ) AS city_rank
FROM
  students
GROUP BY
  city;