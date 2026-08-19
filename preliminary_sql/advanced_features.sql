SELECT
    job_schedule_type,
    AVG(salary_hour_avg) AS hour_avg,
    AVG(salary_year_avg) AS yearly_avg
FROM
    job_postings_fact
WHERE
    job_posted_date::DATE > '2023-06-02'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type ASC;

SELECT *
FROM job_postings_fact
LIMIT 5;

CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'On-site'
    END AS location_category,
    COUNT(job_id) AS number_jobs, 
    AVG(salary_year_avg) AS avg_year_salary
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category
ORDER BY
    avg_year_salary DESC;

SELECT
    company_id,
    name AS company_name
FROM
    company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
)
ORDER BY
    company_id;

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*)
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    name,
    company_job_count.count AS number_listings
FROM
    company_dim
LEFT JOIN
    company_job_count ON
    company_job_count.company_id = company_dim.company_id
ORDER BY
    number_listings DESC;

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim as skills_to_job
    INNER JOIN
        job_postings_fact AS jp ON
        jp.job_id = skills_to_job.job_id
    WHERE
        jp.job_work_from_home = true AND
        jp.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    skills.skill_id,
    skills.skills as skill_name,
    skill_count
FROM
    remote_job_skills
INNER JOIN
    skills_dim AS skills ON
    skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
    SELECT
        *
    FROM
        january_jobs
    UNION ALL
    SELECT
        *
    FROM
        february_jobs
    UNION ALL
    SELECT
        *
    FROM
        march_jobs
) AS q1_postings
WHERE
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;

WITH q1_postings AS (
    SELECT
        *
    FROM
        january_jobs
    UNION ALL
    SELECT
        *
    FROM
        february_jobs
    UNION ALL
    SELECT
        *
    FROM
        march_jobs
)

SELECT
    job_location,
    AVG(q1_postings.salary_year_avg) AS avg_year_salary
FROM
    q1_postings
WHERE
    q1_postings.salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
GROUP BY
    job_location
ORDER BY
    avg_year_salary DESC;


WITH q1_postings AS (
    SELECT
        *
    FROM
        january_jobs
    UNION ALL
    SELECT
        *
    FROM
        february_jobs
    UNION ALL
    SELECT
        *
    FROM
        march_jobs
)

SELECT
    job_location,
    job_id,
    salary_year_avg
FROM
    q1_postings
WHERE
    job_location LIKE '%Fairfax%';