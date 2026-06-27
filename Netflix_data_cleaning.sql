Last login: Mon Jun 15 11:11:51 on console
(base) nandhu@Nandhushris-MacBook-Pro ~ % mysql -u root -p
Enter password: 
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
(base) nandhu@Nandhushris-MacBook-Pro ~ % mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 9.0.1 MySQL Community Server - GPL

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use netflix_raw;
ERROR 1049 (42000): Unknown database 'netflix_raw'
mysql> use netflix_churn;
ERROR 1049 (42000): Unknown database 'netflix_churn'
mysql> CREATE DATABASE netflix_retention;
ERROR 1007 (HY000): Can't create database 'netflix_retention'; database exists
mysql> USE netflix_retention;
Database changed
mysql> wc -l ~/Users/nandhu/Downloads/Netflix Customer Retention Intelligence Platform/Data/Customer_churn_analysis 1(DATA).csv
    -> ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'wc -l ~/Users/nandhu/Downloads/Netflix Customer Retention Intelligence Platform/' at line 1
mysql> CREATE TABLE netflix_raw (
    -> customer_id VARCHAR(50)
    -> subscription_length_months INT,
    -> customer_satisfaction_score INT,
    -> daily_watch_time_hours DECIMAL(5,2),
    -> engagement_rate INT,
    -> device_used_most_often VARCHAR(50),
    -> genre_preference VARCHAR(50),
    -> region VARCHAR(50),
    -> payment_history VARCHAR(20),
    -> subscription_plan VARCHAR(20),
    -> churn_status VARCHAR(10),
    -> support_queries_logged INT,
    -> age INT,
    -> monthly_income DECIMAL(10,2),
    -> promotional_offers_used INT,
    -> number_of_profiles_created INT
    -> );
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'subscription_length_months INT,
customer_satisfaction_score INT,
daily_watch_tim' at line 3
mysql> CREATE TABLE netflix_raw (customer_id VARCHAR(50), subscription_length_months INT, customer_satisfaction_score INT, daily_watch_time_hrs DECIMAL(5,2), engagement_rate INT, device_used_most_often VARCHAR(50), genre_preference VARCHAR(50), region VARCHAR(50), payment_history VARCHAR(20), subscription_plan VARCHAR(20), churn_status VARCHAR(10), support_queries_logged INT,
    -> age INT, monthly_income DECIMAL(10,2), promotional_offers_used INT, number_of_profiles_created INT);
Query OK, 0 rows affected (0.06 sec)

mysql> LOAD DATA LOCAL INFILE '/Users/nandhu/Downloads/Customer_churn_analysis 1(DATA).csv'
    -> INTO TABLE netflix_raw
    -> FIELDS TERMINATED BY ','
    -> ENCLOSED BY '"'
    -> LINES TERMINATED BY '\n'
    -> IGNORE 1 ROWS;
ERROR 3948 (42000): Loading local data is disabled; this must be enabled on both the client and server sides
mysql> SET GLOBAL local_infile = 1;
Query OK, 0 rows affected (0.00 sec)

mysql> SHOW VARIABLES LIKE 'local_infile';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| local_infile  | ON    |
+---------------+-------+
1 row in set (0.03 sec)

mysql> LOAD DATA LOCAL INFILE '/Users/nandhu/Downloads/Customer_churn_analysis 1(DATA).csv' INTO TABLE netflix_raw FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
ERROR 3948 (42000): Loading local data is disabled; this must be enabled on both the client and server sides
mysql> LOAD DATA LOCAL INFILE '/Users/nandhu/Downloads/Netflix Customer Retention Intelligence Platform/Customer_churn_analysis.csv'
    -> INTO TABLE netflix_raw
    -> FIELDS TERMINATED BY ','
    -> ENCLOSED BY '"'
    -> LINES TERMINATED BY '\n'
    -> IGNORE 1 ROWS;
