-- 1. Datasetde nece sifaris oldugunu mueyyen etdim
select count(row_id) as total_sifarish_sayi
from superstore1

-- 2. Umumi satis meblegini hesabladim
select round(sum(sales),0) as total_sales
from superstore1

-- 3. Umumi menfeeti hesabladim
select round(sum(profit),0) as total_profit
from superstore1

-- 4. Iller uzre satislari muqayise etdim
select extract(year from order_date) as years,
       round(sum(sales),0) as total_sales
from superstore1
group by extract(year from order_date)
order by total_sales desc

-- 5. Regionlar uzre satis ve menfeeti mueyyen etdim
select region, round(sum(sales),0) as total_sales, round(sum(profit),0) as total_profit
from superstore1
group by region
order by total_profit desc

-- 6. En cox satilan 10 mehsulu tapdim
select product_name, sum(quantity) as mehsul_sayi
from superstore1
group by product_name
order by mehsul_sayi desc
fetch first 10 rows only

-- 7. En cox menfeet getiren 10 mehsulu tapdim
select product_name, round(sum(profit),0) as total_profit
from superstore1
group by product_name
order by total_profit desc
fetch first 10 rows only

-- 8. Zerere getiren mehsullari mueyyen etdim
select * from superstore1
order by profit

-- 9. Endirimle menfeet arasindaki elaqeni arasdirdim
select discount, count(*) as total_orders,round(sum(sales), 2) as total_sales,round(sum(profit), 2) as total_profit,
round(avg(profit), 2) as avg_profit
from superstore1
group by discount
order by discount

-- 10. En cox gelir getiren musterileri mueyyen etdim
select customer_name, sum(sales) as total_sales
from superstore1
group by customer_name
order by total_sales desc
fetch first 100 rows only

-- 11. LAG() istifade ederek aylıq satis artimini hesabladim
with monthly_sales as (
select trunc(order_date, 'mm') as sales_month, sum(sales) as total_sales
from superstore1
group by trunc(order_date, 'mm')
)
select sales_month, total_sales,
    lag(total_sales) over (
        order by sales_month
    ) as previous_month_sales,
    round(
        (total_sales - lag(total_sales) over (
            order by sales_month
        )) /
        nullif(lag(total_sales) over (
            order by sales_month
        ), 0) * 100,
        2
    ) as growth_percent
from monthly_sales
order by sales_month

-- 12. RANK() istifade ederek musterileri satis hecmine gore siraladim
select
    customer_name,
    sum(sales) as total_sales,
    rank() over (
        order by sum(sales) desc
    ) as sales_rank
from superstore1
group by customer_name
order by sales_rank