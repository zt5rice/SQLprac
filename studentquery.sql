/*
 https://enfangzhong.github.io/2019/12/03/SQL%E8%AF%AD%E5%8F%A5%E9%9D%A2%E8%AF%95%E7%BB%8F%E5%85%B850%E9%A2%98/
*/

-- 1. student query

-- query students with 'monkey' family name
SELECT *
FROM student
WHERE s_name LIKE "赵%";

SELECT *
FROM student
WHERE s_name LIKE "%雷";

SELECT *
FROM student
WHERE s_name LIKE "%雷%";

SELECT COUNT(*) AS 姓“孟”老师的个数
FROM teacher
WHERE t_name LIKE '孟%';

/*
3. 面试题：查询课程编号为“0002”的总成绩
分析思路
select 查询结果 [总成绩:汇总函数sum]
from 从哪张表中查找数据[成绩表score]
where 查询条件 [课程号是0002]
*/

SELECT sum(s_score) AS 'TOT SCORE'
FROM score
WHERE c_id ='02';

select *
From SCORE;

SELECT sum(s_score) AS 'TOT SCORE'
FROM score;

/*
4. 查询选了课程的学生人数
这个题目翻译成大白话就是：查询有多少人选了课程
select 学号，成绩表里学号有重复值需要去掉
from 从课程表查找score;
*/
SELECT COUNT(DISTINCT s_id) AS '学生人数',
COUNT(DISTINCT c_id) AS '课程数'

FROM score;


/*
max score of each class

分析思路
select 查询结果 [课程ID：是课程号的别名,最高分：max(成绩) ,最低分：min(成绩)]
from 从哪张表中查找数据 [成绩表score]
where 查询条件 [没有]
group by 分组 [各科成绩：也就是每门课程的成绩，需要按课程号分组];

上述题的拆分：课程id为0002的最高分与最低分

SELECT MAX(s_score) AS 最高分, MIN(s_score) AS 最低分
FROM score
WHERE c_id = '0002'
*/

SELECT
	c_id,MAX(s_score) AS 最高分,MIN(s_score) AS 最低分
FROM score
GROUP BY c_id;

/*
6.查询每门课程被选修的学生数
— 通过对成绩表的课程id进行分组，然后对该学号进行计数
分析思路
select 查询结果 [课程号，选修该课程的学生数：汇总函数count]
from 从哪张表中查找数据 [成绩表score]
where 查询条件 [没有]
group by 分组 [每门课程：按课程号分组];
*/
SELECT c_id, COUNT(c_id)
FROM score
GROUP BY c_id;

/*
7.查询男生、女生人数
在学生表中对性别进行分组 计数

分析思路
select 查询结果 [性别，对应性别的人数：汇总函数count]
from 从哪张表中查找数据 [性别在学生表中，所以查找的是学生表student]
where 查询条件 [没有]
group by 分组 [男生、女生人数：按性别分组]
having 对分组结果指定条件 [没有]
order by 对查询结果排序[没有];
*/
SELECT s_sex, COUNT(s_sex) AS 性别
from student
GROUP BY s_sex;

/* 
8.查询平均成绩大于60分学生的学号和平均成绩
题目翻译成大白话：
平均成绩：展开来说就是计算每个学生的平均成绩
这里涉及到“每个”就是要分组了
平均成绩大于60分，就是对分组结果指定条件

分析思路
select 查询结果 [学号，平均成绩：汇总函数avg(成绩)]
from 从哪张表中查找数据 [成绩在成绩表中，所以查找的是成绩表score]
where 查询条件 [没有]
group by 分组 [平均成绩：先按学号分组，再计算平均成绩]
having 对分组结果指定条件 [平均成绩大于60分]
*/
-- 在成绩表中对学号进行分组求平均成绩  having条件是平均成绩>60分
select s_id,AVG(s_score)
FROM score
GROUP BY s_id
HAVING AVG(s_score)>60
ORDER BY AVG(s_score) DESC;

/* 
9.查询至少选修两门课程的学生学号

翻译成大白话：
第1步，需要先计算出每个学生选修的课程数据，需要按学号分组
第2步，至少选修两门课程：也就是每个学生选修课程数目>=2，对分组结果指定条件

分析思路
select 查询结果 [学号,每个学生选修课程数目：汇总函数count]
from 从哪张表中查找数据 [课程的学生学号：课程表score]
where 查询条件 [至少选修两门课程：需要先计算出每个学生选修了多少门课，需要用分组，所以这里没有where子句]
group by 分组 [每个学生选修课程数目：按课程号分组，然后用汇总函数count计算出选修了多少门课]
having 对分组结果指定条件 [至少选修两门课程：每个学生选修课程数目>=2]
*/
SELECT s_id,COUNT(c_id) as 选修课程数目
FROM score
GROUP BY c_id
HAVING COUNT(c_id)>=2;

/* 
10.查询同名同性学生名单并统计同名人数

翻译成大白话，问题解析：
1）查找出姓名相同的学生有谁，每个姓名相同学生的人数
查询结果：姓名,人数
条件：怎么算姓名相同？按姓名分组后人数大于等于2，因为同名的人数大于等于2
分析思路
select 查询结果 [姓名,人数：汇总函数count(*)]
from 从哪张表中查找数据 [学生表student]
where 查询条件 [没有]
group by 分组 [姓名相同：按姓名分组]
having 对分组结果指定条件 [姓名相同：count(*)>=2]
order by 对查询结果排序[没有];
*/
SELECT s_name,COUNT(s_name)
FROM student
GROUP BY s_name
HAVING COUNT(s_name)>=2;

