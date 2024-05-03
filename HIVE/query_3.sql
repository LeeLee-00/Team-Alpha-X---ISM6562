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