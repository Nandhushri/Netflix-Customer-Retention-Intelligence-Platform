Last login: Mon Jun 15 14:45:49 on ttys001
(base) nandhu@Nandhushris-MacBook-Pro ~ % mysql --local-infile=1 -u root -p 
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
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
1 row in set (0.03 sec)

mysql> use netflix_retention;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT COUNT(*)
    -> FROM netflix_raw limit 6;
+----------+
| COUNT(*) |
+----------+
|      999 |
+----------+
1 row in set (0.01 sec)

mysql> SELECT COUNT(*) FROM netflix_raw;
+----------+
| COUNT(*) |
+----------+
|      999 |
+----------+
1 row in set (0.00 sec)

mysql> SELECT * FROM netflix_raw LIMIT 5;
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
| customer_id | subscription_length_months | customer_satisfaction_score | daily_watch_time_hrs | engagement_rate | device_used_most_often | genre_preference | region        | payment_history | subscription_plan | churn_status | support_queries_logged | age  | monthly_income | promotional_offers_used | number_of_profiles_created |
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
| C00001      |                         12 |                          10 |                 4.85 |               4 | Tablet                 | Action           | Europe        | On-Time         | Basic             | No           |                     10 |   33 |        6250.00 |                       5 |                          2 |
| C00002      |                         12 |                           8 |                 1.75 |               9 | Laptop                 | Thriller         | Europe        | On-Time         | Basic             | Yes          |                      9 |   28 |        7018.00 |                       1 |                          5 |
| C00003      |                          3 |                           4 |                 2.75 |               9 | Smart TV               | Comedy           | Asia          | On-Time         | Premium           | Yes          |                      3 |   18 |        1055.00 |                       1 |                          5 |
| C00005      |                         24 |                           2 |                 1.37 |               5 | Mobile                 | Drama            | North America | On-Time         | Standard          | Yes          |                      2 |   59 |        1506.00 |                       3 |                          5 |
| C00006      |                          3 |                           4 |                 4.95 |               3 | Tablet                 | Romance          | Africa        | Delayed         | Basic             | Yes          |                      7 |   69 |        5581.00 |                       4 |                          3 |
+-------------+----------------------------+-----------------------------+----------------------+-----------------+------------------------+------------------+---------------+-----------------+-------------------+--------------+------------------------+------+----------------+-------------------------+----------------------------+
5 rows in set (0.00 sec)

mysql> SELECT subscription_plan, COUNT(*) AS total_customers FROM netflix_clean GROUP BY subscription_plan ORDER BY total_customers DESC;
+-------------------+-----------------+
| subscription_plan | total_customers |
+-------------------+-----------------+
| Standard          |             352 |
| Premium           |             328 |
| Basic             |             319 |
+-------------------+-----------------+
3 rows in set (0.01 sec)

mysql> SELECT device_used_most_often, COUNT(*) AS users FROM netflix_clean GROUP BY device_used_most_often ORDER BY users DESC;
+------------------------+-------+
| device_used_most_often | users |
+------------------------+-------+
| Laptop                 |   225 |
| Mobile                 |   201 |
| Tablet                 |   200 |
| Smart TV               |   188 |
| Desktop                |   185 |
+------------------------+-------+
5 rows in set (0.00 sec)

mysql> SELECT genre_preference, AVG(daily_watch_time_hrs) AS avg_watch_time FROM netflix_clean GROUP BY genre_preference ORDER BY avg_watch_time DESC;
+------------------+----------------+
| genre_preference | avg_watch_time |
+------------------+----------------+
| Action           |       2.936029 |
| Romance          |       2.923819 |
| Thriller         |       2.885929 |
| Sci-Fi           |       2.802395 |
| Drama            |       2.793147 |
| Comedy           |       2.746692 |
| Documentary      |       2.716331 |
+------------------+----------------+
7 rows in set (0.01 sec)

mysql> SELECT subscription_plan, AVG(churn_status='Yes')*100 AS churn_rate FROM netflix_clean GROUP BY subscription_plan ORDER BY churn_rate DESC;
+-------------------+------------+
| subscription_plan | churn_rate |
+-------------------+------------+
| Basic             |    54.8589 |
| Premium           |    53.6585 |
| Standard          |    53.4091 |
+-------------------+------------+
3 rows in set (0.00 sec)

mysql> SELECT region, AVG(churn_status='Yes')*100 AS churn_rate FROM netflix_clean GROUP BY region ORDER BY churn_rate DESC;
+---------------+------------+
| region        | churn_rate |
+---------------+------------+
| Africa        |    55.6650 |
| Asia          |    55.6098 |
| North America |    54.2105 |
| Europe        |    54.0000 |
| South America |    50.2488 |
+---------------+------------+
5 rows in set (0.01 sec)

mysql> SELECT support_queries_logged, AVG(churn_status='Yes')*100 AS churn_rate FROM netflix_clean GROUP BY support_queries_logged ORDER BY support_queries_logged;
+------------------------+------------+
| support_queries_logged | churn_rate |
+------------------------+------------+
|                      0 |    52.1739 |
|                      1 |    49.3976 |
|                      2 |    51.6854 |
|                      3 |    52.9412 |
|                      4 |    45.2632 |
|                      5 |    60.6742 |
|                      6 |    53.9216 |
|                      7 |    58.5106 |
|                      8 |    54.5455 |
|                      9 |    61.9565 |
|                     10 |    52.3810 |
+------------------------+------------+
11 rows in set (0.01 sec)

mysql> SELECT support_queries_logged, ROUND(AVG(churn_status='Yes')*100,2) AS churn_rate FROM netflix_clean GROUP BY support_queries_logged ORDER BY support_queries_logged;
+------------------------+------------+
| support_queries_logged | churn_rate |
+------------------------+------------+
|                      0 |      52.17 |
|                      1 |      49.40 |
|                      2 |      51.69 |
|                      3 |      52.94 |
|                      4 |      45.26 |
|                      5 |      60.67 |
|                      6 |      53.92 |
|                      7 |      58.51 |
|                      8 |      54.55 |
|                      9 |      61.96 |
|                     10 |      52.38 |
+------------------------+------------+
11 rows in set (0.00 sec)

