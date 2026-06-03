CREATE TABLE ai_on_job
(
	Employee_ID	VARCHAR (10),
	Age	INT,
	Gender VARCHAR (10),
	Education_Level	VARCHAR (20),
	Industry VARCHAR (20),	
	Job_Role VARCHAR (30),
	Years_Experience INT,
	AI_Adoption_Level VARCHAR (10),	
	Automation_Risk VARCHAR (10),
	Upskilling_Required	VARCHAR (5),
	Salary_Before_AI INT,	
	Salary_After_AI	INT,
	Job_Status VARCHAR (15),
	Work_Hours_Per_Week	INT,
	Remote_Work	VARCHAR (5),
	Job_Satisfaction INT,	
	Productivity_Change NUMERIC (10,2)

);

COPY ai_on_job
FROM 'D:\New Datasets\ai_job_impact.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM ai_on_job;

-- Possible Business Problems and Solutions: -

-- * Average Salary Before AI : -
CREATE VIEW Average_Salary_Before_AI AS
SELECT
	ROUND(AVG(Salary_Before_AI),2) AS Average_Salary_Before_AI_Adoption
FROM ai_on_job;

-- * Average Salary After AI : -
CREATE VIEW Average_Salary_After_AI AS
SELECT
	ROUND(AVG(Salary_After_AI),2) AS Average_Salary_After_AI_Adoption
FROM ai_on_job;

-- * Change of Average Salary After AI Adoption : -
CREATE VIEW Change_of_Salary_After_AI_Adoption AS
SELECT
	ROUND(AVG(Salary_Before_AI),2) AS Average_Salary_Before_AI_Adoption,
	ROUND(AVG(Salary_After_AI),2) AS Average_Salary_After_AI_Adoption,
	ROUND(AVG(Salary_After_AI-Salary_Before_AI),2) AS Average_Change_of_Salary_After_AI_Adoption
FROM ai_on_job;

-- * Industries with Highest AI Adoption : -
CREATE VIEW Industries_with_highest_AI_Adoption AS
SELECT
	Industry,
	AI_Adoption_Level,
	COUNT (*) AS Total_no_of_Employees
FROM ai_on_job
GROUP BY 1,2
ORDER BY Total_no_of_Employees DESC;

-- * Industries with Highest Automation Risk : -
CREATE VIEW Industries_with_Highest_Automation_Risk AS
SELECT
	Industry,
	Automation_Risk,
	COUNT (*) AS Total_n0_of_Employees
FROM ai_on_job
WHERE Automation_Risk = 'High'
GROUP BY 1,2
ORDER BY 3 DESC;

-- No. of Replaced Job Roles : -
CREATE VIEW Replaced_Jobs AS
SELECT
	Job_Role,
	Gender,
	COUNT (*) AS No_of_Replaced_Employees
FROM ai_on_job
WHERE Job_Status = 'Replaced'
GROUP BY Job_Role, Gender
ORDER BY No_of_Replaced_Employees DESC;

-- * No. of Modified Job Roles : -
CREATE VIEW Modified_Jobs AS
SELECT
	Job_Role,
	Gender,
	COUNT (*) AS No_of_Modified_Employees
FROM ai_on_job
WHERE Job_Status = 'Modified'
GROUP BY Job_Role, Gender
ORDER BY No_of_Modified_Employees DESC;

-- * No. of Unchanged Job Roles : -
CREATE VIEW Unchanged_Jobs AS
SELECT
	Job_Role,
	Gender,
	COUNT (*) AS No_of_Unchanged_Employees
FROM ai_on_job
WHERE Job_Status = 'Unchanged'
GROUP BY Job_Role, Gender
ORDER BY No_of_Unchanged_Employees DESC;

-- * Impact of AI on Productivity : -
CREATE VIEW Impact_of_AI_on_Productivity AS
SELECT
	AI_Adoption_Level,
	ROUND (AVG(Productivity_Change),2) AS Avg_Productivity_Change
FROM ai_on_job
GROUP BY 1
ORDER BY 2;

