;WITH order_amounts AS(
	SELECT DISTINCT s.[store_name]
      ,o.[order_id]
	  ,o.[order_date]
	  ,sum((oi.[quantity] * oi.[list_price]) - (oi.[quantity] * oi.[list_price] * oi.[discount])) over(partition by o.[order_id] order by s.[store_name], o.[order_date]) [order_amount]
  FROM [sales].[orders] as o
  inner join [sales].[order_items] oi ON o.[order_id] = oi.[order_id]
  inner join [sales].[stores] as s ON o.[store_id] = s.[store_id]
)

SELECT [store_name]
,[order_id]
,[order_date]
,[order_amount]
,avg([order_amount]) over (partition by [store_name] order by [order_date] rows between 6 preceding and current row) [avg_7_days_sale]
FROM order_amounts