mysql> SELECT customer_id, CASE WHEN customer_satisfaction_score <= 4 AND engagement_rate <= 4 THEN 'At Risk' ELSE 'Normal' END AS customer_segment FROM netflix_clean;
+-------------+------------------+
| customer_id | customer_segment |
+-------------+------------------+
| C00001      | Normal           |
| C00002      | Normal           |
| C00003      | Normal           |
| C00005      | Normal           |
| C00006      | At Risk          |
| C00007      | At Risk          |
| C00008      | Normal           |
| C00009      | Normal           |
| C00010      | Normal           |
| C00011      | Normal           |
| C00012      | Normal           |
| C00013      | Normal           |
| C00014      | At Risk          |
| C00015      | Normal           |
| C00016      | Normal           |
| C00017      | At Risk          |
| C00018      | At Risk          |
| C00019      | Normal           |
| C00020      | Normal           |
| C00021      | At Risk          |
| C00022      | Normal           |
| C00023      | Normal           |
| C00024      | Normal           |
| C00025      | Normal           |
| C00026      | Normal           |
| C00027      | Normal           |
| C00028      | Normal           |
| C00029      | Normal           |
| C00030      | Normal           |
| C00031      | Normal           |
| C00032      | Normal           |
| C00033      | Normal           |
| C00034      | Normal           |
| C00035      | Normal           |
| C00036      | Normal           |
| C00037      | Normal           |
| C00038      | At Risk          |
| C00039      | Normal           |
| C00040      | Normal           |
| C00041      | Normal           |
| C00042      | Normal           |
| C00043      | Normal           |
| C00044      | Normal           |
| C00045      | Normal           |
| C00046      | Normal           |
| C00047      | At Risk          |
| C00048      | Normal           |
| C00049      | Normal           |
| C00050      | At Risk          |
| C00051      | Normal           |
| C00052      | Normal           |
| C00053      | Normal           |
| C00054      | Normal           |
| C00055      | Normal           |
| C00056      | Normal           |
| C00057      | Normal           |
| C00058      | Normal           |
| C00059      | At Risk          |
| C00060      | At Risk          |
| C00061      | Normal           |
| C00062      | Normal           |
| C00063      | Normal           |
| C00064      | Normal           |
| C00065      | Normal           |
| C00066      | Normal           |
| C00067      | Normal           |
| C00068      | Normal           |
| C00069      | At Risk          |
| C00070      | Normal           |
| C00071      | Normal           |
| C00072      | At Risk          |
| C00073      | Normal           |
| C00074      | Normal           |
| C00075      | Normal           |
| C00076      | Normal           |
| C00077      | Normal           |
| C00078      | Normal           |
| C00079      | Normal           |
| C00080      | Normal           |
| C00081      | Normal           |
| C00082      | Normal           |
| C00083      | Normal           |
| C00084      | Normal           |
| C00085      | Normal           |
| C00086      | Normal           |
| C00087      | At Risk          |
| C00088      | Normal           |
| C00089      | Normal           |
| C00090      | Normal           |
| C00091      | Normal           |
| C00092      | Normal           |
| C00093      | Normal           |
| C00094      | Normal           |
| C00095      | Normal           |
| C00096      | At Risk          |
| C00097      | Normal           |
| C00098      | At Risk          |
| C00099      | Normal           |
| C00100      | Normal           |
| C00101      | Normal           |
| C00102      | Normal           |
| C00103      | Normal           |
| C00104      | Normal           |
| C00105      | Normal           |
| C00106      | Normal           |
| C00107      | Normal           |
| C00108      | Normal           |
| C00109      | Normal           |
| C00110      | At Risk          |
| C00111      | Normal           |
| C00112      | Normal           |
| C00113      | At Risk          |
| C00114      | Normal           |
| C00115      | At Risk          |
| C00116      | Normal           |
| C00117      | Normal           |
| C00118      | Normal           |
| C00119      | Normal           |
| C00120      | Normal           |
| C00121      | Normal           |
| C00122      | Normal           |
| C00123      | Normal           |
| C00124      | Normal           |
| C00125      | Normal           |
| C00126      | Normal           |
| C00127      | Normal           |
| C00128      | Normal           |
| C00129      | At Risk          |
| C00130      | Normal           |
| C00131      | Normal           |
| C00132      | Normal           |
| C00133      | Normal           |
| C00134      | Normal           |
| C00135      | Normal           |
| C00136      | Normal           |
| C00137      | Normal           |
| C00138      | Normal           |
| C00139      | Normal           |
| C00140      | Normal           |
| C00141      | At Risk          |
| C00142      | Normal           |
| C00143      | Normal           |
| C00144      | Normal           |
| C00145      | Normal           |
| C00146      | Normal           |
| C00147      | Normal           |
| C00148      | At Risk          |
| C00149      | Normal           |
| C00150      | Normal           |
| C00151      | Normal           |
| C00152      | Normal           |
| C00153      | Normal           |
| C00154      | Normal           |
| C00155      | Normal           |
| C00156      | Normal           |
| C00157      | Normal           |
| C00158      | Normal           |
| C00159      | Normal           |
| C00160      | Normal           |
| C00161      | At Risk          |
| C00162      | Normal           |
| C00163      | Normal           |
| C00164      | Normal           |
| C00165      | Normal           |
| C00166      | Normal           |
| C00167      | Normal           |
| C00168      | Normal           |
| C00169      | Normal           |
| C00170      | Normal           |
| C00171      | Normal           |
| C00172      | Normal           |
| C00173      | Normal           |
| C00174      | Normal           |
| C00175      | At Risk          |
| C00176      | Normal           |
| C00177      | Normal           |
| C00178      | Normal           |
| C00179      | Normal           |
| C00180      | Normal           |
| C00181      | At Risk          |
| C00182      | Normal           |
| C00183      | Normal           |
| C00184      | Normal           |
| C00185      | At Risk          |
| C00186      | Normal           |
| C00187      | Normal           |
| C00188      | Normal           |
| C00189      | Normal           |
| C00190      | Normal           |
| C00191      | At Risk          |
| C00192      | Normal           |
| C00193      | At Risk          |
| C00194      | Normal           |
| C00195      | Normal           |
| C00196      | At Risk          |
| C00197      | Normal           |
| C00198      | At Risk          |
| C00199      | Normal           |
| C00200      | Normal           |
| C00201      | Normal           |
| C00202      | Normal           |
| C00203      | Normal           |
| C00204      | Normal           |
| C00205      | Normal           |
| C00206      | Normal           |
| C00207      | Normal           |
| C00208      | Normal           |
| C00209      | At Risk          |
| C00210      | Normal           |
| C00211      | Normal           |
| C00212      | At Risk          |
| C00213      | Normal           |
| C00214      | Normal           |
| C00215      | Normal           |
| C00216      | Normal           |
| C00217      | Normal           |
| C00218      | At Risk          |
| C00219      | Normal           |
| C00220      | Normal           |
| C00221      | Normal           |
| C00222      | Normal           |
| C00223      | Normal           |
| C00224      | Normal           |
| C00225      | Normal           |
| C00226      | Normal           |
| C00227      | Normal           |
| C00228      | Normal           |
| C00229      | Normal           |
| C00230      | Normal           |
| C00231      | Normal           |
| C00232      | Normal           |
| C00233      | Normal           |
| C00234      | Normal           |
| C00235      | Normal           |
| C00236      | Normal           |
| C00237      | At Risk          |
| C00238      | Normal           |
| C00239      | Normal           |
| C00240      | Normal           |
| C00241      | Normal           |
| C00242      | Normal           |
| C00243      | Normal           |
| C00244      | Normal           |
| C00245      | Normal           |
| C00246      | Normal           |
| C00247      | Normal           |
| C00248      | Normal           |
| C00249      | At Risk          |
| C00250      | At Risk          |
| C00251      | At Risk          |
| C00252      | Normal           |
| C00253      | Normal           |
| C00254      | Normal           |
| C00255      | Normal           |
| C00256      | Normal           |
| C00257      | Normal           |
| C00258      | Normal           |
| C00259      | At Risk          |
| C00260      | Normal           |
| C00261      | At Risk          |
| C00262      | Normal           |
| C00263      | At Risk          |
| C00264      | Normal           |
| C00265      | At Risk          |
| C00266      | At Risk          |
| C00267      | Normal           |
| C00268      | Normal           |
| C00269      | Normal           |
| C00270      | At Risk          |
| C00271      | Normal           |
| C00272      | Normal           |
| C00273      | Normal           |
| C00274      | Normal           |
| C00275      | Normal           |
| C00276      | Normal           |
| C00277      | Normal           |
| C00278      | Normal           |
| C00279      | At Risk          |
| C00280      | Normal           |
| C00281      | Normal           |
| C00282      | Normal           |
| C00283      | Normal           |
| C00284      | Normal           |
| C00285      | Normal           |
| C00286      | Normal           |
| C00287      | Normal           |
| C00288      | Normal           |
| C00289      | Normal           |
| C00290      | Normal           |
| C00291      | Normal           |
| C00292      | At Risk          |
| C00293      | At Risk          |
| C00294      | Normal           |
| C00295      | Normal           |
| C00296      | Normal           |
| C00297      | Normal           |
| C00298      | At Risk          |
| C00299      | Normal           |
| C00300      | Normal           |
| C00301      | Normal           |
| C00302      | Normal           |
| C00303      | Normal           |
| C00304      | Normal           |
| C00305      | Normal           |
| C00306      | At Risk          |
| C00307      | Normal           |
| C00308      | Normal           |
| C00309      | Normal           |
| C00310      | Normal           |
| C00311      | Normal           |
| C00312      | Normal           |
| C00313      | Normal           |
| C00314      | Normal           |
| C00315      | At Risk          |
| C00316      | Normal           |
| C00317      | Normal           |
| C00318      | Normal           |
| C00319      | At Risk          |
| C00320      | At Risk          |
| C00321      | Normal           |
| C00322      | Normal           |
| C00323      | At Risk          |
| C00324      | Normal           |
| C00325      | Normal           |
| C00326      | Normal           |
| C00327      | At Risk          |
| C00328      | At Risk          |
| C00329      | Normal           |
| C00330      | Normal           |
| C00331      | Normal           |
| C00332      | Normal           |
| C00333      | Normal           |
| C00334      | Normal           |
| C00335      | Normal           |
| C00336      | Normal           |
| C00337      | Normal           |
| C00338      | Normal           |
| C00339      | Normal           |
| C00340      | Normal           |
| C00341      | At Risk          |
| C00342      | Normal           |
| C00343      | Normal           |
| C00344      | At Risk          |
| C00345      | Normal           |
| C00346      | Normal           |
| C00347      | Normal           |
| C00348      | Normal           |
| C00349      | At Risk          |
| C00350      | At Risk          |
| C00351      | Normal           |
| C00352      | Normal           |
| C00353      | Normal           |
| C00354      | Normal           |
| C00355      | At Risk          |
| C00356      | Normal           |
| C00357      | Normal           |
| C00358      | Normal           |
| C00359      | Normal           |
| C00360      | Normal           |
| C00361      | Normal           |
| C00362      | Normal           |
| C00363      | Normal           |
| C00364      | At Risk          |
| C00365      | Normal           |
| C00366      | Normal           |
| C00367      | Normal           |
| C00368      | Normal           |
| C00369      | At Risk          |
| C00370      | Normal           |
| C00371      | Normal           |
| C00372      | Normal           |
| C00373      | Normal           |
| C00374      | At Risk          |
| C00375      | Normal           |
| C00376      | Normal           |
| C00377      | Normal           |
| C00378      | Normal           |
| C00379      | Normal           |
| C00380      | Normal           |
| C00381      | Normal           |
| C00382      | Normal           |
| C00383      | At Risk          |
| C00384      | Normal           |
| C00385      | Normal           |
| C00386      | Normal           |
| C00387      | Normal           |
| C00388      | At Risk          |
| C00389      | At Risk          |
| C00390      | Normal           |
| C00391      | Normal           |
| C00392      | Normal           |
| C00393      | At Risk          |
| C00394      | Normal           |
| C00395      | Normal           |
| C00396      | At Risk          |
| C00397      | Normal           |
| C00398      | At Risk          |
| C00399      | Normal           |
| C00400      | At Risk          |
| C00401      | Normal           |
| C00402      | Normal           |
| C00403      | Normal           |
| C00404      | Normal           |
| C00405      | Normal           |
| C00406      | Normal           |
| C00407      | At Risk          |
| C00408      | At Risk          |
| C00409      | Normal           |
| C00410      | At Risk          |
| C00411      | Normal           |
| C00412      | Normal           |
| C00413      | Normal           |
| C00414      | Normal           |
| C00415      | Normal           |
| C00416      | Normal           |
| C00417      | At Risk          |
| C00418      | Normal           |
| C00419      | Normal           |
| C00420      | At Risk          |
| C00421      | Normal           |
| C00422      | Normal           |
| C00423      | At Risk          |
| C00424      | Normal           |
| C00425      | Normal           |
| C00426      | Normal           |
| C00427      | Normal           |
| C00428      | Normal           |
| C00429      | Normal           |
| C00430      | At Risk          |
| C00431      | Normal           |
| C00432      | Normal           |
| C00433      | Normal           |
| C00434      | Normal           |
| C00435      | Normal           |
| C00436      | Normal           |
| C00437      | Normal           |
| C00438      | Normal           |
| C00439      | Normal           |
| C00440      | At Risk          |
| C00441      | Normal           |
| C00442      | Normal           |
| C00443      | At Risk          |
| C00444      | Normal           |
| C00445      | Normal           |
| C00446      | Normal           |
| C00447      | Normal           |
| C00448      | Normal           |
| C00449      | At Risk          |
| C00450      | Normal           |
| C00451      | Normal           |
| C00452      | Normal           |
| C00453      | Normal           |
| C00454      | Normal           |
| C00455      | Normal           |
| C00456      | Normal           |
| C00457      | Normal           |
| C00458      | Normal           |
| C00459      | Normal           |
| C00460      | Normal           |
| C00461      | Normal           |
| C00462      | Normal           |
| C00463      | Normal           |
| C00464      | Normal           |
| C00465      | Normal           |
| C00466      | Normal           |
| C00467      | At Risk          |
| C00468      | Normal           |
| C00469      | Normal           |
| C00470      | Normal           |
| C00471      | Normal           |
| C00472      | Normal           |
| C00473      | Normal           |
| C00474      | Normal           |
| C00475      | Normal           |
| C00476      | Normal           |
| C00477      | Normal           |
| C00478      | Normal           |
| C00479      | Normal           |
| C00480      | Normal           |
| C00481      | Normal           |
| C00482      | At Risk          |
| C00483      | Normal           |
| C00484      | Normal           |
| C00485      | Normal           |
| C00486      | Normal           |
| C00487      | At Risk          |
| C00488      | Normal           |
| C00489      | Normal           |
| C00490      | Normal           |
| C00491      | Normal           |
| C00492      | Normal           |
| C00493      | Normal           |
| C00494      | Normal           |
| C00495      | Normal           |
| C00496      | At Risk          |
| C00497      | Normal           |
| C00498      | Normal           |
| C00499      | Normal           |
| C00500      | Normal           |
| C00501      | Normal           |
| C00502      | Normal           |
| C00503      | Normal           |
| C00504      | Normal           |
| C00505      | Normal           |
| C00506      | Normal           |
| C00507      | Normal           |
| C00508      | Normal           |
| C00509      | Normal           |
| C00510      | Normal           |
| C00511      | Normal           |
| C00512      | Normal           |
| C00513      | Normal           |
| C00514      | Normal           |
| C00515      | Normal           |
| C00516      | Normal           |
| C00517      | Normal           |
| C00518      | Normal           |
| C00519      | Normal           |
| C00520      | Normal           |
| C00521      | Normal           |
| C00522      | Normal           |
| C00523      | Normal           |
| C00524      | Normal           |
| C00525      | Normal           |
| C00526      | Normal           |
| C00527      | Normal           |
| C00528      | Normal           |
| C00529      | Normal           |
| C00530      | Normal           |
| C00531      | Normal           |
| C00532      | Normal           |
| C00533      | Normal           |
| C00534      | Normal           |
| C00535      | Normal           |
| C00536      | At Risk          |
| C00537      | Normal           |
| C00538      | At Risk          |
| C00539      | Normal           |
| C00540      | Normal           |
| C00541      | Normal           |
| C00542      | Normal           |
| C00543      | At Risk          |
| C00544      | Normal           |
| C00545      | Normal           |
| C00546      | Normal           |
| C00547      | Normal           |
| C00548      | At Risk          |
| C00549      | At Risk          |
| C00550      | Normal           |
| C00551      | Normal           |
| C00552      | Normal           |
| C00553      | Normal           |
| C00554      | Normal           |
| C00555      | At Risk          |
| C00556      | Normal           |
| C00557      | Normal           |
| C00558      | Normal           |
| C00559      | Normal           |
| C00560      | Normal           |
| C00561      | Normal           |
| C00562      | Normal           |
| C00563      | Normal           |
| C00564      | Normal           |
| C00565      | At Risk          |
| C00566      | Normal           |
| C00567      | Normal           |
| C00568      | Normal           |
| C00569      | Normal           |
| C00570      | Normal           |
| C00571      | Normal           |
| C00572      | Normal           |
| C00573      | Normal           |
| C00574      | Normal           |
| C00575      | Normal           |
| C00576      | Normal           |
| C00577      | Normal           |
| C00578      | Normal           |
| C00579      | Normal           |
| C00580      | Normal           |
| C00581      | Normal           |
| C00582      | At Risk          |
| C00583      | Normal           |
| C00584      | At Risk          |
| C00585      | Normal           |
| C00586      | Normal           |
| C00587      | At Risk          |
| C00588      | Normal           |
| C00589      | Normal           |
| C00590      | Normal           |
| C00591      | At Risk          |
| C00592      | Normal           |
| C00593      | At Risk          |
| C00594      | Normal           |
| C00595      | Normal           |
| C00596      | Normal           |
| C00597      | Normal           |
| C00598      | At Risk          |
| C00599      | Normal           |
| C00600      | Normal           |
| C00601      | At Risk          |
| C00602      | Normal           |
| C00603      | At Risk          |
| C00604      | Normal           |
| C00605      | Normal           |
| C00606      | Normal           |
| C00607      | Normal           |
| C00608      | At Risk          |
| C00609      | Normal           |
| C00610      | Normal           |
| C00611      | Normal           |
| C00612      | Normal           |
| C00613      | Normal           |
| C00614      | At Risk          |
| C00615      | Normal           |
| C00616      | Normal           |
| C00617      | Normal           |
| C00618      | Normal           |
| C00619      | Normal           |
| C00620      | Normal           |
| C00621      | Normal           |
| C00622      | Normal           |
| C00623      | Normal           |
| C00624      | Normal           |
| C00625      | Normal           |
| C00626      | Normal           |
| C00627      | Normal           |
| C00628      | Normal           |
| C00629      | Normal           |
| C00630      | Normal           |
| C00631      | At Risk          |
| C00632      | Normal           |
| C00633      | Normal           |
| C00634      | Normal           |
| C00635      | Normal           |
| C00636      | At Risk          |
| C00637      | Normal           |
| C00638      | Normal           |
| C00639      | Normal           |
| C00640      | At Risk          |
| C00641      | Normal           |
| C00642      | Normal           |
| C00643      | Normal           |
| C00644      | Normal           |
| C00645      | Normal           |
| C00646      | Normal           |
| C00647      | Normal           |
| C00648      | Normal           |
| C00649      | Normal           |
| C00650      | Normal           |
| C00651      | Normal           |
| C00652      | Normal           |
| C00653      | Normal           |
| C00654      | At Risk          |
| C00655      | At Risk          |
| C00656      | Normal           |
| C00657      | Normal           |
| C00658      | Normal           |
| C00659      | Normal           |
| C00660      | Normal           |
| C00661      | Normal           |
| C00662      | Normal           |
| C00663      | Normal           |
| C00664      | At Risk          |
| C00665      | Normal           |
| C00666      | Normal           |
| C00667      | Normal           |
| C00668      | Normal           |
| C00669      | Normal           |
| C00670      | At Risk          |
| C00671      | At Risk          |
| C00672      | Normal           |
| C00673      | Normal           |
| C00674      | Normal           |
| C00675      | Normal           |
| C00676      | Normal           |
| C00677      | Normal           |
| C00678      | Normal           |
| C00679      | At Risk          |
| C00680      | At Risk          |
| C00681      | Normal           |
| C00682      | At Risk          |
| C00683      | Normal           |
| C00684      | At Risk          |
| C00685      | Normal           |
| C00686      | Normal           |
| C00687      | Normal           |
| C00688      | Normal           |
| C00689      | Normal           |
| C00690      | Normal           |
| C00691      | Normal           |
| C00692      | Normal           |
| C00693      | Normal           |
| C00694      | Normal           |
| C00695      | Normal           |
| C00696      | Normal           |
| C00697      | Normal           |
| C00698      | Normal           |
| C00699      | Normal           |
| C00700      | At Risk          |
| C00701      | Normal           |
| C00702      | Normal           |
| C00703      | Normal           |
| C00704      | Normal           |
| C00705      | Normal           |
| C00706      | Normal           |
| C00707      | At Risk          |
| C00708      | At Risk          |
| C00709      | Normal           |
| C00710      | Normal           |
| C00711      | Normal           |
| C00712      | Normal           |
| C00713      | Normal           |
| C00714      | Normal           |
| C00715      | Normal           |
| C00716      | Normal           |
| C00717      | Normal           |
| C00718      | Normal           |
| C00719      | Normal           |
| C00720      | Normal           |
| C00721      | Normal           |
| C00722      | Normal           |
| C00723      | Normal           |
| C00724      | Normal           |
| C00725      | Normal           |
| C00726      | Normal           |
| C00727      | Normal           |
| C00728      | Normal           |
| C00729      | Normal           |
| C00730      | Normal           |
| C00731      | Normal           |
| C00732      | Normal           |
| C00733      | Normal           |
| C00734      | Normal           |
| C00735      | Normal           |
| C00736      | Normal           |
| C00737      | Normal           |
| C00738      | Normal           |
| C00739      | At Risk          |
| C00740      | Normal           |
| C00741      | Normal           |
| C00742      | Normal           |
| C00743      | At Risk          |
| C00744      | Normal           |
| C00745      | Normal           |
| C00746      | Normal           |
| C00747      | Normal           |
| C00748      | Normal           |
| C00749      | Normal           |
| C00750      | At Risk          |
| C00751      | Normal           |
| C00752      | Normal           |
| C00753      | Normal           |
| C00754      | Normal           |
| C00755      | Normal           |
| C00756      | Normal           |
| C00757      | Normal           |
| C00758      | Normal           |
| C00759      | At Risk          |
| C00760      | Normal           |
| C00761      | Normal           |
| C00762      | At Risk          |
| C00763      | Normal           |
| C00764      | Normal           |
| C00765      | Normal           |
| C00766      | Normal           |
| C00767      | At Risk          |
| C00768      | At Risk          |
| C00769      | Normal           |
| C00770      | Normal           |
| C00771      | Normal           |
| C00772      | Normal           |
| C00773      | Normal           |
| C00774      | Normal           |
| C00775      | Normal           |
| C00776      | Normal           |
| C00777      | Normal           |
| C00778      | Normal           |
| C00779      | Normal           |
| C00780      | At Risk          |
| C00781      | Normal           |
| C00782      | Normal           |
| C00783      | Normal           |
| C00784      | Normal           |
| C00785      | At Risk          |
| C00786      | Normal           |
| C00787      | Normal           |
| C00788      | Normal           |
| C00789      | Normal           |
| C00790      | Normal           |
| C00791      | At Risk          |
| C00792      | Normal           |
| C00793      | At Risk          |
| C00794      | Normal           |
| C00795      | Normal           |
| C00796      | Normal           |
| C00797      | Normal           |
| C00798      | Normal           |
| C00799      | Normal           |
| C00800      | Normal           |
| C00801      | Normal           |
| C00802      | Normal           |
| C00803      | Normal           |
| C00804      | Normal           |
| C00805      | At Risk          |
| C00806      | Normal           |
| C00807      | Normal           |
| C00808      | At Risk          |
| C00809      | Normal           |
| C00810      | At Risk          |
| C00811      | Normal           |
| C00812      | Normal           |
| C00813      | Normal           |
| C00814      | Normal           |
| C00815      | Normal           |
| C00816      | Normal           |
| C00817      | Normal           |
| C00818      | Normal           |
| C00819      | Normal           |
| C00820      | Normal           |
| C00821      | Normal           |
| C00822      | Normal           |
| C00823      | Normal           |
| C00824      | At Risk          |
| C00825      | Normal           |
| C00826      | Normal           |
| C00827      | Normal           |
| C00828      | Normal           |
| C00829      | At Risk          |
| C00830      | Normal           |
| C00831      | Normal           |
| C00832      | Normal           |
| C00833      | Normal           |
| C00834      | Normal           |
| C00835      | Normal           |
| C00836      | At Risk          |
| C00837      | Normal           |
| C00838      | Normal           |
| C00839      | Normal           |
| C00840      | Normal           |
| C00841      | Normal           |
| C00842      | Normal           |
| C00843      | Normal           |
| C00844      | Normal           |
| C00845      | Normal           |
| C00846      | Normal           |
| C00847      | At Risk          |
| C00848      | Normal           |
| C00849      | At Risk          |
| C00850      | Normal           |
| C00851      | At Risk          |
| C00852      | Normal           |
| C00853      | Normal           |
| C00854      | Normal           |
| C00855      | At Risk          |
| C00856      | Normal           |
| C00857      | Normal           |
| C00858      | At Risk          |
| C00859      | At Risk          |
| C00860      | Normal           |
| C00861      | Normal           |
| C00862      | Normal           |
| C00863      | Normal           |
| C00864      | Normal           |
| C00865      | Normal           |
| C00866      | Normal           |
| C00867      | Normal           |
| C00868      | Normal           |
| C00869      | Normal           |
| C00870      | Normal           |
| C00871      | Normal           |
| C00872      | At Risk          |
| C00873      | Normal           |
| C00874      | Normal           |
| C00875      | Normal           |
| C00876      | At Risk          |
| C00877      | Normal           |
| C00878      | Normal           |
| C00879      | Normal           |
| C00880      | Normal           |
| C00881      | Normal           |
| C00882      | Normal           |
| C00883      | Normal           |
| C00884      | Normal           |
| C00885      | Normal           |
| C00886      | Normal           |
| C00887      | Normal           |
| C00888      | Normal           |
| C00889      | Normal           |
| C00890      | Normal           |
| C00891      | Normal           |
| C00892      | Normal           |
| C00893      | Normal           |
| C00894      | Normal           |
| C00895      | Normal           |
| C00896      | Normal           |
| C00897      | Normal           |
| C00898      | Normal           |
| C00899      | Normal           |
| C00900      | At Risk          |
| C00901      | Normal           |
| C00902      | Normal           |
| C00903      | Normal           |
| C00904      | Normal           |
| C00905      | Normal           |
| C00906      | Normal           |
| C00907      | Normal           |
| C00908      | Normal           |
| C00909      | Normal           |
| C00910      | Normal           |
| C00911      | Normal           |
| C00912      | Normal           |
| C00913      | At Risk          |
| C00914      | Normal           |
| C00915      | Normal           |
| C00916      | At Risk          |
| C00917      | Normal           |
| C00918      | Normal           |
| C00919      | Normal           |
| C00920      | At Risk          |
| C00921      | At Risk          |
| C00922      | Normal           |
| C00923      | Normal           |
| C00924      | Normal           |
| C00925      | At Risk          |
| C00926      | Normal           |
| C00927      | Normal           |
| C00928      | Normal           |
| C00929      | Normal           |
| C00930      | Normal           |
| C00931      | Normal           |
| C00932      | Normal           |
| C00933      | At Risk          |
| C00934      | Normal           |
| C00935      | Normal           |
| C00936      | Normal           |
| C00937      | Normal           |
| C00938      | At Risk          |
| C00939      | Normal           |
| C00940      | Normal           |
| C00941      | Normal           |
| C00942      | Normal           |
| C00943      | Normal           |
| C00944      | Normal           |
| C00945      | At Risk          |
| C00946      | Normal           |
| C00947      | Normal           |
| C00948      | Normal           |
| C00949      | Normal           |
| C00950      | Normal           |
| C00951      | Normal           |
| C00952      | Normal           |
| C00953      | Normal           |
| C00954      | Normal           |
| C00955      | Normal           |
| C00956      | Normal           |
| C00957      | Normal           |
| C00958      | Normal           |
| C00959      | Normal           |
| C00960      | Normal           |
| C00961      | Normal           |
| C00962      | Normal           |
| C00963      | Normal           |
| C00964      | Normal           |
| C00965      | Normal           |
| C00966      | At Risk          |
| C00967      | Normal           |
| C00968      | Normal           |
| C00969      | Normal           |
| C00970      | At Risk          |
| C00971      | Normal           |
| C00972      | Normal           |
| C00973      | Normal           |
| C00974      | Normal           |
| C00975      | Normal           |
| C00976      | At Risk          |
| C00977      | At Risk          |
| C00978      | Normal           |
| C00979      | Normal           |
| C00980      | At Risk          |
| C00981      | Normal           |
| C00982      | Normal           |
| C00983      | Normal           |
| C00984      | Normal           |
| C00985      | Normal           |
| C00986      | Normal           |
| C00987      | Normal           |
| C00988      | Normal           |
| C00989      | Normal           |
| C00990      | Normal           |
| C00991      | Normal           |
| C00992      | Normal           |
| C00993      | At Risk          |
| C00994      | Normal           |
| C00995      | Normal           |
| C00996      | Normal           |
| C00997      | At Risk          |
| C00998      | Normal           |
| C00999      | Normal           |
| C01000      | Normal           |
+-------------+------------------+
999 rows in set (0.01 sec)

