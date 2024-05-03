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