ERROR 3948 (42000): Loading local data is disabled; this must be enabled on both the client and server sides
mysql> SET GLOBAL local_infile = 1;
Query OK, 0 rows affected (0.00 sec)

mysql> SHOW VARIABLES LIKE 'local_infile';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| local_infile  | ON    |
+---------------+-------+
1 row in set (0.01 sec)

mysql> LOAD DATA LOCAL INFILE '/Users/nandhu/Downloads/Netflix Customer Retention Intelligence Platform/Customer_churn_analysis.csv' INTO TABLE netflix_raw FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
ERROR 3948 (42000): Loading local data is disabled; this must be enabled on both the client and server sides
mysql> exit
Bye
(base) nandhu@Nandhushris-MacBook-Pro ~ % mysql --local-infile=1 -u root -p 
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 9.0.1 MySQL Community Server - GPL

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW VARIABLES LIKE 'local_infile';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| local_infile  | ON    |
+---------------+-------+
1 row in set (0.00 sec)

mysql> LOAD DATA LOCAL INFILE '/Users/nandhu/Downloads/Netflix Customer Retention Intelligence Platform/Customer_churn_analysis.csv' INTO TABLE netflix_raw FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
ERROR 1046 (3D000): No database selected
mysql> USE netflix_retention;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> LOAD DATA LOCAL INFILE '/Users/nandhu/Downloads/Netflix Customer Retention Intelligence Platform/Customer_churn_analysis.csv' INTO TABLE netflix_raw FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
ERROR 2 (HY000): File '/Users/nandhu/Downloads/Netflix Customer Retention Intelligence Platform/Customer_churn_analysis.csv' not found (Errcode: 2 - No such file or directory)
mysql> LOAD DATA LOCAL INFILE '/Users/nandhu/Downloads/Customer_churn_analysis 1(DATA).csv'
    -> INTO TABLE netflix_raw
    -> FIELDS TERMINATED BY ','
    -> ENCLOSED BY '"'
    -> LINES TERMINATED BY '\n'
    -> IGNORE 1 ROWS;
Query OK, 1048575 rows affected, 65535 warnings (5.35 sec)
Records: 1048575  Deleted: 0  Skipped: 0  Warnings: 9428175

mysql> SELECT * FROM netflix_raw
    -> LIMIT 10;
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
| customer_id | subscription_length_months | customer_satisfaction_score | daily_watch_time_hrs | engagement_rate | device_used_most_often | genre_preference | region        | payment_history | subscription_plan | churn_status | support_queries_logged | age  | monthly_income | promotional_offers_used | number_of_profiles_created |
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
| C00001      |                         12 |                          10 |                 4.85 |               4 | Tablet                 | Action           | Europe        | On-Time         | Basic             | No           |                     10 |   33 |        6250.00 |                       5 |                          2 |
| C00002      |                         12 |                           8 |                 1.75 |               9 | Laptop                 | Thriller         | Europe        | On-Time         | Basic             | Yes          |                      9 |   28 |        7018.00 |                       1 |                          5 |
| C00003      |                          3 |                           4 |                 2.75 |               9 | Smart TV               | Comedy           | Asia          | On-Time         | Premium           | Yes          |                      3 |   18 |        1055.00 |                       1 |                          5 |
| C00004      |                          3 |                           7 |                 3.00 |               9 | Smart TV               | ,Europe          | Delayed       | Premium         | No                | 5            |                     32 | 6707 |           5.00 |                       4 |                       NULL |
| C00005      |                         24 |                           2 |                 1.37 |               5 | Mobile                 | Drama            | North America | On-Time         | Standard          | Yes          |                      2 |   59 |        1506.00 |                       3 |                          5 |
| C00006      |                          3 |                           4 |                 4.95 |               3 | Tablet                 | Romance          | Africa        | Delayed         | Basic             | Yes          |                      7 |   69 |        5581.00 |                       4 |                          3 |
| C00007      |                         12 |                           4 |                 0.71 |               3 | Tablet                 | Thriller         | Africa        | Delayed         | Standard          | No           |                      3 |   25 |        2238.00 |                       2 |                          3 |
| C00008      |                          6 |                           5 |                 3.54 |               2 | Laptop                 | Romance          | South America | On-Time         | Standard          | Yes          |                      4 |   49 |        3630.00 |                       5 |                          3 |
| C00009      |                          6 |                           9 |                 3.79 |               1 | Laptop                 | Drama            | Africa        | On-Time         | Basic             | Yes          |                      6 |   27 |        4535.00 |                       1 |                          4 |
| C00010      |                          3 |                           6 |                 3.61 |               6 | Laptop                 | Action           | North America | On-Time         | Premium           | No           |                      0 |   56 |        7395.00 |                       2 |                          1 |
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
10 rows in set (0.01 sec)