mysql> SELECT ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_clean),2) AS at_risk_percentage FROM netflix_clean WHERE customer_satisfaction_score <= 4 AND engagement_rate <= 4;
+--------------------+
| at_risk_percentage |
+--------------------+
|              15.62 |
+--------------------+
1 row in set (0.01 sec)

mysql> SELECT CASE WHEN customer_satisfaction_score <= 4 AND engagement_rate <= 4 THEN 'At Risk' ELSE 'Normal' END AS customer_segment, COUNT(*) AS total_customers FROM netflix_clean GROUP BY customer_segment;
+------------------+-----------------+
| customer_segment | total_customers |
+------------------+-----------------+
| Normal           |             843 |
| At Risk          |             156 |
+------------------+-----------------+
2 rows in set (0.01 sec)

mysql> SELECT customer_id, customer_satisfaction_score, engagement_rate FROM netflix_clean WHERE customer_satisfaction_score <= 4 AND engagement_rate <= 4 LIMIT 10;
+-------------+-----------------------------+-----------------+
| customer_id | customer_satisfaction_score | engagement_rate |
+-------------+-----------------------------+-----------------+
| C00006      |                           4 |               3 |
| C00007      |                           4 |               3 |
| C00014      |                           2 |               3 |
| C00017      |                           2 |               2 |
| C00018      |                           3 |               2 |
| C00021      |                           3 |               3 |
| C00038      |                           1 |               3 |
| C00047      |                           4 |               3 |
| C00050      |                           1 |               2 |
| C00059      |                           2 |               2 |
+-------------+-----------------------------+-----------------+
10 rows in set (0.00 sec)

