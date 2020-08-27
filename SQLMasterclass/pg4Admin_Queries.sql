select *, case 
	when age<30 then 'Young'
	when age>60 then 'Senior'
	else 'Middle age'
	end as Age_category
from customer;


/*Creating sales table of year 2015*/

Create table sales_2015 as select * from sales where ship_date between '2015-01-01' and '2015-12-31';
select count(*) from sales_2015; --2131
select count(distinct customer_id) from sales_2015;--578

/* Customers with age between 20 and 60 */
create table customer_20_60 as select * from customer where age between 20 and 60;
select count (*) from customer_20_60;--597

select * from customer;

select * from sales_2015;

/*Inner join*/
select 
	a.order_line,
	a.product_id,
	a.customer_id,
	a.order_id,
	a.order_date
from sales_2015 a
inner join customer_20_60 as b
on a.customer_id = b.customer_id 
order by customer_id;


select 
	a.order_line,
	a.product_id,
	a.customer_id,
	a.order_id,
	a.order_date
from sales_2015 a
inner join customer_20_60 as b
on a.customer_id = b.customer_id 
order by customer_id;


/*Left outer*/

select a.order_line,
	a.product_id,
	a.customer_id,
	b.customer_name,
	b.age
	from sales_2015 as a 
left join customer_20_60 as b
on a.customer_id=b.customer_id 
order by customer_id;

/*Right join*/

select a.order_line,
	a.product_id,
	b.customer_id,
	b.customer_name,
	a.sales,
	b.age
	from sales_2015 as a 
right join customer_20_60 as b
on a.customer_id=b.customer_id 
order by customer_id;


select a.order_line,
	a.product_id,
	a.product_id,
	a.sales,
	b.customer_name,
	b.age,
	b.customer_id
from sales_2015 as a
full join customer_20_60 as b
on a.customer_id = b.customer_id
order by a.customer_id,b.customer_id;


/*Except*/

select customer_id from sales except select customer_id from customer_20_60 
order by customer_id;

/*Union*/
select customer_id from sales_2015
union 
select customer_id from customer_20_60 
order by customer_id;


select * from customer_20_60;
select * from sales_2015;

select 
	b.state,
	sum(sales) as total_sales
	from sales_2015 as a
left join customer_20_60 as b
on a.customer_id=b.customer_id 
group by b.state;

select p.product_id,
	p.product_name,
	p.category,
	sum(sales) as total_sales,
	sum(quantity) as total_quantity
from product as p
left join sales as s 
on p.product_id = s.product_id
group by p.product_id;


/*Sub queries*/

select * from sales where customer_id in(
select distinct customer_id from customer where age>60);


select
	a.product_id,
	a.product_name,
	a.category,
	b.quantity
from product as a
left join (select product_id, sum(quantity) as quantity from sales group by product_id) as b
on a.product_id = b.product_id order by b.quantity DESC;


select c.customer_name,c.age,sp.*
from customer as c 
right join(
select s.*,p.product_name,p.category from sales s left join product as p on s.product_id = p. product_id) as sp
on c.customer_id = sp.customer_id;


create view logistics as 
select a.order_line, a.order_id, b.customer_name, b.city, b.state, b.country
from sales a left join
customer b on
a.customer_id = b.customer_id
order by a.order_line;

select * from logistics;

select customer_name, length(customer_name) as cust_length
from customer where age>30;

select product_name ,max(length(product_name)) from product group by product_name;
select max(length(product_name)) from product ;

select product_name, sub_category, category,(product_name||','||sub_category||','||category) as product_details from product;

select * from product;

select product_id, substring(product_id for 3) as prod, substring(product_id from 5 for 2) as prod1, substring(product_id from 8 for 8) from product;

select current_timestamp, extract(hour from current_timestamp);

	



************************ Assignment **********************************

drop table bank_accounts;
create table Bank_Accounts(
"Date" date,
Weekday varchar,
Amount varchar,
AccType varchar,
OpenedBy varchar,
Branch varchar,
Customer varchar);

copy Bank_Accounts from 
'C:\Program Files\PostgreSQL\10\data\Data_copy\original.csv' delimiter ',' csv header;

select * from Bank_Accounts;
select to_number(amount,'999999.99') from Bank_Accounts;

select Date, sum(to_number(amount,'999999.99'))as total_sum, branch from Bank_Accounts group by "Date",branch;

select customer from Bank_Accounts where customer ='New';

/*Question 1*/
select "Date", sum(to_number(amount,'999999.99'))as total_sum, branch, customer
from Bank_Accounts 
where customer='New'
group by "Date",branch,customer;

********Divya**********
select "Date", SUM(TO_NUMBER(amount, '9999999.99')) as total_deposit_amt, Branch
from Bank_Account
group by "Date", Branch
order by "Date" desc;

/*Question 2*/
select * from Bank_Accounts;
select distinct weekday from Bank_Accounts;

select weekday, sum(to_number(amount,'99999.99')) as total_deposits
from Bank_Accounts
group by weekday;

select weekday,sum(to_number(amount,'99999.99')) as total_deposits
from Bank_Accounts
group by weekday order by total_deposits desc limit 1;

select a.weekday,sum(to_number(amount,'99999.99')) as total_depostis from Bank_Accounts  where total_deposits<
(select sum(to_number(amount,'99999.99')) from Bank_Accounts ); 

select bd.weekday, max(bd.total_deposit)
from (select weekday, sum(to_number(amount,'99999.99')) as total_deposit from Bank_Accounts
group by weekday) as bd
group by bd.weekday;


select a.total_deposits from (select weekday,sum(to_number(amount,'99999.99')) as total_deposits 
			  from Bank_Accounts group by weekday) as a
			  having a.total_deposits=max(a.total_deposits);


select max(a.total_deposits) as total from (
select b.weekday,sum(to_number(amount,'99999.99')) as total_deposits from Bank_Accounts b group by b.weekday ) as a;

select weekday, max(total_deposits) as total from (
select weekday,sum(to_number(amount,'99999.99')) as total_deposits from Bank_Accounts group by weekday ) as a group by weekday;

select weekday,

select distinct top 1 
select weekday
/*Question 3*/

select * from Bank_Accounts;
Select distinct acctype from Bank_Accounts;

select acctype,count(acctype) as Number_of_accounts, branch from Bank_Accounts 
group by acctype,branch
order by Number_of_accounts desc;


/*Question 4*/
select * from Bank_Accounts;

select acctype,sum(to_number(amount,'99999.99')) as total_amount from Bank_Accounts 
group by acctype 
order by total_amount desc;

/*Question 5*/
select * from Bank_Accounts;

select acctype,count(openedby) as Total_accounts_opened from Bank_Accounts
where openedby='Teller'
group by acctype 
order by Total_accounts_opened desc limit 1;

/*Question 6*/
select * from Bank_Accounts;

select acctype,branch,count(openedby) as Total_accounts_opened from Bank_Accounts
where openedby='Teller' and customer='New'
group by acctype,branch 
order by Total_accounts_opened desc limit 1;