mysql> SELECT COUNT(*)
    -> FROM netflix_raw;
+----------+
| COUNT(*) |
+----------+
|  1048575 |
+----------+
1 row in set (0.07 sec)

mysql> drop table netflix_raw;
Query OK, 0 rows affected (0.03 sec)

mysql> CREATE TABLE netflix_raw (customer_id VARCHAR(50), subscription_length_months INT, customer_satisfaction_score INT, daily_watch_time_hrs DECIMAL(5,2), engagement_rate INT, device_used_most_often VARCHAR(50), genre_preference VARCHAR(50), region VARCHAR(50), payment_history VARCHAR(20), subscription_plan VARCHAR(20), churn_status VARCHAR(10), support_queries_logged INT,
    -> age INT, monthly_income DECIMAL(10,2), promotional_offers_used INT, number_of_profiles_created INT);
Query OK, 0 rows affected (0.03 sec)

mysql> LOAD DATA LOCAL INFILE '/Users/nandhu/Downloads/Data_netflix.csv'
    -> INTO TABLE netflix_raw
    -> FIELDS TERMINATED BY ','
    -> ENCLOSED BY '"'
    -> LINES TERMINATED BY '\n'
    -> IGNORE 1 ROWS;
Query OK, 1000 rows affected, 1 warning (0.02 sec)
Records: 1000  Deleted: 0  Skipped: 0  Warnings: 1

mysql> select * from netflix_raw limit 5;
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
| customer_id | subscription_length_months | customer_satisfaction_score | daily_watch_time_hrs | engagement_rate | device_used_most_often | genre_preference | region        | payment_history | subscription_plan | churn_status | support_queries_logged | age  | monthly_income | promotional_offers_used | number_of_profiles_created |
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
| C00001      |                         12 |                          10 |                 4.85 |               4 | Tablet                 | Action           | Europe        | On-Time         | Basic             | No           |                     10 |   33 |        6250.00 |                       5 |                          2 |
| C00002      |                         12 |                           8 |                 1.75 |               9 | Laptop                 | Thriller         | Europe        | On-Time         | Basic             | Yes          |                      9 |   28 |        7018.00 |                       1 |                          5 |
| C00003      |                          3 |                           4 |                 2.75 |               9 | Smart TV               | Comedy           | Asia          | On-Time         | Premium           | Yes          |                      3 |   18 |        1055.00 |                       1 |                          5 |
| C00004      |                          3 |                           7 |                 3.00 |               9 | Smart TV               | ,Europe          | Delayed       | Premium         | No                | 5            |                     32 | 6707 |           5.00 |                       4 |                       NULL |
| C00005      |                         24 |                           2 |                 1.37 |               5 | Mobile                 | Drama            | North America | On-Time         | Standard          | Yes          |                      2 |   59 |        1506.00 |                       3 |                          5 |
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
5 rows in set (0.01 sec)

mysql> SELECT COUNT(*) FROM netflix_raw;
+----------+
| COUNT(*) |
+----------+
|     1000 |
+----------+
1 row in set (0.00 sec)

