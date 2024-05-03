-- Set the session properties for ACID operations
SET hive.support.concurrency = true;
SET hive.txn.manager = org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;
SET hive.enforce.bucketing = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

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

-- Insert data into the table
INSERT INTO TABLE main VALUES
    (20180122, 1139, 2, 40937, 1, 11.41, 1.24),
    (20180125, 1144, 2, 40761, 1, 7.84, 1.92),
    (20180125, 1133, 3, 40790, 1, 8.27, 2.3),
    (20180122, 1143, 1, 40962, 1, 3.84, 0.54);

-- Select all
SELECT *
FROM main;
