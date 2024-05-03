# Assignment: Implementing RDBMS Schema in Apache Hive

## Team Alpha - X
### Members:
* Cristobal Banda
* Jose Bauza
* Silvia Castro
* Lee Noel

## Introduction

Apache Hive, created by Facebook in 2021, is designed for non-programmers handling petabytes of data. It excels in data warehousing, reporting, and analytics through its batch processing system built on Hadoop MapReduce and the Hadoop Distributed File Systems (HDFS). Hive's SQL interface facilitates integration, supporting complex queries like aggregations for analytics. By implementing our RDBMS in Hive, we aim to evaluate performance impacts and determine the feasibility of transitioning to Hive for companies with large datasets. Hive enables rapid querying and analytics for front-facing client interfaces, providing timely insights without data staleness due to HDFS's reliability and replication features.

## Analyze the RDBMS Schema

*The RDBMS ERD Schema is completed.*

![RDBMS Schema Diagram](<RDBMS Schema Diagram.png>)

## Analysis of RDBMS ERD Schema Design

The provided Entity-Relationship Diagram (ERD) represents a complex RDBMS schema consisting of several interconnected tables, which we'll examine to guide our NoSQL schema design.

### Key Tables and Their Relationships

- `Items`: Central to inventory management, this table records item details with a unique identifier for each item.
- `Centers`: Represents distribution or sales centers, with attributes detailing each center's operations.
- `DataLoad`: Appears to be a transactional log table capturing sales or transaction data, potentially from POS systems.
- `Meals`: Likely a catalog of meal options, possibly in a restaurant or meal-kit delivery context.
- `Stores`: Details store information, critical for regional sales analysis and supply chain logistics.
- `SUMPI`: An aggregation table summarizing item-based transactions, indicating a need for high-speed reads on item-centric analytics.
- `SUMPS`: Similar to `SUMPI`, but focused on store-based transaction aggregations for regional analysis and reporting.

Each table is equipped with primary keys to ensure data integrity and foreign keys that establish relationships, creating a network of dependencies essential for maintaining relational integrity.

## Schema Implementation in Hive

Implementing a schema in Hive requires thoughtful consideration of the system's capabilities and limitations, particularly when working with large datasets typical of big data environments. Our team has taken the following steps to ensure optimal performance and reliability:

- **Reliability**: We leveraged HDFS replication mechanisms to ensure data integrity and availability. By setting up replication, we protect against data loss in the event of hardware failure, ensuring that our system can recover quickly without impacting data consistency. This is crucial for maintaining service levels in production environments.

- **Speed**: Utilizing HDFS multi-nodes for faster data processing allows us to take advantage of parallel processing capabilities inherent in Hadoop's architecture. This approach significantly reduces the time required to execute queries and process large volumes of data, which is critical for timely analytics.

- **Large Processing**: By harnessing the multi-node capabilities of HDFS, we have scaled our data processing operations to meet the demands of increasing data volumes. This scalability ensures that our Hive implementation can handle growth in data ingestion rates without a degradation in performance, which is vital for future-proofing our system.

- **Optimization**: Implementing partitions and constraints within Hive has been a cornerstone of our strategy to enhance query performance and manage data more efficiently. By carefully designing our table partitions around key attributes that are frequently accessed in queries, we reduce query latency and increase the efficiency of data retrieval. Additionally, applying constraints has helped maintain data quality by enforcing business rules at the database level.

- **Data Warehousing and Large Scale ETL**: Our Hive setup is designed to function as a robust data warehousing solution with extensive ETL (Extract, Transform, Load) capabilities. The choice of Hive for these tasks is justified by its excellent support for batch processing large datasets, which is typical in data warehousing scenarios. We also optimized our ETL processes by integrating Hive with other Hadoop ecosystem components like Apache Pig and Apache Spark for data transformations and aggregations.

- **ACID Properties**: To support transactional data modifications, we enabled Hive's ACID (Atomicity, Consistency, Isolation, Durability) properties, which are essential for ensuring data integrity in environments where multiple users or applications might be modifying the data concurrently.

Each of these elements was selected and implemented with a clear focus on maximizing performance while ensuring robustness and scalability of our Hive database. These thoughtful implementations align with our strategic objectives and demonstrate our team's expertise in adapting Hive to our specific needs.


## Hive Schema SQL Explanation

Our Hive table schema is designed to leverage Hive’s capabilities for handling large-scale data with transactional integrity and optimized query performance. Below is an explanation of each part of the schema setup:

### Session Properties for ACID Operations
```sql
SET hive.support.concurrency = true;
SET hive.txn.manager = org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;
SET hive.enforce.bucketing = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
```

These settings are crucial for enabling ACID (Atomicity, Consistency, Isolation, Durability) properties in Hive, which are essential for transactional data integrity:

- `hive.support.concurrency`: Enables concurrent access to the Hive tables, which is necessary for multiple users or processes to modify the data simultaneously.

