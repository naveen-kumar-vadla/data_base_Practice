-- SQLite
DROP TABLE IF EXISTS students_score;

CREATE TABLE students_score(
  roll_no NUMERIC(3) NOT NULL UNIQUE,
  name VARCHAR(30) DEFAULT 'Unknown',
  mark_1 NUMERIC(3),
  mark_2 NUMERIC(3),
  mark_3 NUMERIC(3),
  total NUMERIC(3) DEFAULT 0
);

INSERT INTO
  students_score (roll_no, name, mark_1, mark_2, mark_3)
VALUES
  (1, 'ram', 54, 66, 99),
  (3, 'raj', 63, 98, 37),
  (5, 'raghu', 78, 84, 87);

INSERT INTO
  students_score (roll_no, mark_1, mark_2, mark_3)
VALUES
  (2, 84, 98, 78),
  (4, 63, 66, 37),
  (6, 99, 54, 87);

SELECT
  *
FROM
  students_score
ORDER BY
  roll_no;

SELECT
  roll_no,
  name,
  mark_1,
  mark_2,
  mark_3,
  mark_1 + mark_2 + mark_3 AS total
FROM
  students_score
ORDER BY
  roll_no;