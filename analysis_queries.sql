-- Construction Project Analytics
-- Author: Adil Zafar

USE construction_db;

-- 1. Risk Level wise Cost Analysis
SELECT Risk_Level, COUNT(*) as Total_Tasks,
ROUND(AVG(Material_Cost_USD), 2) as Avg_Cost,
ROUND(SUM(Material_Cost_USD), 2) as Total_Cost
FROM construction_dataset
GROUP BY Risk_Level;

-- 2. Top 10 Delayed Tasks
SELECT Task_ID, Start_Constraint, Risk_Level, Material_Cost_USD
FROM construction_dataset
ORDER BY Start_Constraint DESC LIMIT 10;

-- 3. Resource Utilization Analysis
SELECT CASE 
WHEN Resource_Constraint_Score > 0.8 THEN 'High Utilization'
WHEN Resource_Constraint_Score > 0.5 THEN 'Medium Utilization'
ELSE 'Low Utilization' END as Category,
COUNT(*) as Task_Count,
ROUND(AVG(Material_Cost_USD), 2) as Avg_Cost
FROM construction_dataset GROUP BY Category;

-- 4. Window Function - Cost Variance
SELECT Risk_Level, Task_ID, Material_Cost_USD,
ROUND(AVG(Material_Cost_USD) OVER (PARTITION BY Risk_Level), 2) as Risk_Avg,
ROUND(Material_Cost_USD - AVG(Material_Cost_USD) OVER (PARTITION BY Risk_Level), 2) as Variance
FROM construction_dataset ORDER BY Risk_Level, Variance DESC LIMIT 20;

-- 5. Master Summary
SELECT Risk_Level, COUNT(*) as Total_Tasks,
ROUND(AVG(Task_Duration_Days), 1) as Avg_Duration,
ROUND(AVG(Start_Constraint), 1) as Avg_Delay,
ROUND(SUM(Material_Cost_USD), 2) as Total_Cost
FROM construction_dataset GROUP BY Risk_Level ORDER BY Total_Cost DESC;
