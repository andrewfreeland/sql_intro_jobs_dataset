/*

What are the optimal skills to learn for remote Data Analyst roles?
- Optimal skill = high avg salary + high demand count
- Demand count >= 15
- Limited to top 25 skills

*/


WITH in_demand_skills AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills AS skill_name,
        COUNT(job_postings_fact.job_id) AS demand_count
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
        skills_dim.skill_id
), avg_salary AS (
    SELECT
        skills_dim.skill_id,
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
        skills_dim.skill_id
)

SELECT
    in_demand_skills.skill_id,
    in_demand_skills.skill_name,
    demand_count,
    avg_yearly_salary
FROM
    in_demand_skills
INNER JOIN
    avg_salary ON
    in_demand_skills.skill_id = avg_salary.skill_id
WHERE
    demand_count >= 15
ORDER BY
    avg_yearly_salary DESC,
    demand_count DESC
LIMIT 25;