-- * No. of Employees with High AI Adoption Level : -
CREATE VIEW Employees_with_High_AI_Adoption_Level AS
SELECT
	Gender,
	Age,
	AI_Adoption_Level,
	COUNT (*) AS Total_no_Of_Employees
FROM ai_on_job
WHERE AI_Adoption_Level = 'High'
GROUP BY 1,2,3
ORDER BY 2 DESC;

-- * Salary Growth After AI Adoption : -
CREATE VIEW Salary_Growth_After_AI_Adoption AS
SELECT
	Gender,
	Age,
	ROUND(AVG(Salary_After_AI-Salary_Before_AI),2) AS Average_Change_of_Salary_After_AI_Adoption,
	COUNT (*) AS Total_no_of_Employees
FROM ai_on_job
GROUP BY Gender, Age
ORDER BY Average_Change_of_Salary_After_AI_Adoption DESC;

-- * Productivity of Remote Workers : -
CREATE VIEW Productivity_of_Remote_Workers AS
SELECT
	Remote_Work,
	Job_Role,
	ROUND (AVG(Productivity_Change),2) AS Avg_Productivity_Change,
	COUNT (*) AS Total_no_of_Employees
FROM ai_on_job
WHERE Remote_Work = 'Yes'
GROUP BY 1,2
ORDER BY 3 DESC;

-- * Remote Work Trends : -
CREATE VIEW Remote_Work_Trends AS
SELECT
Industry,
COUNT (*) AS No_of_Remote_Workers
FROM ai_on_job
WHERE Remote_Work = 'Yes'
GROUP BY Industry
ORDER BY No_of_Remote_Workers;

-- * On-Site Work Trends : -

CREATE VIEW On_Site_Work_Trends AS
SELECT
	Industry,
	COUNT (*) AS No_of_On_Site_Workers
FROM ai_on_job
WHERE Remote_Work = 'No'
GROUP BY Industry
ORDER BY No_of_On_Site_Workers;

-- * Industries Requiring Upskilling of Employees : -
CREATE VIEW Industries_Requiring_Upskilling_of_Employees AS
SELECT
	Industry,
	Job_Role,
	COUNT (*) AS No_of_Employees_needing_Upskilling
FROM ai_on_job
WHERE Upskilling_Required = 'Yes'
GROUP BY 1,2
ORDER BY 3;

-- * Average Job Satisfaction of Employees After AI Adoption : -
CREATE VIEW Average_Job_Satisfaction_of_Employees_After_AI_Adoption AS
SELECT
	Job_Role,
	AI_Adoption_Level,
	ROUND(AVG(Job_Satisfaction),2) AS Avg_Job_Satisfaction
FROM ai_on_job
GROUP BY 1,2
ORDER BY 3 DESC;

-- * Top 10 Industries with Longest Average Working Hours Per Week : -
CREATE VIEW Top_10_Industries_with_Longest_Average_Working_Hours_Per_Week AS
SELECT
	Industry,
	Job_Role,
	Remote_Work,
	ROUND (AVG(Work_Hours_Per_Week),2) AS Avg_Working_Hours_per_Week
FROM ai_on_job
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 10;

-- * Experience Wise AI Adoption Level : -
CREATE VIEW Experience_Wise_AI_Adoption_Level AS
SELECT
	CASE WHEN Years_Experience < 5 THEN '0 - 5 Years Experience'
	     WHEN Years_Experience BETWEEN 5 AND 10 THEN '5 - 10 Years Experience'
		 WHEN Years_Experience BETWEEN 11 AND 20 THEN '11 - 20 Years Experience'
		 WHEN Years_Experience BETWEEN 21 AND 30 THEN '21 - 30 Years Experience'
		 ELSE '30+ Years Experience' END AS Experience_Category,
	
		AI_Adoption_Level,
		Age,
		COUNT (*) AS Total_no_of_Employees
FROM ai_on_job
GROUP BY 1, 2, 3
ORDER BY 2,4 DESC;

-- * Employees with Decreased Salary After Adoption of AI : -
CREATE VIEW Employees_with_Decreased_Salary_After_Adoption_of_AI AS
SELECT
	Employee_ID,
	Industry,
	Education_Level,
	Job_Role,
	Years_Experience,
	Salary_Before_AI,
	Salary_After_AI,
	(Salary_After_AI-Salary_Before_AI) AS Change_of_Salary
