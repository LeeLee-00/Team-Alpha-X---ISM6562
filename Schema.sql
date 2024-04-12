Create KEYSPACE store
    WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 3};

CREATE TABLE store.total_sales (
    period int,
    store int,
    item int,
    center int,
    quantity int,
    price float,
    cost float,
    sales float,
    PRIMARY KEY ((period), store, item, center)
) WITH comment = 'Q1.Total sales by period, store, item, and center';

CREATE TABLE store.store_sales (
    store int,
    period int,
    center int,
    region text,
    price float,
    quantity int,
    cost float,
    sales float,
    PRIMARY KEY ((store), period, center, region)
)WITH comment = 'Q2. Store sales by period, center, and region';

CREATE TABLE store.high_perform_item_cat (
    item int,
    period int,
    center int,
    category text,
    sales float,
    PRIMARY KEY ((item), period, center, category, sales) ## sales is added to clustering key for sorting
)WITH comment = 'Q3. High performing items by category'
AND CLUSTERING ORDER BY (sales DESC);

CREATE TABLE store.low_perform_item_cat (
    item int,
    period int,
    center int,
    category text,
    sales float,
    PRIMARY KEY ((item), period, center, category, sales) ## sales is added to clustering key for sorting
)WITH comment = 'Q4. Low performing items by category'
AND CLUSTERING ORDER BY (sales ASC);

CREATE TABLE store.top_regions_per_capita (
    region text,
    period int,
    price float,
    sales_per_capita float,
    cost float,
    quantity int,
    PRIMARY KEY ((region), period, sales) ## sales is added to clustering key for sorting
) WITH comment = 'Q5. Top regions by sales per capita'
AND CLUSTERING ORDER BY (sales DESC);

CREATE TABLE store.bottom_regions_per_capita (
    region text,
    period int,
    price float,
    sales_per_capita float,
    cost float,
    quantity int,
    PRIMARY KEY ((region), period, sales) ## sales is added to clustering key for sorting
) WITH comment = 'Q6. Top regions by sales per capita'
AND CLUSTERING ORDER BY (sales ASC);

CREATE TABLE store.store_profit_margin (
    store int,
    period int,
    cost float,
    sales float,
    profit float,
    PRIMARY KEY ((store), period)
) WITH comment = 'Q7. Store profit margin by period';

CREATE TABLE store.item_demand (
    item int,
    period int,
    center int,
    quantity int,
    PRIMARY KEY ((item), period, center)
) WITH comment = 'Q8. Item demand by period and center';