mysql> SELECT customer_id, daily_watch_time_hrs, ROW_NUMBER() OVER(ORDER BY daily_watch_time_hrs DESC) AS rank_num FROM netflix_clean;
+-------------+----------------------+----------+
| customer_id | daily_watch_time_hrs | rank_num |
+-------------+----------------------+----------+
| C00040      |                 5.00 |        1 |
| C00734      |                 4.99 |        2 |
| C00834      |                 4.99 |        3 |
| C00085      |                 4.98 |        4 |
| C00034      |                 4.97 |        5 |
| C00334      |                 4.97 |        6 |
| C00788      |                 4.97 |        7 |
| C00328      |                 4.96 |        8 |
| C00006      |                 4.95 |        9 |
| C00209      |                 4.94 |       10 |
| C00039      |                 4.93 |       11 |
| C00152      |                 4.93 |       12 |
| C00401      |                 4.93 |       13 |
| C00506      |                 4.93 |       14 |
| C00975      |                 4.93 |       15 |
| C00248      |                 4.92 |       16 |
| C00638      |                 4.92 |       17 |
| C00021      |                 4.91 |       18 |
| C00823      |                 4.91 |       19 |
| C00801      |                 4.90 |       20 |
| C00673      |                 4.89 |       21 |
| C00953      |                 4.89 |       22 |
| C00365      |                 4.88 |       23 |
| C00224      |                 4.87 |       24 |
| C00895      |                 4.87 |       25 |
| C00621      |                 4.86 |       26 |
| C00982      |                 4.86 |       27 |
| C00001      |                 4.85 |       28 |
| C00265      |                 4.85 |       29 |
| C00368      |                 4.85 |       30 |
| C00504      |                 4.85 |       31 |
| C00510      |                 4.85 |       32 |
| C00907      |                 4.85 |       33 |
| C00077      |                 4.84 |       34 |
| C00986      |                 4.84 |       35 |
| C00050      |                 4.83 |       36 |
| C00063      |                 4.83 |       37 |
| C00747      |                 4.83 |       38 |
| C00959      |                 4.83 |       39 |
| C00018      |                 4.82 |       40 |
| C00268      |                 4.82 |       41 |
| C00892      |                 4.82 |       42 |
| C00228      |                 4.81 |       43 |
| C00383      |                 4.81 |       44 |
| C00970      |                 4.80 |       45 |
| C00203      |                 4.79 |       46 |
| C00515      |                 4.79 |       47 |
| C00829      |                 4.79 |       48 |
| C00289      |                 4.77 |       49 |
| C00664      |                 4.77 |       50 |
| C00620      |                 4.76 |       51 |
| C00883      |                 4.76 |       52 |
| C00992      |                 4.76 |       53 |
| C00400      |                 4.73 |       54 |
| C00536      |                 4.73 |       55 |
| C00586      |                 4.73 |       56 |
| C00619      |                 4.73 |       57 |
| C00659      |                 4.73 |       58 |
| C00825      |                 4.73 |       59 |
| C00260      |                 4.72 |       60 |
| C00450      |                 4.72 |       61 |
| C00577      |                 4.72 |       62 |
| C00606      |                 4.72 |       63 |
| C00530      |                 4.71 |       64 |
| C00594      |                 4.71 |       65 |
| C00942      |                 4.71 |       66 |
| C00042      |                 4.70 |       67 |
| C00562      |                 4.69 |       68 |
| C00576      |                 4.68 |       69 |
| C00750      |                 4.68 |       70 |
| C00153      |                 4.67 |       71 |
| C00661      |                 4.67 |       72 |
| C00961      |                 4.67 |       73 |
| C00991      |                 4.67 |       74 |
| C00340      |                 4.66 |       75 |
| C00374      |                 4.66 |       76 |
| C00516      |                 4.66 |       77 |
| C00213      |                 4.65 |       78 |
| C00155      |                 4.64 |       79 |
| C00426      |                 4.64 |       80 |
| C00217      |                 4.63 |       81 |
| C00326      |                 4.63 |       82 |
| C00429      |                 4.63 |       83 |
| C00448      |                 4.63 |       84 |
| C00813      |                 4.62 |       85 |
| C00192      |                 4.61 |       86 |
| C00245      |                 4.61 |       87 |
| C00311      |                 4.61 |       88 |
| C00402      |                 4.61 |       89 |
| C00922      |                 4.61 |       90 |
| C00492      |                 4.60 |       91 |
| C00548      |                 4.60 |       92 |
| C00074      |                 4.59 |       93 |
| C00162      |                 4.59 |       94 |
| C00186      |                 4.59 |       95 |
| C00239      |                 4.59 |       96 |
| C00434      |                 4.59 |       97 |
| C00521      |                 4.59 |       98 |
| C00600      |                 4.59 |       99 |
| C00622      |                 4.59 |      100 |
| C00647      |                 4.59 |      101 |
| C00256      |                 4.58 |      102 |
| C00092      |                 4.57 |      103 |
| C00150      |                 4.57 |      104 |
| C00274      |                 4.57 |      105 |
| C00780      |                 4.57 |      106 |
| C00789      |                 4.57 |      107 |
| C00404      |                 4.56 |      108 |
| C00721      |                 4.56 |      109 |
| C00890      |                 4.56 |      110 |
| C00947      |                 4.56 |      111 |
| C00367      |                 4.55 |      112 |
| C00957      |                 4.55 |      113 |
| C00270      |                 4.54 |      114 |
| C00393      |                 4.54 |      115 |
| C00469      |                 4.54 |      116 |
| C00663      |                 4.54 |      117 |
| C00984      |                 4.53 |      118 |
| C00347      |                 4.52 |      119 |
| C00446      |                 4.52 |      120 |
| C00798      |                 4.52 |      121 |
| C00451      |                 4.51 |      122 |
| C00612      |                 4.51 |      123 |
| C00415      |                 4.50 |      124 |
| C00440      |                 4.50 |      125 |
| C00617      |                 4.50 |      126 |
| C00821      |                 4.50 |      127 |
| C00842      |                 4.48 |      128 |
| C00899      |                 4.48 |      129 |
| C00196      |                 4.47 |      130 |
| C00472      |                 4.47 |      131 |
| C00682      |                 4.47 |      132 |
| C00866      |                 4.47 |      133 |
| C00264      |                 4.46 |      134 |
| C00363      |                 4.46 |      135 |
| C00676      |                 4.46 |      136 |
| C00296      |                 4.45 |      137 |
| C00303      |                 4.45 |      138 |
| C00348      |                 4.45 |      139 |
| C00738      |                 4.45 |      140 |
| C00380      |                 4.44 |      141 |
| C00457      |                 4.44 |      142 |
| C00494      |                 4.44 |      143 |
| C00966      |                 4.44 |      144 |
| C00233      |                 4.43 |      145 |
| C00910      |                 4.43 |      146 |
| C00918      |                 4.43 |      147 |
| C00080      |                 4.42 |      148 |
| C00830      |                 4.42 |      149 |
| C00852      |                 4.42 |      150 |
| C00135      |                 4.41 |      151 |
| C00681      |                 4.41 |      152 |
| C00704      |                 4.41 |      153 |
| C00841      |                 4.41 |      154 |
| C00027      |                 4.40 |      155 |
| C00179      |                 4.40 |      156 |
| C00482      |                 4.40 |      157 |
| C00257      |                 4.39 |      158 |
| C00597      |                 4.39 |      159 |
| C00332      |                 4.38 |      160 |
| C00411      |                 4.38 |      161 |
| C00605      |                 4.38 |      162 |
| C00949      |                 4.38 |      163 |
| C00108      |                 4.37 |      164 |
| C00677      |                 4.36 |      165 |
| C00674      |                 4.35 |      166 |
| C00566      |                 4.34 |      167 |
| C00724      |                 4.34 |      168 |
| C00887      |                 4.34 |      169 |
| C00924      |                 4.34 |      170 |
| C00182      |                 4.33 |      171 |
| C00068      |                 4.32 |      172 |
| C00529      |                 4.32 |      173 |
| C00712      |                 4.32 |      174 |
| C00105      |                 4.30 |      175 |
| C00437      |                 4.30 |      176 |
| C00751      |                 4.30 |      177 |
| C00370      |                 4.29 |      178 |
| C00216      |                 4.28 |      179 |
| C00733      |                 4.28 |      180 |
| C00735      |                 4.28 |      181 |
| C00020      |                 4.27 |      182 |
| C00453      |                 4.27 |      183 |
| C00172      |                 4.26 |      184 |
| C00951      |                 4.26 |      185 |
| C00366      |                 4.24 |      186 |
| C00680      |                 4.24 |      187 |
| C00728      |                 4.23 |      188 |
| C00802      |                 4.23 |      189 |
| C00157      |                 4.22 |      190 |
| C00205      |                 4.22 |      191 |
| C00391      |                 4.22 |      192 |
| C00876      |                 4.20 |      193 |
| C00357      |                 4.19 |      194 |
| C00231      |                 4.18 |      195 |
| C00280      |                 4.18 |      196 |
| C00679      |                 4.18 |      197 |
| C00278      |                 4.17 |      198 |
| C00292      |                 4.17 |      199 |
| C00858      |                 4.17 |      200 |
| C00215      |                 4.15 |      201 |
| C00778      |                 4.14 |      202 |
| C00805      |                 4.14 |      203 |
| C00161      |                 4.13 |      204 |
| C00221      |                 4.13 |      205 |
| C00989      |                 4.13 |      206 |
| C00447      |                 4.12 |      207 |
| C00574      |                 4.12 |      208 |
| C00579      |                 4.12 |      209 |
| C00648      |                 4.12 |      210 |
| C00926      |                 4.12 |      211 |
| C00246      |                 4.11 |      212 |
| C00356      |                 4.11 |      213 |
| C00369      |                 4.11 |      214 |
| C00238      |                 4.10 |      215 |
| C00714      |                 4.10 |      216 |
| C00407      |                 4.09 |      217 |
| C00412      |                 4.09 |      218 |
| C00666      |                 4.09 |      219 |
| C00598      |                 4.08 |      220 |
| C00836      |                 4.08 |      221 |
| C00888      |                 4.08 |      222 |
| C00987      |                 4.08 |      223 |
| C00730      |                 4.07 |      224 |
| C00115      |                 4.06 |      225 |
| C00174      |                 4.06 |      226 |
| C00170      |                 4.04 |      227 |
| C00232      |                 4.04 |      228 |
| C00076      |                 4.03 |      229 |
| C00197      |                 4.03 |      230 |
| C00540      |                 4.03 |      231 |
| C00532      |                 4.02 |      232 |
| C00165      |                 4.01 |      233 |
| C00210      |                 4.01 |      234 |
| C00207      |                 4.00 |      235 |
| C00585      |                 4.00 |      236 |
| C00156      |                 3.99 |      237 |
| C00958      |                 3.99 |      238 |
| C00571      |                 3.98 |      239 |
| C00927      |                 3.98 |      240 |
| C00610      |                 3.97 |      241 |
| C00657      |                 3.97 |      242 |
| C00517      |                 3.96 |      243 |
| C00059      |                 3.95 |      244 |
| C00149      |                 3.95 |      245 |
| C00568      |                 3.95 |      246 |
| C00613      |                 3.95 |      247 |
| C00416      |                 3.94 |      248 |
| C00729      |                 3.94 |      249 |
| C00877      |                 3.94 |      250 |
| C00286      |                 3.93 |      251 |
| C00471      |                 3.93 |      252 |
| C00118      |                 3.92 |      253 |
| C00587      |                 3.92 |      254 |
| C00592      |                 3.92 |      255 |
| C00707      |                 3.92 |      256 |
| C00483      |                 3.91 |      257 |
| C00558      |                 3.91 |      258 |
| C00276      |                 3.90 |      259 |
| C00455      |                 3.90 |      260 |
| C00287      |                 3.89 |      261 |
| C00317      |                 3.89 |      262 |
| C00439      |                 3.89 |      263 |
| C00166      |                 3.88 |      264 |
| C00202      |                 3.88 |      265 |
| C00886      |                 3.88 |      266 |
| C00498      |                 3.87 |      267 |
| C00588      |                 3.87 |      268 |
| C00690      |                 3.87 |      269 |
| C00819      |                 3.87 |      270 |
| C00854      |                 3.87 |      271 |
| C00121      |                 3.86 |      272 |
| C00295      |                 3.86 |      273 |
| C00424      |                 3.86 |      274 |
| C00442      |                 3.86 |      275 |
| C00626      |                 3.86 |      276 |
| C00634      |                 3.86 |      277 |
| C00051      |                 3.85 |      278 |
| C00467      |                 3.85 |      279 |
| C00758      |                 3.84 |      280 |
| C00283      |                 3.83 |      281 |
| C00183      |                 3.82 |      282 |
| C00378      |                 3.82 |      283 |
| C00486      |                 3.81 |      284 |
| C00723      |                 3.81 |      285 |
| C00940      |                 3.81 |      286 |
| C00127      |                 3.80 |      287 |
| C00275      |                 3.80 |      288 |
| C00371      |                 3.80 |      289 |
| C00478      |                 3.80 |      290 |
| C00582      |                 3.80 |      291 |
| C00672      |                 3.80 |      292 |
| C00009      |                 3.79 |      293 |
| C00329      |                 3.79 |      294 |
| C00465      |                 3.79 |      295 |
| C00850      |                 3.79 |      296 |
| C00525      |                 3.78 |      297 |
| C00032      |                 3.77 |      298 |
| C00112      |                 3.77 |      299 |
| C00181      |                 3.77 |      300 |
| C00463      |                 3.77 |      301 |
| C00507      |                 3.77 |      302 |
| C00335      |                 3.76 |      303 |
| C00095      |                 3.75 |      304 |
| C00208      |                 3.75 |      305 |
| C00484      |                 3.75 |      306 |
| C00520      |                 3.75 |      307 |
| C00358      |                 3.74 |      308 |
| C00665      |                 3.74 |      309 |
| C00132      |                 3.73 |      310 |
| C00099      |                 3.72 |      311 |
| C00509      |                 3.71 |      312 |
| C00912      |                 3.71 |      313 |
| C00971      |                 3.71 |      314 |
| C00696      |                 3.70 |      315 |
| C00315      |                 3.69 |      316 |
| C00514      |                 3.69 |      317 |
| C00731      |                 3.69 |      318 |
| C00300      |                 3.68 |      319 |
| C00732      |                 3.68 |      320 |
| C00767      |                 3.68 |      321 |
| C00097      |                 3.67 |      322 |
| C00546      |                 3.67 |      323 |
| C00797      |                 3.67 |      324 |
| C00818      |                 3.67 |      325 |
| C00134      |                 3.66 |      326 |
| C00489      |                 3.66 |      327 |
| C00141      |                 3.65 |      328 |
| C00307      |                 3.65 |      329 |
| C00995      |                 3.64 |      330 |
| C00743      |                 3.62 |      331 |
| C00010      |                 3.61 |      332 |
| C00113      |                 3.61 |      333 |
| C00325      |                 3.60 |      334 |
| C00432      |                 3.60 |      335 |
| C00572      |                 3.60 |      336 |
| C00129      |                 3.59 |      337 |
| C00855      |                 3.58 |      338 |
| C00327      |                 3.57 |      339 |
| C00355      |                 3.57 |      340 |
| C00655      |                 3.57 |      341 |
| C00022      |                 3.56 |      342 |
| C00103      |                 3.56 |      343 |
| C00413      |                 3.56 |      344 |
| C00477      |                 3.56 |      345 |
| C00662      |                 3.56 |      346 |
| C00382      |                 3.55 |      347 |
| C00988      |                 3.55 |      348 |
| C00008      |                 3.54 |      349 |
| C00175      |                 3.54 |      350 |
| C00871      |                 3.54 |      351 |
| C00969      |                 3.54 |      352 |
| C00293      |                 3.53 |      353 |
| C00441      |                 3.53 |      354 |
| C00262      |                 3.52 |      355 |
| C00708      |                 3.52 |      356 |
| C00763      |                 3.52 |      357 |
| C00816      |                 3.52 |      358 |
| C00863      |                 3.52 |      359 |
| C00299      |                 3.51 |      360 |
| C00874      |                 3.51 |      361 |
| C00047      |                 3.50 |      362 |
| C00781      |                 3.50 |      363 |
| C00227      |                 3.49 |      364 |
| C00373      |                 3.49 |      365 |
| C00033      |                 3.48 |      366 |
| C00123      |                 3.48 |      367 |
| C00865      |                 3.48 |      368 |
| C00639      |                 3.47 |      369 |
| C00981      |                 3.47 |      370 |
| C00225      |                 3.46 |      371 |
| C00398      |                 3.46 |      372 |
| C00875      |                 3.46 |      373 |
| C00983      |                 3.46 |      374 |
| C00964      |                 3.45 |      375 |
| C00269      |                 3.44 |      376 |
| C00878      |                 3.43 |      377 |
| C00954      |                 3.43 |      378 |
| C00873      |                 3.42 |      379 |
| C00943      |                 3.42 |      380 |
| C00684      |                 3.41 |      381 |
| C00826      |                 3.41 |      382 |
| C00860      |                 3.41 |      383 |
| C00891      |                 3.41 |      384 |
| C00249      |                 3.40 |      385 |
| C00470      |                 3.40 |      386 |
| C00689      |                 3.40 |      387 |
| C00279      |                 3.39 |      388 |
| C00580      |                 3.39 |      389 |
| C00406      |                 3.38 |      390 |
| C00501      |                 3.38 |      391 |
| C00864      |                 3.38 |      392 |
| C00024      |                 3.36 |      393 |
| C00061      |                 3.36 |      394 |
| C00146      |                 3.36 |      395 |
| C00596      |                 3.36 |      396 |
| C00786      |                 3.36 |      397 |
| C00683      |                 3.35 |      398 |
| C00336      |                 3.34 |      399 |
| C00438      |                 3.34 |      400 |
| C00769      |                 3.34 |      401 |
| C00122      |                 3.33 |      402 |
| C00417      |                 3.32 |      403 |
| C00559      |                 3.32 |      404 |
| C00746      |                 3.32 |      405 |
| C00911      |                 3.32 |      406 |
| C00206      |                 3.31 |      407 |
| C00320      |                 3.31 |      408 |
| C00705      |                 3.31 |      409 |
| C00201      |                 3.30 |      410 |
| C00418      |                 3.30 |      411 |
| C00808      |                 3.29 |      412 |
| C00897      |                 3.28 |      413 |
| C00908      |                 3.28 |      414 |
| C00114      |                 3.27 |      415 |
| C00145      |                 3.27 |      416 |
| C00882      |                 3.27 |      417 |
| C00343      |                 3.26 |      418 |
| C00643      |                 3.26 |      419 |
| C00856      |                 3.26 |      420 |
| C00094      |                 3.25 |      421 |
| C00194      |                 3.25 |      422 |
| C00219      |                 3.25 |      423 |
| C00277      |                 3.25 |      424 |
| C00344      |                 3.25 |      425 |
| C00736      |                 3.25 |      426 |
| C00768      |                 3.25 |      427 |
| C00271      |                 3.24 |      428 |
| C00671      |                 3.24 |      429 |
| C00229      |                 3.23 |      430 |
| C00898      |                 3.23 |      431 |
| C00950      |                 3.23 |      432 |
| C00978      |                 3.23 |      433 |
| C00388      |                 3.22 |      434 |
| C00569      |                 3.22 |      435 |
| C00624      |                 3.22 |      436 |
| C00555      |                 3.21 |      437 |
| C00764      |                 3.21 |      438 |
| C00765      |                 3.21 |      439 |
| C00067      |                 3.18 |      440 |
| C00500      |                 3.18 |      441 |
| C00057      |                 3.17 |      442 |
| C00212      |                 3.17 |      443 |
| C00965      |                 3.17 |      444 |
| C00573      |                 3.15 |      445 |
| C00054      |                 3.14 |      446 |
| C00064      |                 3.14 |      447 |
| C00204      |                 3.14 |      448 |
| C00635      |                 3.14 |      449 |
| C00703      |                 3.14 |      450 |
| C00107      |                 3.13 |      451 |
| C00173      |                 3.13 |      452 |
| C00563      |                 3.13 |      453 |
| C00072      |                 3.12 |      454 |
| C00100      |                 3.12 |      455 |
| C00342      |                 3.12 |      456 |
| C00025      |                 3.11 |      457 |
| C00168      |                 3.11 |      458 |
| C00316      |                 3.11 |      459 |
| C00330      |                 3.11 |      460 |
| C00473      |                 3.11 |      461 |
| C00611      |                 3.11 |      462 |
| C00379      |                 3.10 |      463 |
| C00651      |                 3.09 |      464 |
| C00831      |                 3.09 |      465 |
| C00480      |                 3.08 |      466 |
| C00560      |                 3.08 |      467 |
| C00641      |                 3.07 |      468 |
| C00774      |                 3.07 |      469 |
| C00098      |                 3.04 |      470 |
| C00126      |                 3.04 |      471 |
| C00796      |                 3.04 |      472 |
| C00036      |                 3.03 |      473 |
| C00405      |                 3.03 |      474 |
| C00045      |                 3.01 |      475 |
| C00078      |                 3.01 |      476 |
| C00652      |                 3.01 |      477 |
| C00193      |                 3.00 |      478 |
| C00670      |                 2.99 |      479 |
| C00496      |                 2.98 |      480 |
| C00846      |                 2.97 |      481 |
| C00253      |                 2.96 |      482 |
| C00757      |                 2.96 |      483 |
| C00052      |                 2.95 |      484 |
| C00191      |                 2.95 |      485 |
| C00301      |                 2.95 |      486 |
| C00590      |                 2.95 |      487 |
| C00934      |                 2.95 |      488 |
| C00386      |                 2.94 |      489 |
| C00485      |                 2.94 |      490 |
| C00658      |                 2.94 |      491 |
| C00460      |                 2.93 |      492 |
| C00333      |                 2.92 |      493 |
| C00695      |                 2.92 |      494 |
| C00140      |                 2.91 |      495 |
| C00090      |                 2.90 |      496 |
| C00706      |                 2.90 |      497 |
| C00169      |                 2.89 |      498 |
| C00593      |                 2.89 |      499 |
| C00702      |                 2.89 |      500 |
| C00011      |                 2.88 |      501 |
| C00384      |                 2.88 |      502 |
| C00720      |                 2.88 |      503 |
| C00717      |                 2.87 |      504 |
| C00444      |                 2.86 |      505 |
| C00589      |                 2.86 |      506 |
| C00744      |                 2.86 |      507 |
| C00847      |                 2.86 |      508 |
| C00242      |                 2.84 |      509 |
| C00313      |                 2.84 |      510 |
| C00932      |                 2.84 |      511 |
| C00060      |                 2.83 |      512 |
| C00281      |                 2.83 |      513 |
| C00756      |                 2.83 |      514 |
| C00082      |                 2.82 |      515 |
| C00117      |                 2.82 |      516 |
| C00633      |                 2.82 |      517 |
| C00481      |                 2.81 |      518 |
| C00144      |                 2.80 |      519 |
| C00556      |                 2.80 |      520 |
| C00255      |                 2.78 |      521 |
| C00443      |                 2.78 |      522 |
| C00933      |                 2.78 |      523 |
| C00503      |                 2.77 |      524 |
| C00545      |                 2.77 |      525 |
| C00341      |                 2.76 |      526 |
| C00431      |                 2.76 |      527 |
| C00967      |                 2.76 |      528 |
| C00003      |                 2.75 |      529 |
| C00725      |                 2.75 |      530 |
| C00071      |                 2.74 |      531 |
| C00339      |                 2.74 |      532 |
| C00915      |                 2.74 |      533 |
| C00608      |                 2.73 |      534 |
| C00625      |                 2.73 |      535 |
| C00629      |                 2.73 |      536 |
| C00678      |                 2.73 |      537 |
| C00905      |                 2.72 |      538 |
| C00913      |                 2.72 |      539 |
| C00110      |                 2.71 |      540 |
| C00130      |                 2.71 |      541 |
| C00524      |                 2.71 |      542 |
| C00014      |                 2.70 |      543 |
| C00475      |                 2.70 |      544 |
| C00601      |                 2.70 |      545 |
| C00607      |                 2.70 |      546 |
| C00526      |                 2.69 |      547 |
| C00043      |                 2.68 |      548 |
| C00073      |                 2.68 |      549 |
| C00254      |                 2.67 |      550 |
| C00603      |                 2.67 |      551 |
| C00955      |                 2.67 |      552 |
| C00119      |                 2.66 |      553 |
| C00187      |                 2.66 |      554 |
| C00688      |                 2.66 |      555 |
| C00997      |                 2.66 |      556 |
| C00176      |                 2.65 |      557 |
| C00456      |                 2.65 |      558 |
| C00713      |                 2.64 |      559 |
| C00718      |                 2.64 |      560 |
| C00838      |                 2.64 |      561 |
| C00430      |                 2.63 |      562 |
| C00701      |                 2.61 |      563 |
| C00044      |                 2.60 |      564 |
| C00787      |                 2.60 |      565 |
| C00872      |                 2.60 |      566 |
| C00236      |                 2.59 |      567 |
| C00120      |                 2.58 |      568 |
| C00288      |                 2.58 |      569 |
| C00861      |                 2.58 |      570 |
| C00900      |                 2.58 |      571 |
| C00627      |                 2.57 |      572 |
| C00199      |                 2.56 |      573 |
| C00222      |                 2.56 |      574 |
| C00583      |                 2.56 |      575 |
| C00686      |                 2.56 |      576 |
| C00428      |                 2.55 |      577 |
| C00716      |                 2.55 |      578 |
| C00487      |                 2.54 |      579 |
| C00164      |                 2.53 |      580 |
| C00811      |                 2.53 |      581 |
| C00835      |                 2.53 |      582 |
| C00361      |                 2.50 |      583 |
| C00464      |                 2.50 |      584 |
| C00640      |                 2.50 |      585 |
| C00497      |                 2.49 |      586 |
| C00972      |                 2.49 |      587 |
| C00359      |                 2.48 |      588 |
| C00528      |                 2.48 |      589 |
| C00794      |                 2.48 |      590 |
| C00399      |                 2.47 |      591 |
| C00979      |                 2.47 |      592 |
| C00058      |                 2.46 |      593 |
| C00131      |                 2.46 |      594 |
| C00390      |                 2.46 |      595 |
| C00547      |                 2.46 |      596 |
| C00637      |                 2.46 |      597 |
| C00410      |                 2.44 |      598 |
| C00839      |                 2.44 |      599 |
| C00849      |                 2.44 |      600 |
| C00616      |                 2.43 |      601 |
| C00775      |                 2.43 |      602 |
| C00389      |                 2.42 |      603 |
| C00541      |                 2.42 |      604 |
| C00644      |                 2.42 |      605 |
| C00956      |                 2.41 |      606 |
| C00266      |                 2.40 |      607 |
| C00631      |                 2.40 |      608 |
| C00699      |                 2.40 |      609 |
| C00433      |                 2.39 |      610 |
| C00513      |                 2.38 |      611 |
| C00925      |                 2.38 |      612 |
| C00656      |                 2.37 |      613 |
| C00752      |                 2.37 |      614 |
| C00941      |                 2.37 |      615 |
| C00998      |                 2.36 |      616 |
| C00160      |                 2.34 |      617 |
| C00578      |                 2.34 |      618 |
| C00745      |                 2.34 |      619 |
| C00946      |                 2.34 |      620 |
| C00056      |                 2.33 |      621 |
| C00543      |                 2.33 |      622 |
| C00190      |                 2.32 |      623 |
| C00425      |                 2.32 |      624 |
| C00742      |                 2.32 |      625 |
| C00760      |                 2.32 |      626 |
| C00772      |                 2.32 |      627 |
| C00931      |                 2.32 |      628 |
| C00511      |                 2.31 |      629 |
| C00535      |                 2.31 |      630 |
| C00163      |                 2.30 |      631 |
| C00567      |                 2.30 |      632 |
| C00776      |                 2.30 |      633 |
| C00817      |                 2.30 |      634 |
| C00284      |                 2.29 |      635 |
| C00396      |                 2.29 |      636 |
| C00066      |                 2.28 |      637 |
| C00372      |                 2.28 |      638 |
| C00919      |                 2.28 |      639 |
| C00272      |                 2.27 |      640 |
| C00062      |                 2.26 |      641 |
| C00324      |                 2.26 |      642 |
| C00184      |                 2.25 |      643 |
| C00534      |                 2.25 |      644 |
| C00700      |                 2.25 |      645 |
| C00790      |                 2.25 |      646 |
| C00976      |                 2.25 |      647 |
| C00198      |                 2.24 |      648 |
| C00974      |                 2.24 |      649 |
| C00726      |                 2.23 |      650 |
| C00667      |                 2.20 |      651 |
| C00302      |                 2.19 |      652 |
| C00189      |                 2.18 |      653 |
| C00350      |                 2.18 |      654 |
| C00595      |                 2.17 |      655 |
| C00104      |                 2.16 |      656 |
| C00387      |                 2.16 |      657 |
| C00754      |                 2.16 |      658 |
| C00748      |                 2.15 |      659 |
| C00784      |                 2.15 |      660 |
| C00180      |                 2.13 |      661 |
| C00218      |                 2.13 |      662 |
| C00800      |                 2.13 |      663 |
| C00879      |                 2.13 |      664 |
| C00028      |                 2.11 |      665 |
| C00636      |                 2.11 |      666 |
| C00814      |                 2.11 |      667 |
| C00881      |                 2.11 |      668 |
| C00527      |                 2.10 |      669 |
| C00867      |                 2.08 |      670 |
| C00030      |                 2.07 |      671 |
| C00870      |                 2.07 |      672 |
| C00880      |                 2.07 |      673 |
| C00903      |                 2.07 |      674 |
| C00909      |                 2.07 |      675 |
| C00414      |                 2.05 |      676 |
| C00305      |                 2.04 |      677 |
| C00423      |                 2.04 |      678 |
| C00914      |                 2.04 |      679 |
| C00101      |                 2.02 |      680 |
| C00916      |                 2.02 |      681 |
| C00015      |                 2.01 |      682 |
| C00353      |                 2.01 |      683 |
| C00944      |                 2.00 |      684 |
| C00362      |                 1.99 |      685 |
| C00479      |                 1.99 |      686 |
| C00499      |                 1.99 |      687 |
| C00159      |                 1.98 |      688 |
| C00777      |                 1.98 |      689 |
| C00904      |                 1.98 |      690 |
| C00075      |                 1.97 |      691 |
| C00375      |                 1.97 |      692 |
| C00936      |                 1.97 |      693 |
| C00523      |                 1.95 |      694 |
| C00785      |                 1.95 |      695 |
| C00884      |                 1.94 |      696 |
| C01000      |                 1.94 |      697 |
| C00037      |                 1.93 |      698 |
| C00065      |                 1.93 |      699 |
| C00862      |                 1.93 |      700 |
| C00285      |                 1.92 |      701 |
| C00243      |                 1.91 |      702 |
| C00581      |                 1.89 |      703 |
| C00654      |                 1.88 |      704 |
| C00795      |                 1.88 |      705 |
| C00820      |                 1.88 |      706 |
| C00824      |                 1.88 |      707 |
| C00086      |                 1.87 |      708 |
| C00323      |                 1.87 |      709 |
| C00554      |                 1.86 |      710 |
| C00917      |                 1.86 |      711 |
| C00143      |                 1.85 |      712 |
| C00148      |                 1.85 |      713 |
| C00091      |                 1.84 |      714 |
| C00783      |                 1.84 |      715 |
| C00755      |                 1.82 |      716 |
| C00570      |                 1.81 |      717 |
| C00584      |                 1.81 |      718 |
| C00394      |                 1.80 |      719 |
| C00921      |                 1.79 |      720 |
| C00476      |                 1.78 |      721 |
| C00939      |                 1.78 |      722 |
| C00214      |                 1.77 |      723 |
| C00346      |                 1.77 |      724 |
| C00158      |                 1.76 |      725 |
| C00267      |                 1.76 |      726 |
| C00002      |                 1.75 |      727 |
| C00306      |                 1.75 |      728 |
| C00490      |                 1.75 |      729 |
| C00649      |                 1.74 |      730 |
| C00128      |                 1.73 |      731 |
| C00685      |                 1.73 |      732 |
| C00999      |                 1.73 |      733 |
| C00070      |                 1.72 |      734 |
| C00185      |                 1.72 |      735 |
| C00223      |                 1.71 |      736 |
| C00799      |                 1.71 |      737 |
| C00709      |                 1.70 |      738 |
| C00352      |                 1.69 |      739 |
| C00466      |                 1.69 |      740 |
| C00035      |                 1.68 |      741 |
| C00069      |                 1.68 |      742 |
| C00084      |                 1.68 |      743 |
| C00436      |                 1.68 |      744 |
| C00230      |                 1.67 |      745 |
| C00102      |                 1.66 |      746 |
| C00309      |                 1.66 |      747 |
| C00136      |                 1.65 |      748 |
| C00240      |                 1.65 |      749 |
| C00711      |                 1.65 |      750 |
| C00840      |                 1.65 |      751 |
| C00493      |                 1.64 |      752 |
| C00632      |                 1.64 |      753 |
| C00739      |                 1.64 |      754 |
| C00845      |                 1.63 |      755 |
| C00237      |                 1.62 |      756 |
| C00304      |                 1.62 |      757 |
| C00452      |                 1.62 |      758 |
| C00038      |                 1.61 |      759 |
| C00376      |                 1.61 |      760 |
| C00604      |                 1.61 |      761 |
| C00591      |                 1.60 |      762 |
| C00868      |                 1.60 |      763 |
| C00258      |                 1.59 |      764 |
| C00392      |                 1.59 |      765 |
| C00615      |                 1.59 |      766 |
| C00692      |                 1.59 |      767 |
| C00200      |                 1.58 |      768 |
| C00759      |                 1.58 |      769 |
| C00345      |                 1.57 |      770 |
| C00551      |                 1.57 |      771 |
| C00837      |                 1.57 |      772 |
| C00859      |                 1.57 |      773 |
| C00154      |                 1.56 |      774 |
| C00561      |                 1.56 |      775 |
| C00833      |                 1.56 |      776 |
| C00928      |                 1.56 |      777 |
| C00124      |                 1.55 |      778 |
| C00812      |                 1.54 |      779 |
| C00093      |                 1.52 |      780 |
| C00474      |                 1.52 |      781 |
| C00851      |                 1.52 |      782 |
| C00697      |                 1.51 |      783 |
| C00722      |                 1.51 |      784 |
| C00737      |                 1.51 |      785 |
| C00792      |                 1.49 |      786 |
| C00049      |                 1.48 |      787 |
| C00106      |                 1.48 |      788 |
| C00116      |                 1.48 |      789 |
| C00420      |                 1.48 |      790 |
| C00993      |                 1.48 |      791 |
| C00488      |                 1.47 |      792 |
| C00142      |                 1.46 |      793 |
| C00226      |                 1.46 |      794 |
| C00310      |                 1.45 |      795 |
| C00312      |                 1.45 |      796 |
| C00495      |                 1.44 |      797 |
| C00564      |                 1.44 |      798 |
| C00698      |                 1.44 |      799 |
| C00815      |                 1.44 |      800 |
| C00468      |                 1.43 |      801 |
| C00273      |                 1.42 |      802 |
| C00491      |                 1.42 |      803 |
| C00544      |                 1.42 |      804 |
| C00741      |                 1.42 |      805 |
| C00990      |                 1.42 |      806 |
| C00031      |                 1.41 |      807 |
| C00945      |                 1.40 |      808 |
| C00828      |                 1.39 |      809 |
| C00962      |                 1.39 |      810 |
| C00609      |                 1.38 |      811 |
| C00005      |                 1.37 |      812 |
| C00364      |                 1.37 |      813 |
| C00770      |                 1.37 |      814 |
| C00055      |                 1.36 |      815 |
| C00250      |                 1.36 |      816 |
| C00832      |                 1.36 |      817 |
| C00178      |                 1.35 |      818 |
| C00602      |                 1.35 |      819 |
| C00977      |                 1.35 |      820 |
| C00427      |                 1.34 |      821 |
| C00531      |                 1.34 |      822 |
| C00807      |                 1.33 |      823 |
| C00321      |                 1.32 |      824 |
| C00675      |                 1.32 |      825 |
| C00896      |                 1.31 |      826 |
| C00381      |                 1.30 |      827 |
| C00397      |                 1.30 |      828 |
| C00421      |                 1.30 |      829 |
| C00803      |                 1.30 |      830 |
| C00109      |                 1.29 |      831 |
| C00247      |                 1.28 |      832 |
| C00261      |                 1.28 |      833 |
| C00822      |                 1.28 |      834 |
| C00177      |                 1.27 |      835 |
| C00319      |                 1.27 |      836 |
| C00642      |                 1.27 |      837 |
| C00710      |                 1.27 |      838 |
| C00138      |                 1.26 |      839 |
| C00251      |                 1.26 |      840 |
| C00948      |                 1.26 |      841 |
| C00653      |                 1.25 |      842 |
| C00843      |                 1.25 |      843 |
| C00259      |                 1.24 |      844 |
| C00409      |                 1.24 |      845 |
| C00694      |                 1.24 |      846 |
| C00053      |                 1.23 |      847 |
| C00314      |                 1.23 |      848 |
| C00853      |                 1.23 |      849 |
| C00857      |                 1.23 |      850 |
| C00151      |                 1.22 |      851 |
| C00518      |                 1.22 |      852 |
| C00938      |                 1.22 |      853 |
| C00087      |                 1.21 |      854 |
| C00937      |                 1.21 |      855 |
| C00308      |                 1.20 |      856 |
| C00985      |                 1.19 |      857 |
| C00458      |                 1.18 |      858 |
| C00902      |                 1.18 |      859 |
| C00013      |                 1.17 |      860 |
| C00377      |                 1.16 |      861 |
| C00096      |                 1.15 |      862 |
| C00244      |                 1.15 |      863 |
| C00771      |                 1.15 |      864 |
| C00537      |                 1.12 |      865 |
| C00889      |                 1.12 |      866 |
| C00960      |                 1.12 |      867 |
| C00360      |                 1.11 |      868 |
| C00445      |                 1.11 |      869 |
| C00133      |                 1.10 |      870 |
| C00753      |                 1.10 |      871 |
| C00693      |                 1.09 |      872 |
| C00920      |                 1.09 |      873 |
| C00019      |                 1.08 |      874 |
| C00318      |                 1.08 |      875 |
| C00435      |                 1.08 |      876 |
| C00512      |                 1.08 |      877 |
| C00762      |                 1.08 |      878 |
| C00081      |                 1.06 |      879 |
| C00167      |                 1.06 |      880 |
| C00297      |                 1.06 |      881 |
| C00687      |                 1.06 |      882 |
| C00220      |                 1.05 |      883 |
| C00263      |                 1.05 |      884 |
| C00557      |                 1.05 |      885 |
| C00623      |                 1.05 |      886 |
| C00041      |                 1.04 |      887 |
| C00575      |                 1.04 |      888 |
| C00782      |                 1.03 |      889 |
| C00894      |                 1.03 |      890 |
| C00809      |                 1.01 |      891 |
| C00963      |                 1.01 |      892 |
| C00088      |                 1.00 |      893 |
| C00331      |                 1.00 |      894 |
| C00403      |                 1.00 |      895 |
| C00930      |                 1.00 |      896 |
| C00171      |                 0.99 |      897 |
| C00461      |                 0.99 |      898 |
| C00505      |                 0.99 |      899 |
| C00727      |                 0.99 |      900 |
| C00766      |                 0.99 |      901 |
| C00923      |                 0.99 |      902 |
| C00139      |                 0.98 |      903 |
| C00395      |                 0.98 |      904 |
| C00508      |                 0.98 |      905 |
| C00599      |                 0.97 |      906 |
| C00089      |                 0.96 |      907 |
| C00502      |                 0.96 |      908 |
| C00553      |                 0.96 |      909 |
| C00791      |                 0.95 |      910 |
| C00241      |                 0.94 |      911 |
| C00715      |                 0.94 |      912 |
| C00029      |                 0.92 |      913 |
| C00125      |                 0.92 |      914 |
| C00211      |                 0.92 |      915 |
| C00552      |                 0.92 |      916 |
| C00630      |                 0.92 |      917 |
| C00645      |                 0.92 |      918 |
| C00449      |                 0.90 |      919 |
| C00550      |                 0.89 |      920 |
| C00650      |                 0.89 |      921 |
| C00844      |                 0.89 |      922 |
| C00994      |                 0.89 |      923 |
| C00549      |                 0.88 |      924 |
| C00079      |                 0.87 |      925 |
| C00354      |                 0.87 |      926 |
| C00539      |                 0.87 |      927 |
| C00628      |                 0.87 |      928 |
| C00719      |                 0.87 |      929 |
| C00740      |                 0.87 |      930 |
| C00810      |                 0.87 |      931 |
| C00337      |                 0.86 |      932 |
| C00749      |                 0.85 |      933 |
| C00282      |                 0.84 |      934 |
| C00893      |                 0.84 |      935 |
| C00083      |                 0.83 |      936 |
| C00023      |                 0.81 |      937 |
| C00322      |                 0.81 |      938 |
| C00349      |                 0.81 |      939 |
| C00462      |                 0.81 |      940 |
| C00848      |                 0.81 |      941 |
| C00385      |                 0.80 |      942 |
| C00565      |                 0.80 |      943 |
| C00012      |                 0.78 |      944 |
| C00017      |                 0.78 |      945 |
| C00298      |                 0.78 |      946 |
| C00419      |                 0.78 |      947 |
| C00016      |                 0.77 |      948 |
| C00026      |                 0.77 |      949 |
| C00691      |                 0.77 |      950 |
| C00793      |                 0.77 |      951 |
| C00869      |                 0.77 |      952 |
| C00996      |                 0.77 |      953 |
| C00188      |                 0.76 |      954 |
| C00669      |                 0.76 |      955 |
| C00906      |                 0.76 |      956 |
| C00973      |                 0.76 |      957 |
| C00660      |                 0.74 |      958 |
| C00111      |                 0.73 |      959 |
| C00542      |                 0.72 |      960 |
| C00007      |                 0.71 |      961 |
| C00046      |                 0.71 |      962 |
| C00646      |                 0.71 |      963 |
| C00827      |                 0.71 |      964 |
| C00137      |                 0.70 |      965 |
| C00234      |                 0.70 |      966 |
| C00779      |                 0.69 |      967 |
| C00668      |                 0.68 |      968 |
| C00935      |                 0.68 |      969 |
| C00291      |                 0.67 |      970 |
| C00614      |                 0.66 |      971 |
| C00618      |                 0.66 |      972 |
| C00147      |                 0.65 |      973 |
| C00195      |                 0.65 |      974 |
| C00519      |                 0.65 |      975 |
| C00454      |                 0.64 |      976 |
| C00338      |                 0.63 |      977 |
| C00235      |                 0.62 |      978 |
| C00804      |                 0.62 |      979 |
| C00408      |                 0.61 |      980 |
| C00773      |                 0.60 |      981 |
| C00522      |                 0.59 |      982 |
| C00901      |                 0.59 |      983 |
| C00968      |                 0.59 |      984 |
| C00048      |                 0.58 |      985 |
| C00351      |                 0.57 |      986 |
| C00952      |                 0.57 |      987 |
| C00929      |                 0.56 |      988 |
| C00533      |                 0.55 |      989 |
| C00885      |                 0.54 |      990 |
| C00980      |                 0.53 |      991 |
| C00290      |                 0.52 |      992 |
| C00294      |                 0.52 |      993 |
| C00422      |                 0.52 |      994 |
| C00806      |                 0.52 |      995 |
| C00252      |                 0.51 |      996 |
| C00459      |                 0.51 |      997 |
| C00761      |                 0.51 |      998 |
| C00538      |                 0.50 |      999 |
+-------------+----------------------+----------+
999 rows in set (0.01 sec)