FROM ai_on_job
WHERE Salary_After_AI < Salary_Before_AI  
ORDER BY Change_of_Salary DESC;

-- * Most Common Job Status : -

CREATE VIEW Most_Common_Job_Status AS
SELECT
	Job_Status,
	Job_Role,
	Years_Experience,
	COUNT (*) AS Total_no_of_Employees
FROM ai_on_job
GROUP BY 1, 2, 3
ORDER BY Total_no_of_Employees DESC;

-- * Top 50 Employees with Highest Productivity : -
CREATE VIEW Top_50_Employees_with_Highest_Productivity AS
SELECT
	Employee_ID	,
	Age,
	Gender,
	Industry,
	Job_Role,
	Years_Experience,
	Productivity_Change 
FROM ai_on_job
ORDER BY Productivity_Change DESC
LIMIT 50;

-- * Productivity and Job Status : -
CREATE VIEW Productivity_and_Job_Status AS
SELECT
	Job_Status,
	ROUND (AVG(Productivity_Change),2) AS Avg_Productivity_Change,
	COUNT (*) Total_no_of_Employees
FROM ai_on_job
GROUP BY 1
ORDER BY 2, 3 DESC;

-- * Rank of Industries On The Basis of Average Salary After Adoption of AI : -
CREATE VIEW Rank_of_Industries_On_The_Basis_of_Average_Salary_After_Adoption_of_AI AS
SELECT 
	Industry,
	ROUND(AVG(Salary_After_AI),2) AS Average_Salary_After_AI_Adoption,
	RANK () OVER (ORDER BY ROUND(AVG(Salary_After_AI),2) DESC) AS Rank_of_Salary
FROM ai_on_job
GROUP BY Industry;

-- * Top 5 Highest Paid Jobs In Each Industry : -
CREATE VIEW Top_5_Highest_Paid_Jobs_In_Each_Industry AS
SELECT
 *
 FROM
	 (
	 SELECT
		 Job_Role,
		 Job_status,
		 Industry,
		 ROUND(AVG(Salary_After_AI),2) AS Average_Salary_After_AI_Adoption,
		 RANK () OVER(PARTITION BY Industry ORDER BY ROUND(AVG(Salary_After_AI),2) DESC) AS Rank_of_Salary
	 FROM ai_on_job
	 GROUP BY 1, 2, 3
	 ) AS Rank_of_Jobs

WHERE Rank_of_Salary <= 5;

-- * Percentage of Job Replacement by AI : -
CREATE VIEW Percentage_of_Job_Replacement_by_AI AS
SELECT
	ROUND (100 * COUNT (*) FILTER (WHERE Job_status = 'Replaced') / COUNT (*) , 2) AS Percentage_of_Job_Replacement
FROM ai_on_job;

-- * Creation of View for Salary : -
CREATE VIEW Analysis_of_Salaries AS
SELECT
    Employee_ID	,
	Age,
	Gender,
	Industry,
	Job_Role,
	Years_Experience,
	Salary_Before_AI,
	Salary_After_AI,
	(Salary_After_AI-Salary_Before_AI) AS Change_of_Salary
FROM ai_on_job;

-- * Creation of View for KPIs : -
CREATE VIEW kpi_cards_view AS
SELECT
	COUNT (*) AS Total_no_of_Employees,
	ROUND(AVG(Salary_Before_AI),2) AS Average_Salary_Before_AI_Adoption,
	ROUND(AVG(Salary_After_AI),2) AS Average_Salary_After_AI_Adoption,
	ROUND(AVG(Salary_After_AI-Salary_Before_AI),2) AS Average_Change_of_Salary_After_AI_Adoption,
	ROUND(AVG(Job_Satisfaction),2) AS Avg_Job_Satisfaction,
	ROUND (AVG(Productivity_Change),2) AS Avg_Productivity_Change
FROM ai_on_job;

-- * View for Total no. of Employees : -
CREATE VIEW total_no_of_Employees AS
SELECT
	COUNT (*) AS Total_no_of_Employees
FROM ai_on_job;

















