drop schema if exists model cascade;

create schema if not exists model;

-- ************************************** customers
drop table if exists model.customers cascade;
create table model.customers
(
 customer_id   varchar(50) not null,
 segment       varchar(50) not null,
 customer_name varchar(100) not null,
 constraint PK_96 primary key (customer_id)
);

-- ************************************** geography
drop table if exists model.geography cascade;
create table model.geography
(
 geo_id      serial not null,
 country     varchar(50) not null,
 region      varchar(50) not null,
 "state"       varchar(100) not null,
 city        varchar(100) not null,
 postal_code serial not null,
 CONSTRAINT PK_36 PRIMARY KEY (geo_id)
);


-- ************************************** order_calendar
drop table if exists model.order_calendar cascade;
create table model.order_calendar
(
 order_date date not null,
 year       serial not null,
 quarter    serial not null,
 month      serial not null,
 week_day   serial not null,
 day        serial not null,
 constraint PK_5 primary key (order_date)
);
--deleting rows
truncate table model.order_calendar;
--
insert into model.order_calendar 
select 
distinct order_date,
date_part('year' , order_date) as year,
date_part('quarter' , order_date) as quarter,
date_part('month' , order_date) as month,
extract(isodow from order_date) as week_day,
date_part('day' , order_date) as day
from public.orders
order by order_date;


-- ************************************** ship_calendar
--creating a table
drop table if exists model.ship_calendar cascade;
create table model.ship_calendar
(
 ship_date date not null,
 year      serial not null,
 quarter   serial not null,
 month     serial not null,
 week_day  serial not null,
 day       serial not null,
 constraint PK_6 primary key (ship_date)
);

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
select * from model.shipment

create table model.products
(
 product_id   varchar(50) not null,
 category     varchar(50) not null,
 sub_category varchar(50) not null,
 product_name varchar(100) not null,
 constraint PK_87 primary key (product_id)
);

-- ************************************** sales_fact

create table model.sales_fact
(
 order_date  date not null,
 geo_id      serial not null,
 ship_date   date not null,
 ship_id     serial not null,
 product_id  varchar(50) not null,
 customer_id varchar(50) not null,
 sales       numeric not null,
 discount    numeric not null,
 quantity    integer not null,
 profit      numeric not null,
 order_id    varchar(50) not null,
 row_id      integer not null,
 constraint PK_17 primary key (row_id),
 constraint FK_99 foreign key (customer_id) references model.customers (customer_id),
 constraint FK_20 foreign key (order_date) references model.order_calendar (order_date),
 constraint FK_31 foreign key (ship_date) references model.ship_calendar (ship_date),
 constraint FK_75 foreign key (geo_id) references model.geography (geo_id),
 constraint FK_82 foreign key (ship_id) references model.shipment (ship_id),
 constraint FK_91 foreign key (product_id) references model.products (product_id)
);

create index fkIdx_101 on model.sales_fact
(
 customer_id
);

create index fkIdx_22 on model.sales_fact
(
 order_date
);

create index fkIdx_33 on model.sales_fact
(
 ship_date
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
 product_id
);

