
-- Recreate the table
DROP TABLE IF EXISTS student_exercise_1; 
CREATE TABLE  student_exercise_1 (

roll_no  NUMERIC(5)  NOT NULL UNIQUE,
name     VARCHAR(30) NOT NULL DEFAULT 'No Name Defined',
mark_1   NUMERIC(3),
mark_2   NUMERIC(3),
mark_3   NUMERIC(3)
);

-- populate values
INSERT INTO student_exercise_1 VALUES
( 1,    'AB', 49,   67,     90),
( 2,    'AB', 95,   70,     100),
( 3,    'BB', 55,   100,    91),
( 4,    'CA', 100,  100,    100),
( 5,    'DD', 100,  89,     83),
( 6,    'AD', 87,   67,     97),
( 7,    'AE', 35,   87,     86),
( 8,    'AF', 67,   74,     93),
( 9,    'AG', 58,   71,     59),
( 10,   'AH', 49,   71,     76),
( 11,   'AI', 100,   86,    91),
( 12,   'AJ', 66,   57,     100),
( 13,   'AK', 87,   63,     80),
( 14,   'B2', 74,   69,     84),
( 15,   'B4', 40,  100,     87),
( 16,   'B6', 93,   85,     73),
( 17,   'C8', 100,  91,     35),
( 18,   'A6', 38,   59,     90),
( 19,   'AB', 57,   74,     90),
( 20,   'A*', 71,   81,     90),
( 21,   'YY', 0,     0,     NULL)
;

select count(*) 
  from student_exercise_1;

select roll_no, name, (mark_1 + mark_2 + mark_3) total
  from student_exercise_1;
-- + - * / %

-- 
select roll_no
        , name
        , (mark_1 + mark_2 + mark_3) total
        , ROUND ( (mark_1 + mark_2 + mark_3)/300.0 * 100, 2 ) as percentage
  from student_exercise_1;
/*
  Scalar - VALUES
  Aggregate COUNT, SUM
*/

  select sum(mark_1)
    from student_exercise_1;

-- literals as columm value
select 1  as not_a_roll_number  , 'Hello' as greeting
  from student_exercise_1;

select roll_no, 1 as not_row_number, 'Pune' as city
  from student_exercise_1;

select count(roll_no) 
  from student_exercise_1;

select count(mark_3)
  from student_exercise_1;

select roll_no, name, (mark_1 + mark_2 + mark_3) as total
  from student_exercise_1
 where mark_1 >= 40
   and mark_2 >= 40
   and mark_3 >= 40
 ;

 select roll_no, name, (mark_1 + mark_2 + mark_3) as total
  from student_exercise_1
 where mark_1 < 40
    or mark_2 < 40
    or mark_3 < 40
 ;

select roll_no, mark_3, IFNULL(mark_3, 0) as mark_3_v2
  from student_exercise_1;

select count(mark_3) as count_of_mark3
    , COUNT( IFNULL(mark_3, 0) ) as count_of_mark3_withNULL
from student_exercise_1;

-- Example of CASE statement

select roll_no
     , CASE WHEN mark_1 > 80 THEN 'First class'
            WHEN mark_1 > 60 THEN 'Second class'
            WHEN mark_1 > 40 THEN 'Scope to do better'
            ELSE 'Do better next time'
        END  as category
  from student_exercise_1;

--Count the  # of students with pass score in either M1 or M2
select count(*)
  from student_exercise_1
 where mark_1 >= 40 OR mark_2 >=40;

-- roll_no, name, mark_1, 200, mark_1 %, 'Pass/Fail'
select roll_no
    , name
    , mark_1
    , 200 as mark1_max_score
    , (mark_1 / 200.0) * 100 as mark_1_in_perc
    , CASE WHEN mark_1 >= 40 THEN 'Pass'  
           ELSE 'Fail'
      END   as result
    , CASE WHEN mark_1 >= 40 THEN mark_1  
           ELSE 0
      END   as mark_1_adj      
  from student_exercise_1;


  -- progress report
  -- roll_no, name, mark_1, mark_2, mark_3, total, total_percentage, result
-- Maximum score per subject = 100
-- Convert NULLs to 0
-- Round percentages to 2 decimal places

select roll_no
     , name
     , mark_1
     , mark_2
     , mark_3
     , (mark_1 + mark_2 + mark_3) as total
     , total +1
  from student_exercise_1;


-- aggregated  AVG
select avg(IFNULL(mark_1,0)) 
     , sum( IFNULL(mark_1, 0 ))/count(IFNULL(mark_1,0)) as avg2
  from student_exercise_1
 where mark_1 >= 40;


 -- Common table expression / CTE
 
with students_with_pass_score as 
(

 select roll_no
      , IFNULL(mark_1, 0) as subject_1 
      , IFNULL(mark_2, 0) as subject_2
      , IFNULL(mark_3, 0) as subject_3
      from student_exercise_1
    where mark_1 >= 40 and mark_2 >= 40 and mark_3 >= 40
)

select ROUND (avg(subject_1), 0)  as avg_sub_1
, count(*)  count_sub_1
  from students_with_pass_score;


-- usage of table alias
select st.roll_no
     , st.name
     , st.mark_1
  from student_exercise_1 st ;

select roll_no
  from student_exercise_1;

