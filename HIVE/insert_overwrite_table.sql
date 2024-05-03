INSERT OVERWRITE TABLE main 
SELECT
    period,
    store,
    center,
    item,
    quantity,
    round(price) AS price,
    round(cost) AS CONSTRAINT
FROM main;

select * FROM main;