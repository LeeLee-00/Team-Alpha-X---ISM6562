SELECT * FROM store.regions_by_sales_per_capita
WHERE period >= '2024-01-01'  
ORDER BY sales_per_capita DESC
LIMIT 5;

SELECT * FROM store.total_sales
WHERE period >= '2024-01-01'  
ORDER BY sales DESC
LIMIT 5;

SELECT * FROM store.high_perform_item_cat
WHERE 	period >= '2024-01-01' 
    AND center in (1,2,3) -- Instore, DriveThru, Delivery
  AND category in ('ALC','Entree','Combo','Deserts') 
  ORDER BY sales DESC
LIMIT 1;