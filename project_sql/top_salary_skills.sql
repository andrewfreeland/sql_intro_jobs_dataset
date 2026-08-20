/*

What are the highest paying skills?
- Look into Data Analyst skills with highest average earnings
- Aggregating average salary per skill
- Only focusing on specified salaries i.e. removing nulls

*/

SELECT
    skills_dim.skills AS skill_name,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_yearly_salary
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skill_name
ORDER BY
    avg_yearly_salary DESC
LIMIT 10;