mysql> SELECT customer_id, daily_watch_time_hrs, ROW_NUMBER() OVER(ORDER BY daily_watch_time_hrs DESC) AS rank_num FROM netflix_clean LIMIT 10;
+-------------+----------------------+----------+
| customer_id | daily_watch_time_hrs | rank_num |
+-------------+----------------------+----------+
| C00040      |                 5.00 |        1 |
| C00734      |                 4.99 |        2 |
| C00834      |                 4.99 |        3 |
| C00085      |                 4.98 |        4 |
| C00034      |                 4.97 |        5 |
| C00334      |                 4.97 |        6 |
| C00788      |                 4.97 |        7 |
| C00328      |                 4.96 |        8 |
| C00006      |                 4.95 |        9 |
| C00209      |                 4.94 |       10 |
+-------------+----------------------+----------+
10 rows in set (0.00 sec)

mysql> WITH loyal_customers AS (SELECT * FROM netflix_clean WHERE customer_satisfaction_score >= 8) SELECT ROUND(COUNT(*) * 100.0 /(SELECT COUNT(*) FROM netflix_clean),2) AS loyal_customer_percentage FROM loyal_customers;
+---------------------------+
| loyal_customer_percentage |
+---------------------------+
|                     28.43 |
+---------------------------+
1 row in set (0.00 sec)