- `hive.txn.manager`: Sets the transaction manager to handle transactions within Hive, ensuring that all data transactions are processed reliably.

- `hive.enforce.bucketing`: Enforces bucketing in Hive, which is a data organization technique that improves query performance by clustering data into manageable chunks.

- `hive.exec.dynamic.partition.mode` = nonstrict: Allows for dynamic partitioning, enabling Hive to automatically create partitions as necessary during data insertion, enhancing flexibility and performance in data handling.

### Table Creation and Configuration
```sql
-- Drop the table if it exists
DROP TABLE IF EXISTS main;

-- Create the table with transactional properties
CREATE TABLE main(
    STORE SMALLINT,
    CENTER SMALLINT,
    ITEM INT,
    QUANTITY BIGINT,
    PRICE FLOAT,
    COST FLOAT
)
STORED AS ORC
CLUSTERED BY (CENTER) INTO 3 BUCKETS
TBLPROPERTIES ('transactional'='true');
```
- `DROP TABLE IF EXISTS main;`: Ensures that there is no existing table named 'main', preventing any conflicts during the creation of the new table.

- The `CREATE TABLE` statement initializes a new table with specific columns designed to store various types of data such as store ID, center ID, item ID, quantity, price, and cost. Each column type is chosen based on the data it will store, optimizing space and performance.

- `STORED AS ORC`: The table uses the Optimized Row Columnar (ORC) file format, which provides a highly efficient way to store Hive data. ORC improves performance through its columnar storage format, enabling better compression and faster read and write operations.

- `CLUSTERED BY (CENTER) INTO 3 BUCKETS`: Implements bucketing by the 'CENTER' column, dividing the data into three buckets. This improves query performance by organizing data in a manner that optimizes data retrieval.

- `TBLPROPERTIES ('transactional'='true')`: Enables transactional capabilities for the table, supporting operations like insert, delete, and update within a transactional context.

### Data Manipulation
```sql
-- Insert data into the table
INSERT INTO TABLE main VALUES
    (20180122, 1139, 2, 40937, 1, 11.41, 1.24),
    (20180125, 1144, 2, 40761, 1, 7.84, 1.92),
    (20180125, 1133, 3, 40790, 1, 8.27, 2.3),
    (20180122, 1143, 1, 40962, 1, 3.84, 0.54);

-- Select all
SELECT *
FROM main;
```
- The `INSERT INTO TABLE` command populates the table with initial data, setting up a base for queries and further manipulation.

- `SELECT * FROM main;`: A simple query to retrieve all records from the table, verifying that data has been inserted correctly and the table functions as expected.

This schema setup in Hive not only supports robust data handling but also enhances query performance, making it suitable for our large-scale data needs

## Schema Results
![Hive Table Schema](<HiveSchemaResults.png>)


## Data Manipulation and Querying

We are exploring several scenarios through HiveQL queries:
- **Q1c**: Item Sales Order by revenue center.
- **Q2c**: Store Sales Order by revenue center.
- **Q1s**: High-performing Item Category per revenue center in revenue terms.
- **Q2s**: Underperforming Item Category per revenue center in revenue terms.
- **Q1j**: Top performing regions per capita.
- **Q2j**: Worst performing regions per capita.
- **Q1l**: Demand levels (quantity) of specified items in each revenue center.
- **Q2l**: Calculating profit margin for each store after accounting for the cost.

## Hive SQL Queries

### Query 1
```sql
--- Query 1 - look wieghted price and cost to understand profit margins
--- Avg Price of Each Category
with T
AS
(
SELECT Item,Store,
  round(CAST(regexp_replace(main.price, '\\D', '') AS float)/100,3)AS Price,
  round(CAST(regexp_replace(main.Cost, '\\D', '') AS float)/100,3)AS Cost,
  main.Quantity AS Quantity
FROM main
  --Where Period between 20230101 and 20230331
 )
 Select 
 i.ItemCat1,
 i.ItemCat2,
 sum(price * quantity)/sum(quantity) as weighted_Price,
 sum(cost * quantity)/sum(quantity) as weighted_Cost
 From T
 Join item I ON t.Item = i.Item 
 group by 
 i.ItemCat1,
 i.ItemCat2
```
### Results
![Query 1 query](<Query1Results.png>)
### Query 2
```sql
--- most observed Item
SELECT ItemAgg as Item,sum(sumpi.quantity)totalQty
FROM sumpi 
group by Itemagg
order by totalQty desc
```
### Results
![Query 2 query](<Query2Results.png>)