/* 
11.查询不及格的课程并按课程号从大到小排列

分析思路
select 查询结果 [课程号]
from 从哪张表中查找数据 [成绩表score]
where 查询条件 [不及格：成绩 <60]
group by 分组 [没有]
having 对分组结果指定条件 [没有]
order by 对查询结果排序[课程号从大到小排列：降序desc];
*/
SELECT c_id
FROM score
WHERE s_score<60
GROUP BY c_id
ORDER BY c_id;

/*
12.查询每门课程的平均成绩，结果按平均成绩升序排序，平均成绩相同时，按课程号降序排列
分析思路
select 查询结果 [课程号,平均成绩：汇总函数avg(成绩)]
from 从哪张表中查找数据 [成绩表score]
where 查询条件 [没有]
group by 分组 [每门课程：按课程号分组]
having 对分组结果指定条件 [没有]
order by 对查询结果排序[按平均成绩升序排序:asc，平均成绩相同时，按课程号降序排列:desc];
*/

SELECT c_id,AVG(s_score) as 平均成绩
FROM score
GROUP BY c_id
ORDER BY AVG(s_score) ASC,c_id DESC;

/* 
13.检索课程编号为“0004”且分数小于60的学生学号，结果按按分数降序排列

分析思路
select 查询结果 []
from 从哪张表中查找数据 [成绩表score]
where 查询条件 [课程编号为“04”且分数小于60]
group by 分组 [没有]
having 对分组结果指定条件 []
order by 对查询结果排序[查询结果按按分数降序排列];
*/
SELECT s_id, s_score
from score
where C_id = "04" AND s_score >= 60
ORDER BY s_score DESC;

select s_id,s_score
FROM score
WHERE c_id = "0004" AND s_score >=60
ORDER BY s_score DESC;

/* 
14.统计每门课程的学生选修人数(超过2人的课程才统计)
要求输出课程号和选修人数，查询结果按人数降序排序，若人数相同，按课程号升序排序

分析思路
select 查询结果 [要求输出课程号和选修人数]
from 从哪张表中查找数据 []
where 查询条件 []
group by 分组 [每门课程：按课程号分组]
having 对分组结果指定条件 [学生选修人数(超过2人的课程才统计)：每门课程学生人数>2]
order by 对查询结果排序[查询结果按人数降序排序，若人数相同，按课程号升序排序];
???
*/

SELECT c_id, COUNT(score.s_id)
from score
GROUP BY c_id
HAVING COUNT(score.s_id) > 2
ORDER BY COUNT(score.s_id) DESC, c_id ASC;

SELECT c_id,COUNT(score.s_id) as '选修人数'
FROM score
GROUP BY c_id
HAVING COUNT(score.s_id) > 2
ORDER BY COUNT(score.s_id) DESC,c_id ASC;

/*
15.查询两门以上不及格课程的同学的学号及其平均成绩

分析思路
先分解题目：
1）[两门以上][不及格课程]限制条件
2）[同学的学号及其平均成绩]，也就是每个学生的平均成绩，显示学号，平均成绩
分析过程：
第1步：得到每个学生的平均成绩，显示学号，平均成绩
第2步：再加上限制条件：
1）不及格课程
2）两门以上[不及格课程]：课程数目>2

第1步：得到每个学生的平均成绩，显示学号，平均成绩
select 查询结果 [学号,平均成绩：汇总函数avg(成绩)]
from 从哪张表中查找数据 [涉及到成绩：成绩表score]
where 查询条件 [没有]
group by 分组 [每个学生的平均：按学号分组]
having 对分组结果指定条件 [没有]
order by 对查询结果排序[没有];

select 学号, avg(成绩) as 平均成绩
from score
group by 学号;

第2步：再加上限制条件：
1）不及格课程
2）两门以上[不及格课程]
select 查询结果 [学号,平均成绩：汇总函数avg(成绩)]
from 从哪张表中查找数据 [涉及到成绩：成绩表score]
where 查询条件 [限制条件：不及格课程，平均成绩<60]
group by 分组 [每个学生的平均：按学号分组]
having 对分组结果指定条件 [限制条件：课程数目>2,汇总函数count(课程号)>2]
order by 对查询结果排序[没有];
*/

SELECT score.s_id,student.s_name
FROM score
INNER JOIN student
ON score.s_id = student.s_id
GROUP BY s_id
HAVING MAX(s_score) <60;

-- first step
SELECT s_id, AVG(s_score)
from score
GROUP BY s_id;

SELECT s_id, count(s_score)
from score
where s_score < 60 
GROUP BY s_id
HAVING count(s_score)>=2;
-- ???
SELECT s_id,COUNT(s_score),avg(s_score) AS 平均成绩
FROM score
WHERE s_score<60
GROUP BY s_id
HAVING COUNT(s_score)>=2;

/*
4.3.复杂查询
16.查询所有课程成绩小于60分学生的学号、姓名
*/
select score.s_id, student.s_name
from score
inner join student
on score.s_id = student.s_id
group by s_id
having max(s_score) <= 60;

SELECT score.s_id,student.s_name
FROM score
INNER JOIN student
ON score.s_id = student.s_id
GROUP BY s_id
HAVING MAX(s_score) <60