mysql> SELECT customer_id,
    -> COUNT(*)
    -> FROM netflix_raw
    -> GROUP BY customer_id
    -> HAVING COUNT(*) > 1;
Empty set (0.01 sec)

mysql> SELECT *
    -> FROM netflix_raw
    -> WHERE customer_satisfaction_score IS NULL;
Empty set (0.00 sec)

mysql> SELECT DISTINCT subscription_plan
    -> FROM netflix_raw;
+-------------------+
| subscription_plan |
+-------------------+
| Basic             |
| Premium           |
| No                |
| Standard          |
+-------------------+
4 rows in set (0.00 sec)

mysql> SELECT DISTINCT device_used_most_often
    -> FROM netflix_raw;
+------------------------+
| device_used_most_often |
+------------------------+
| Tablet                 |
| Laptop                 |
| Smart TV               |
| Mobile                 |
| Desktop                |
+------------------------+
5 rows in set (0.01 sec)

mysql> SELECT DISTINCT payment_history
    -> FROM netflix_raw;
+-----------------+
| payment_history |
+-----------------+
| On-Time         |
| Premium         |
| Delayed         |
+-----------------+
3 rows in set (0.00 sec)

mysql> select distinct genre_preference from netflix_raw;
+------------------+
| genre_preference |
+------------------+
| Action           |
| Thriller         |
| Comedy           |
| ,Europe          |
| Drama            |
| Romance          |
| Sci-Fi           |
| Documentary      |
+------------------+
8 rows in set (0.00 sec)

mysql> select distinct churn_status from netflix_raw;
+--------------+
| churn_status |
+--------------+
| No           |
| Yes          |
| 5            |
+--------------+
3 rows in set (0.00 sec)

mysql> SELECT *
    -> FROM netflix_raw
    -> WHERE customer_satisfaction_score NOT BETWEEN 1 AND 10;
Empty set (0.01 sec)

mysql> SELECT *
    -> FROM netflix_raw
    -> WHERE engagement_rate NOT BETWEEN 1 AND 10;
Empty set (0.00 sec)

mysql> SELECT *
    -> FROM netflix_raw
    -> WHERE age < 0 OR age > 100;
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
| customer_id | subscription_length_months | customer_satisfaction_score | daily_watch_time_hrs | engagement_rate | device_used_most_often | genre_preference | region  | payment_history | subscription_plan | churn_status | support_queries_logged | age  | monthly_income | promotional_offers_used | number_of_profiles_created |
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
| C00004      |                          3 |                           7 |                 3.00 |               9 | Smart TV               | ,Europe          | Delayed | Premium         | No                | 5            |                     32 | 6707 |           5.00 |                       4 |                       NULL |
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
1 row in set (0.01 sec)

mysql> SELECT *
    -> FROM netflix_raw
    -> WHERE daily_watch_time_hours < 0;
ERROR 1054 (42S22): Unknown column 'daily_watch_time_hours' in 'where clause'
mysql> SELECT * FROM netflix_raw WHERE daily_watch_time_hrs < 0;
Empty set (0.00 sec)

mysql> head -1 ~/Users/nandhu/Downloads/Data_netflix.csv;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'head -1 ~/Users/nandhu/Downloads/Data_netflix.csv' at line 1
mysql> head -1 ~/Users/nandhu/Downloads/Data_netflix.csv
    -> ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'head -1 ~/Users/nandhu/Downloads/Data_netflix.csv' at line 1