mysql> WITH loyal_customers AS (SELECT customer_id, customer_satisfaction_score, daily_watch_time_hrs FROM netflix_clean WHERE customer_satisfaction_score >= 8) SELECT * FROM loyal_customers LIMIT 10;
+-------------+-----------------------------+----------------------+
| customer_id | customer_satisfaction_score | daily_watch_time_hrs |
+-------------+-----------------------------+----------------------+
| C00001      |                          10 |                 4.85 |
| C00002      |                           8 |                 1.75 |
| C00009      |                           9 |                 3.79 |
| C00011      |                           9 |                 2.88 |
| C00019      |                           9 |                 1.08 |
| C00027      |                           9 |                 4.40 |
| C00029      |                          10 |                 0.92 |
| C00031      |                           8 |                 1.41 |
| C00033      |                           9 |                 3.48 |
| C00035      |                          10 |                 1.68 |
+-------------+-----------------------------+----------------------+
10 rows in set (0.00 sec)

mysql> CREATE VIEW churn_summary AS SELECT subscription_plan, COUNT(*) AS total_customers, SUM(churn_status = 'Yes') AS churned_customers, ROUND(AVG(churn_status = 'Yes') *100, 2) AS churn_rate FROM netflix_clean GROUP BY subscription_plan;
Query OK, 0 rows affected (0.03 sec)

mysql> SELECT * FROM churn_summary;
+-------------------+-----------------+-------------------+------------+
| subscription_plan | total_customers | churned_customers | churn_rate |
+-------------------+-----------------+-------------------+------------+
| Basic             |             319 |               175 |      54.86 |
| Premium           |             328 |               176 |      53.66 |
| Standard          |             352 |               188 |      53.41 |
+-------------------+-----------------+-------------------+------------+
3 rows in set (0.01 sec)

mysql> 
