/*

What are the most in-demand skills for Data Analyst roles?
- Identify top 5 in-demand skills across all Data Analyst job postings

*/

SELECT
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
    job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skill_name
ORDER BY
    demand_count DESC
LIMIT 10;