mysql> head -1 ~/Downloads/Data_netflix.csv;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'head -1 ~/Downloads/Data_netflix.csv' at line 1
mysql> exit
Bye
(base) nandhu@Nandhushris-MacBook-Pro ~ % head -1 ~/Downloads/Data_netflix.csv;
Customer ID,Subscription Length (Months),Customer Satisfaction Score (1-10),Daily Watch Time (Hours),Engagement Rate (1-10),Device Used Most Often,Genre Preference,Region,Payment History (On-Time/Delayed),Subscription Plan,Churn Status (Yes/No),Support Queries Logged,Age,Monthly Income ($),Promotional Offers Used,Number of Profiles Created
(base) nandhu@Nandhushris-MacBook-Pro ~ % head -2 ~/Downloads/Data_netflix.csv;
Customer ID,Subscription Length (Months),Customer Satisfaction Score (1-10),Daily Watch Time (Hours),Engagement Rate (1-10),Device Used Most Often,Genre Preference,Region,Payment History (On-Time/Delayed),Subscription Plan,Churn Status (Yes/No),Support Queries Logged,Age,Monthly Income ($),Promotional Offers Used,Number of Profiles Created
C00001,12,10,4.85,4,Tablet,Action,Europe,On-Time,Basic,No,10,33,6250,5,2
(base) nandhu@Nandhushris-MacBook-Pro ~ %  USE netflix_retention; 
zsh: command not found: USE
(base) nandhu@Nandhushris-MacBook-Pro ~ % mysql --local-infile=1 -u root -p  
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 9.0.1 MySQL Community Server - GPL

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use netflix_retention;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT COUNT(*) FROM netflix_raw;
+----------+
| COUNT(*) |
+----------+
|     1000 |
+----------+
1 row in set (0.01 sec)

mysql> SHOW WARNINGS;
Empty set (0.00 sec)

mysql> SELECT * FROM netflix_raw LIMIT 5;
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
| customer_id | subscription_length_months | customer_satisfaction_score | daily_watch_time_hrs | engagement_rate | device_used_most_often | genre_preference | region        | payment_history | subscription_plan | churn_status | support_queries_logged | age  | monthly_income | promotional_offers_used | number_of_profiles_created |
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
| C00001      |                         12 |                          10 |                 4.85 |               4 | Tablet                 | Action           | Europe        | On-Time         | Basic             | No           |                     10 |   33 |        6250.00 |                       5 |                          2 |
| C00002      |                         12 |                           8 |                 1.75 |               9 | Laptop                 | Thriller         | Europe        | On-Time         | Basic             | Yes          |                      9 |   28 |        7018.00 |                       1 |                          5 |
| C00003      |                          3 |                           4 |                 2.75 |               9 | Smart TV               | Comedy           | Asia          | On-Time         | Premium           | Yes          |                      3 |   18 |        1055.00 |                       1 |                          5 |
| C00004      |                          3 |                           7 |                 3.00 |               9 | Smart TV               | ,Europe          | Delayed       | Premium         | No                | 5            |                     32 | 6707 |           5.00 |                       4 |                       NULL |
| C00005      |                         24 |                           2 |                 1.37 |               5 | Mobile                 | Drama            | North America | On-Time         | Standard          | Yes          |                      2 |   59 |        1506.00 |                       3 |                          5 |
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
5 rows in set (0.00 sec)

mysql> DELETE FROM netflix_raw
    -> WHERE age > 100;
Query OK, 1 row affected (0.05 sec)

mysql> DELETE FROM netflix_raw
    -> WHERE churn_status NOT IN ('Yes','No');
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT COUNT(*)
    -> FROM netflix_raw
    -> WHERE age > 100;
+----------+
| COUNT(*) |
+----------+
|        0 |
+----------+
1 row in set (0.01 sec)

mysql> SELECT COUNT(*)
    -> FROM netflix_raw
    -> WHERE churn_status NOT IN ('Yes','No');
+----------+
| COUNT(*) |
+----------+
|        0 |
+----------+
1 row in set (0.00 sec)

mysql> SELECT COUNT(*)
    -> FROM netflix_raw
    -> WHERE number_of_profiles_created IS NULL;
+----------+
| COUNT(*) |
+----------+
|        0 |
+----------+
1 row in set (0.00 sec)

mysql> SELECT DISTINCT region
    -> FROM netflix_raw;
