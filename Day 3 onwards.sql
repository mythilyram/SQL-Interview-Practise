--Leet Code - Top SQL 50
--1757. https://leetcode.com/problems/recyclable-and-low-fat-products/description/?envType=study-plan-v2&envId=top-sql-50
--Write a solution to find the IDs of products that are both low-fat and recyclable.
SELECT
    product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y'

-- 584. https://leetcode.com/problems/find-customer-referee/?envType=study-plan-v2&envId=top-sql-50
-- Find the names of the customer that are not referred by the customer with id = 2.
SELECT 
    name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL

-- 595. https://leetcode.com/problems/big-countries/description/?envType=study-plan-v2&envId=top-sql-50
/* A country is big if:
it has an area of at least three million (i.e., 3000000 km2), or
it has a population of at least twenty-five million (i.e., 25000000).
Write a solution to find the name, population, and area of the big countries.*/
SELECT
    name, 
    population,
    area
FROM World
WHERE area >= 3000000 OR
    population >= 25000000

-- 1148. https://leetcode.com/problems/article-views-i/description/?envType=study-plan-v2&envId=top-sql-50
-- Write a solution to find all the authors who viewed at least one of their articles. Return the result table sorted by id in ascending order.
SELECT
    DISTINCT(au.author_id) AS id
FROM Views au
--JOIN Views vi
--ON au.viewer_id = vi.author_id
WHERE au.viewer_id = au.author_id
ORDER BY au.author_id

--1683. https://leetcode.com/problems/invalid-tweets/description/?envType=study-plan-v2&envId=top-sql-50
-- Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.
SELECT
    tweet_id
FROM Tweets
WHERE LENGTH(content) > 15

-- 1378. https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/description/?envType=study-plan-v2&envId=top-sql-50
-- Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.
SELECT
     unique_id,
     name
FROM Employees E
LEFT JOIN EmployeeUNI EU
ON E.id = EU.id
/* Left Join gets all records of left table and only the matching records from right table. If not found, shows 'null' */

-- 1068. https://leetcode.com/problems/product-sales-analysis-i/description/?envType=study-plan-v2&envId=top-sql-50
-- Write a solution to report the product_name, year, and price for each sale_id in the Sales table.
SELECT
    p.product_name,
    s.year,
    s.price
FROM Sales s
JOIN Product p
USING (product_id)
GROUP BY s.sale_id
-- primary key - foreign key, for each sale_id implies to GROUP BY sale_id

-- 1581. https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/description/?envType=study-plan-v2&envId=top-sql-50
-- Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.
SELECT
    customer_id,
    COUNT(visit_id) AS count_no_trans
FROM Visits v
LEFT JOIN Transactions t
USING (visit_id)
WHERE transaction_id IS NULL
GROUP BY customer_id
/* If they did not make any transactions, while left joining, transaction_id is null.
 To find the number of times each customer made these types of visits, GROUP BY customer_id*/

-- 197. https://leetcode.com/problems/rising-temperature/?envType=study-plan-v2&envId=top-sql-50
-- Write a solution to find all dates' Id with higher temperatures compared to its previous dates (yesterday).
SELECT 
        t2.id
    FROM Weather t1
    JOIN Weather t2    
    ON DATE_ADD(t1.recordDate,INTERVAL 1 DAY) = t2.recordDate
    /* Use the date add function, consider the whole date to get the next date.*/
    WHERE t2.temperature > t1.temperature
-- https://www.linkedin.com/posts/mythilyramanathan_day-4-activity-7144657978044936192-8_-_?utm_source=share&utm_medium=member_desktop

-- 1661. https://leetcode.com/problems/average-time-of-process-per-machine/description/?envType=study-plan-v2&envId=top-sql-50
/*There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.
The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.
The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.*/
SELECT 
    A1.machine_id,
    ROUND(AVG(A2.timestamp - A1.timestamp),3) AS processing_time
FROM Activity A1, Activity A2 
WHERE A1.machine_id = A2.machine_id AND 
      A1.process_id = A2.process_id AND 
      A1.timestamp < A2.timestamp
GROUP BY A1.machine_id

-- 577. https://leetcode.com/problems/employee-bonus/?envType=study-plan-v2&envId=top-sql-50
-- Write a solution to report the name and bonus amount of each employee with a bonus of less than 1000.
SELECT
    E.name,
    B.bonus
FROM Employee E
LEFT JOIN Bonus B
    USING(empId)
WHERE bonus <1000 OR bonus is NULL

-- 1280. https://leetcode.com/problems/students-and-examinations/?envType=study-plan-v2&envId=top-sql-50
-- Write a solution to find the number of times each student attended each exam.  
SELECT
    ST.student_id,
    ST.student_name,
    SU.subject_name,
    COUNT(E.subject_name) AS attended_exams
FROM Students ST
JOIN  Subjects SU
LEFT JOIN Examinations E
    ON ST.student_id= e.student_id AND SU.subject_name= E.subject_name

--Day 10 - 1174. https://leetcode.com/problems/immediate-food-delivery-ii/?envType=study-plan-v2&envId=top-sql-50
-- Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.    
    SELECT 
    ROUND(SUM(CASE WHEN 
          order_date = customer_pref_delivery_date 
          THEN 1 ELSE 0 END) 
   * 100.0  
   / COUNT(DISTINCT customer_id), 2) AS immediate_percentage
FROM Delivery
WHERE (customer_id, order_date) IN 
	(SELECT 
     customer_id, MIN(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id)

GROUP BY ST.student_id,SU.subject_name
ORDER BY ST.student_id,SU.subject_name
