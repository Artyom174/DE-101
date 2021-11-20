drop schema if exists model cascade;

create schema if not exists model;

-- ************************************** customers
drop table if exists model.customers;
create table model.customers
(
 cust_id       serial not null,
 customer_id   varchar(50) not null,
 customer_name varchar(100) not null,
 constraint PK_96 primary key (cust_id)
);
--deleting rows
truncate table model.customers;
--inserting
insert into model.customers 
select 
100+row_number() over(),
customer_id, 
customer_name
from (select
	distinct customer_id, customer_name
			from public.orders) a;
--checking
select * 
from model.customers cd;  



-- ************************************** geography
drop table if exists model.geography;
create table model.geography
(
 geo_id      serial not null,
 country     varchar(50) not null,
 region      varchar(50) not null,
 state       varchar(100) not null,
 city        varchar(100) not null,
 postal_code integer  null,
 constraint PK_36 PRIMARY key (geo_id)
);

--deleting rows
truncate table model.geography;
--generating geo_id and inserting rows from orders
insert into model.geography 
select
100+row_number() over(),
country,
region,
state,
city,
postal_code
	from (select
		distinct country,region, state, city, postal_code 
				from public.orders ) a;

--update null value
update model.geography
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;

--also update source file
update public.orders
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;

--data quality check
select * 
from model.geography;

-- ************************************** calendar

drop table if exists model.calendar cascade;
create table model.calendar
(
date_id 	serial  not null,
year        int not null,
quarter     int not null,
month       int not null,
week        int not null,
date        date not null,
week_day    varchar(20) not null,
leap  varchar(20) not null,
constraint PK_calendar primary key (date_id)
);

--deleting rows
truncate table model.calendar;
--
insert into model.calendar 
select 
to_char(date,'yyyymmdd')::int as date_id,  
       extract('year' from date)::int as year,
       extract('quarter' from date)::int as quarter,
       extract('month' from date)::int as month,
       extract('week' from date)::int as week,
       date::date,
       to_char(date, 'dy') as week_day,
       extract('day' from
               (date + interval '2 month - 1 day')
              ) = 29
       as leap
  from generate_series(date '2000-01-01',
                       date '2030-01-01',
                       interval '1 day')
       as t(date);
--checking
select * 
from model.calendar; 

-- ************************************** shipment
--creating a table
drop table if exists model.shipment cascade;
create table model.shipment
(
 ship_id   serial not null,
 ship_mode varchar(50) not null,
 constraint PK_80 primary key (ship_id)
);

--deleting rows
truncate table model.shipment;

--generating ship_id and inserting ship_mode from orders
insert into model.shipment 
select
100+row_number() over(),
ship_mode
from (select
	  distinct ship_mode
	  from public.orders) a;
	 
select * 
from model.shipment;


-- ************************************** products
drop table if exists model.products cascade;
create table model.products
(
 prod_id      serial not null, 
 product_id   varchar(50) not null,  
 product_name varchar(250) not null,
 category     varchar(50) not null,
 sub_category varchar(50) not null,
 segment      varchar(50) not null,
 constraint PK_87 primary key (prod_id)
 );
 
 --deleting rows
truncate table model.products;
--
insert into model.products
select 
100+row_number() over (),
product_id,
product_name,
category,
subcategory,
segment
from (select
	distinct product_id,
			 product_name,
			 category,
			 subcategory,
			 segment
		from public.orders ) a;
--checking
select * 
from model.products cd; 



-- ************************************** sales_fact
drop table if exists model.sales_fact cascade;
create table model.sales_fact
(
 sales_id	 serial not null,
 cust_id 	 serial not null,
 date_id integer not null,
 ship_date_id integer not null,
 prod_id  	 serial not null,
 ship_id     serial not null,
 geo_id      serial not null,
 order_id    varchar(25) not null,
 sales       numeric not null,
 quantity    integer not null,
 profit      numeric(4,2) not null,
 discount    numeric not null,
 constraint PK_17 primary key (sales_id),
 constraint FK_99 foreign key (cust_id) references model.customers (cust_id),
 constraint FK_20 foreign key (date_id) references model.calendar (date_id),
 constraint FK_75 foreign key (geo_id) references model.geography (geo_id),
 constraint FK_82 foreign key (ship_id) references model.shipment (ship_id),
 constraint FK_91 foreign key (prod_id) references model.products (prod_id)
);


create index fkIdx_101 on model.sales_fact
(
 cust_id
);

create index fkIdx_22 on model.sales_fact
(
 date_id
);


create index fkIdx_77 on model.sales_fact
(
 geo_id
);

create index fkIdx_84 on model.sales_fact
(
 ship_id
);

create index fkIdx_93 on model.sales_fact
(
 prod_id
);



insert into model.sales_fact 
select
	 100+row_number() over() as sales_id
	 ,cust_id
	 ,to_char(order_date,'yyyymmdd')::int as  order_date_id
	 ,to_char(ship_date,'yyyymmdd')::int as  ship_date_id
	 ,p.prod_id
	 ,s.ship_id
	 ,geo_id
	 ,o.order_id
	 ,sales
	 ,profit
     ,quantity
	 ,discount
from public.orders o

inner join model.customers c 
on o.customer_name = c.customer_name and o.customer_id = c.customer_id
inner join model.shipment s 
on o.ship_mode  = s.ship_mode
inner join model.products p 
on o.category = p.category and o.subcategory = p.sub_category and o.product_name = p.product_name and o.product_id = p.product_id  and o.segment = p.segment
inner join model.geography g 
on g.country = o.country and o.city = g.city and o.state = g.state and o.postal_code = g.postal_code and o.region = g.region;

--do you get 9994rows?
select * from model.sales_fact sf
inner join model.shipment s on sf.ship_id=s.ship_id
inner join model.geography g on sf.geo_id=g.geo_id
inner join model.products p on sf.prod_id=p.prod_id
inner join model.customers cd on sf.cust_id=cd.cust_id;
