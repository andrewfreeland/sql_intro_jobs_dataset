/*

What are the skills required for the top 10 highest paying roles?
- Identify skills associated with top 10 highest-paying Data
  Analyst roles from first query
- Additonally look at frequency of each skill

*/

-- CTE of highest paying jobs

WITH highest_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        company_dim.name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON
        job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    skills_dim.skills,
    COUNT(highest_paying_jobs.job_id) AS frequency
FROM 
    highest_paying_jobs
INNER JOIN 
    skills_job_dim ON
    highest_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    frequency DESC;