/* Q1. Employee Productivity Analysis:
- Identify employees with the highest total hours worked and least absenteeism. */
with emp_attend as (
select employeeid, sum(total_hours) as total_hrs_worked,
round((sum(days_present)/nullif(sum(days_present+days_absent+sick_leaves+vacation_leaves),0))*100,2) as Percent_of_days_present
from attendance_records 
group  by employeeid 
order  by total_hrs_worked desc, Percent_of_days_present desc
)

select emp.employeeid,
emp.employeename, 
att.total_hrs_worked,
Percent_of_days_present
from employee_details emp inner join emp_attend att 
on att.employeeid=emp.employeeid
order by total_hrs_worked desc, Percent_of_days_present desc;

/*2. Departmental Training Impact:
- Analyze how training programs improve departmental performance.*/
select t.department_id, 
round(avg(feedback_score),2) as training_feedback_score,
round(avg(e.performance_score),2) as performance_score
from training_programs t inner join employee_details e 
on (e.employeeid=t.employeeid and e.department_id=t.department_id)
group by t.department_id
order by performance_score desc,training_feedback_score desc ;

/* Q3. Project Budget Efficiency:
--Evaluate the efficiency of project budgets by calculating costs per hour worked.*/
select project_name, round((sum(budget)/sum(hours_worked)),2) as costs_per_hour_worked 
from project_assignments 
group by project_name
order by costs_per_hour_worked;

/*Q4. Attendance Consistency:
- Measure attendance trends and identify departments with significant deviations*/
SELECT
    e.department_id,
    ROUND(AVG(a.days_present), 2) AS avg_days_present,
    ROUND(AVG(a.days_present + a.days_absent + a.sick_leaves + a.vacation_leaves), 2) AS avg_total_days,
    ROUND(STDDEV(a.days_present), 2) AS standard_deviation_of_days_present
FROM
    Attendance_Records a
JOIN
    Employee_Details e
    ON a.employeeid = e.employeeid
GROUP BY
    e.department_id
ORDER BY
    e.department_id;
	
	
/*Q5. Training and Project Success Correlation:
- Link training technologies with project milestones to assess the real-world impact of training*/

/*solution logic*/
-- Using CTE and unnesting first Training Technologies from comma seperated and then unnesting Project used Technologies
WITH RECURSIVE trained_techs AS (
  SELECT 
    employeeid,
    TRIM(SUBSTRING_INDEX(technologies_covered, ',', 1)) AS trained_tech,
    CASE 
      WHEN technologies_covered LIKE '%,%' THEN 
        SUBSTRING(technologies_covered, LOCATE(',', technologies_covered) + 1)
      ELSE NULL
    END AS rest
  FROM Training_Programs

  UNION ALL

  SELECT 
    employeeid,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS trained_tech,
    CASE 
      WHEN rest LIKE '%,%' THEN 
        SUBSTRING(rest, LOCATE(',', rest) + 1)
      ELSE NULL
    END AS rest
  FROM trained_techs
  WHERE rest IS NOT NULL
),

--  Unnest Project Technologies
project_techs AS (
  SELECT 
    project_id,
    employeeid,
    milestones_achieved,
    TRIM(SUBSTRING_INDEX(technologies_used, ',', 1)) AS project_tech,
    CASE 
      WHEN technologies_used LIKE '%,%' THEN 
        SUBSTRING(technologies_used, LOCATE(',', technologies_used) + 1)
      ELSE NULL
    END AS rest
  FROM Project_Assignments

  UNION ALL

  SELECT 
    project_id,
    employeeid,
    milestones_achieved,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS project_tech,
    CASE 
      WHEN rest LIKE '%,%' THEN 
        SUBSTRING(rest, LOCATE(',', rest) + 1)
      ELSE NULL
    END AS rest
  FROM project_techs
  WHERE rest IS NOT NULL
)

-- Match technologies and calculate impact
SELECT
  t.trained_tech,
  COUNT(DISTINCT p.project_id) AS contributing_projects,
  ROUND(AVG(p.milestones_achieved), 2) AS avg_milestones_achieved
FROM
  trained_techs t
JOIN
  project_techs p
  ON t.employeeid = p.employeeid
 AND LOWER(t.trained_tech) = LOWER(p.project_tech)
GROUP BY
  t.trained_tech
ORDER BY
  avg_milestones_achieved DESC;
  

/*Q6. High-Impact Employees:
- Identify employees who significantly contribute to high-budget projects while maintaining excellent performance scores.*/

SELECT e.employeeid, e.employeename,p.project_id,p.project_name,round(p.budget,2) as budget
FROM techsphere.employee_details e left join techsphere.project_assignments p 
on e.employeeid=p.employeeid
where performance_score='Excellent' and p.budget > (select AVG(budget) from project_assignments)
order by p.budget desc;  

/*Q7.
Cross Analysis of Training and Project Success
- Identify employees who have undergone training in specific technologies and contributed to high-performing projects using those technologies. */

/*Solution logic - using same logic in Q5 used */

WITH RECURSIVE trained_techs AS (
  SELECT 
    employeeid,
    TRIM(SUBSTRING_INDEX(technologies_covered, ',', 1)) AS trained_tech,
    CASE 
      WHEN technologies_covered LIKE '%,%' THEN 
        SUBSTRING(technologies_covered, LOCATE(',', technologies_covered) + 1)
      ELSE NULL
    END AS rest 
  FROM training_programs

  UNION ALL

  SELECT 
    employeeid,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS trained_tech,
    CASE 
      WHEN rest LIKE '%,%' THEN 
        SUBSTRING(rest, LOCATE(',', rest) + 1)
      ELSE NULL
    END AS rest
  FROM trained_techs
  WHERE rest IS NOT NULL
),

--  Unnest Project Technologies
project_techs AS (
  SELECT 
    project_id,
    employeeid,
    milestones_achieved,
    TRIM(SUBSTRING_INDEX(technologies_used, ',', 1)) AS project_tech,
    CASE 
      WHEN technologies_used LIKE '%,%' THEN 
        SUBSTRING(technologies_used, LOCATE(',', technologies_used) + 1)
      ELSE NULL
    END AS rest
  FROM Project_Assignments

  UNION ALL

  SELECT 
    project_id,
    employeeid,
    milestones_achieved,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS project_tech,
    CASE 
      WHEN rest LIKE '%,%' THEN 
        SUBSTRING(rest, LOCATE(',', rest) + 1)
      ELSE NULL
    END AS rest
  FROM project_techs
  WHERE rest IS NOT NULL
)

-- Match technologies and calculate impact
SELECT
  e.employeeid, e.employeename,
  t.trained_tech,
  COUNT(DISTINCT p.project_id) AS contributing_projects,
  ROUND(AVG(p.milestones_achieved), 2) AS avg_milestones_achieved
FROM
  trained_techs t
JOIN
  project_techs p
  ON t.employeeid = p.employeeid inner join employee_details e on e.employeeid=p.employeeid
 AND LOWER(t.trained_tech) = LOWER(p.project_tech)
GROUP BY
  e.employeeid, e.employeename,
  t.trained_tech

having ROUND(AVG(p.milestones_achieved), 2)>=5
 ORDER BY avg_milestones_achieved DESC;

