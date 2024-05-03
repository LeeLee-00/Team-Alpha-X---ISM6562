--- most observed Item
SELECT ItemAgg as Item,sum(sumpi.quantity)totalQty
FROM sumpi 
group by Itemagg
order by totalQty desc