+---------------+
| region        |
+---------------+
| Europe        |
| Asia          |
| North America |
| Africa        |
| South America |
+---------------+
5 rows in set (0.00 sec)

mysql> SELECT DISTINCT churn_status
    -> FROM netflix_raw;
+--------------+
| churn_status |
+--------------+
| No           |
| Yes          |
+--------------+
2 rows in set (0.00 sec)

mysql> SELECT *
    -> FROM netflix_raw
    -> WHERE age > 100
    -> OR age < 0;
Empty set (0.00 sec)

mysql> SELECT COUNT(*) FROM netflix_raw;
+----------+
| COUNT(*) |
+----------+
|      999 |
+----------+
1 row in set (0.01 sec)

mysql> SELECT customer_id, COUNT(*)
    -> FROM netflix_raw
    -> GROUP BY customer_id
    -> HAVING COUNT(*) > 1;
Empty set (0.01 sec)

mysql> SELECT
    -> COUNT(*) - COUNT(customer_id) AS missing_customer_id,
    -> COUNT(*) - COUNT(subscription_plan) AS missing_plan,
    -> COUNT(*) - COUNT(region) AS missing_region,
    -> COUNT(*) - COUNT(churn_status) AS missing_churn
    -> FROM netflix_raw;
+---------------------+--------------+----------------+---------------+
| missing_customer_id | missing_plan | missing_region | missing_churn |
+---------------------+--------------+----------------+---------------+
|                   0 |            0 |              0 |             0 |
+---------------------+--------------+----------------+---------------+
1 row in set (0.01 sec)

mysql> SELECT customer_id,
    -> COUNT(*)
    -> FROM netflix_raw
    -> GROUP BY customer_id
    -> HAVING COUNT(*) > 1;
Empty set (0.01 sec)

mysql> SELECT *
    -> FROM netflix_raw
    -> WHERE customer_satisfaction_score IS NULL;
Empty set (0.00 sec)

mysql> SELECT *
    -> FROM netflix_raw
    -> WHERE age < 0 OR age > 100;
Empty set (0.00 sec)

mysql> SELECT *
    -> FROM netflix_raw
    -> WHERE daily_watch_time_hours < 0;
ERROR 1054 (42S22): Unknown column 'daily_watch_time_hours' in 'where clause'
mysql> SELECT * FROM netflix_raw WHERE daily_watch_time_hrs < 0;
Empty set (0.01 sec)

mysql> CREATE TABLE netflix_clean AS
    -> SELECT *
    -> FROM netflix_raw;
Query OK, 999 rows affected (0.05 sec)
Records: 999  Duplicates: 0  Warnings: 0

mysql> SELECT subscription_plan,
    -> COUNT(*) AS total_customers
    -> FROM netflix_clean
    -> GROUP BY subscription_plan
    -> ORDER BY total_customers DESC;
+-------------------+-----------------+
| subscription_plan | total_customers |
+-------------------+-----------------+
| Standard          |             352 |
| Premium           |             328 |
| Basic             |             319 |
+-------------------+-----------------+
3 rows in set (0.01 sec)

mysql> SELECT device_used_most_often,
    -> COUNT(*) AS users
    -> FROM netflix_clean
    -> GROUP BY device_used_most_often
    -> ORDER BY users DESC;
+------------------------+-------+
| device_used_most_often | users |
+------------------------+-------+
| Laptop                 |   225 |
| Mobile                 |   201 |
| Tablet                 |   200 |
| Smart TV               |   188 |
| Desktop                |   185 |
+------------------------+-------+
5 rows in set (0.01 sec)

mysql> SELECT genre_preference,
    -> AVG(daily_watch_time_hours) AS avg_watch_time
    -> FROM netflix_clean
    -> GROUP BY genre_preference
    -> ORDER BY avg_watch_time DESC;
ERROR 1054 (42S22): Unknown column 'daily_watch_time_hours' in 'field list'
mysql> 