### Query 3
```sql
--Top Performing Regions
--This query calculates the sales per store for each region, using a CTE to first determine the total sales per region, 
--then dividing by the number of stores in that region.
WITH RegionSales AS (
  SELECT 
    st.region, 
    SUM(m.quantity * m.price) AS total_sales
  FROM 
    Main m
  JOIN Stores st ON m.store = st.store
  GROUP BY 
    st.region
),
RegionStoreCount AS (
  SELECT 
    region, 
    COUNT(store) AS store_count
  FROM 
    Stores
  GROUP BY 
    region
)
SELECT 
  rs.region, 
  (rs.total_sales / rsc.store_count) AS sales_per_store
FROM 
  RegionSales rs
JOIN RegionStoreCount rsc ON rs.region = rsc.region
ORDER BY 
  sales_per_store DESC
```
### Results
![Query 3 query](<Query3Results.png>)


## Performance Considerations

The performance of Apache Hive, particularly in the context of our project's requirements, offers significant advantages and some limitations. This analysis details these aspects and contrasts Hive with other big data systems to underscore its suitability for our use-case.

- **Batch Processing Efficiency**: Hive excels in batch processing scenarios, making it ideal for our data warehousing and analytics tasks. Its design, built atop Hadoop, allows for the efficient processing of large datasets by distributing jobs across multiple nodes. This capability ensures high throughput and reduces the execution time of complex analytics queries, which is essential for our large-scale data operations.

- **Query Performance**: One of the core strengths of Hive is its optimization for read-heavy operations typical in data analysis workflows. We enhanced this further by implementing optimized file formats like ORC, which provide superior compression and indexing capabilities. This choice significantly speeds up read operations and reduces the load on the network by minimizing data transfer volumes.

- **Comparative Analysis with RDBMS and Cassandra**: While Hive provides robust support for batch processing, it does not offer the low latency of query responses that traditional RDBMS systems or newer NoSQL databases like Cassandra can achieve. For instance, Cassandra supports faster data retrieval in real-time querying scenarios, making it preferable for applications requiring immediate data access. However, Hive's model reduces operational costs significantly by allowing the use of commodity hardware and simplifying the scalability challenges associated with massive datasets.

- **Scalability Concerns**: Compared to Cassandra, which offers linear scalability and proven fault tolerance across numerous data centers, Hive's scalability is somewhat constrained by its reliance on Hadoop's infrastructure. While Hive can handle massive datasets, its performance might degrade as the data volume grows beyond the capacity of the existing Hadoop cluster setup. This aspect required careful consideration and planning in our project to ensure sustained performance.

- **Real-Time Processing**: Hive's traditional weakness in real-time data processing was a significant consideration for us. To mitigate this, we explored alternatives such as integrating Apache Storm for real-time analytics and using Hive for batch processing, thereby combining the strengths of both platforms to meet our comprehensive data processing needs.

This detailed performance analysis not only highlights Hive’s capabilities and limitations but also positions it within a broader ecosystem of big data technologies, enabling us to make informed decisions about our architectural choices based on our specific operational requirements and performance goals.

## Challenges and Learnings

Many of the challenges our team faced during this implementation were related to the syntax of the querying language. Despite being able to leverage SQL, the team had to restructure the queries to be compatible with Hive’s syntax. Hive also has limited data types, which became a challenge when creating our tables due to our table containing monetary data types that are not readily available in Hive. In terms of the HDFS, this system has its own way of accessing, processing, and retrieving data back to the client compared to a relational database. The HDFS schema adds an additional layer of complexity to the design due to its multi-node structure.

Given the similarities and differences between all architectures, choosing an architectural design for a dataset depends on the use case and project requirements. When real-time, quick data access is needed, a Cassandra architecture is more suitable. On the other hand, if these factors are not of much importance and other factors – such as cost – take precedence, Hive should be considered; it is still suitable for large amounts of data but will minimize operational costs if data latency is not an issue.


## Conclusion

Using a Hive framework benefited our data by increasing reliability, speed, and optimization. When designing our tables, we determined what the best partition keys would be. This is because Hive’s HDFS layer uses the partition key to segment data in different tables for optimal and faster performance. The framework also contains multiple nodes in which it can store the data in, improving the speed of processing queries especially when using a large dataset. Additionally, by making use of its HDFS replication capabilities, data is stored in a primary and secondary node to avoid its availability being impacted by a node failure. 
These three aspects – optimization, speed, and reliability – are factors that must be considered when building big data applications and data warehouses in the real world. The importance that each of these would have on a specific dataset is dependent on the business objectives and what the organization is trying to understand from the data, this is why it is important to assess each of these criteria and weigh them against the cost to implement and maintain the solution. In addition to Hive, other architecture designs can be taken into consideration as they may be a better fit for an organization’s needs. For this project, we housed our data in both Hive and Cassandra, each having its own impact, advantages, and disadvantages for our use case. Given our business needs to explore the data and build detailed queries, the Hive architecture is better suited for our dataset. Cassandra’s advantages over Hive, such as its ability to scale easily, is not of concern of ours due to real-time analysis not being necessary to answer the queries we proposed. Therefore, we can make more use of Hive’s features in comparison to Cassandra.

