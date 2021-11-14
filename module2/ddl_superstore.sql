drop schema if exists model cascade;

create schema if not exists model;

-- ************************************** customers

CREATE TABLE model.customers
(
 customer_id   varchar(50) NOT NULL,
 segment       varchar(50) NOT NULL,
 customer_name varchar(100) NOT NULL,
 CONSTRAINT PK_96 PRIMARY KEY ( customer_id )
);

-- ************************************** geography

CREATE TABLE model.geography
(
 geo_id      serial NOT NULL,
 country     varchar(50) NOT NULL,
 region      varchar(50) NOT NULL,
 "state"       varchar(100) NOT NULL,
 city        varchar(100) NOT NULL,
 postal_code serial NOT NULL,
 CONSTRAINT PK_36 PRIMARY KEY ( geo_id )
);


-- ************************************** order_calendar

CREATE TABLE model.order_calendar
(
 order_date date NOT NULL,
 year       serial NOT NULL,
 quarter    serial NOT NULL,
 month      serial NOT NULL,
 week_day   serial NOT NULL,
 day        serial NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( order_date )
);

-- ************************************** ship_calendar

CREATE TABLE model.ship_calendar
(
 ship_date date NOT NULL,
 year      serial NOT NULL,
 quarter   serial NOT NULL,
 month     serial NOT NULL,
 week_day  serial NOT NULL,
 day       serial NOT NULL,
 CONSTRAINT PK_6 PRIMARY KEY ( ship_date )
);

-- ************************************** shipment

CREATE TABLE model.shipment
(
 ship_id   serial NOT NULL,
 ship_mode varchar(50) NOT NULL,
 CONSTRAINT PK_80 PRIMARY KEY ( ship_id )
);


-- ************************************** products

CREATE TABLE model.products
(
 product_id   varchar(50) NOT NULL,
 category     varchar(50) NOT NULL,
 sub_category varchar(50) NOT NULL,
 product_name varchar(100) NOT NULL,
 CONSTRAINT PK_87 PRIMARY KEY ( product_id )
);

-- ************************************** sales_fact

CREATE TABLE model.sales_fact
(
 order_date  date NOT NULL,
 geo_id      serial NOT NULL,
 ship_date   date NOT NULL,
 ship_id     serial NOT NULL,
 product_id  varchar(50) NOT NULL,
 customer_id varchar(50) NOT NULL,
 sales       numeric NOT NULL,
 discount    numeric NOT NULL,
 quantity    integer NOT NULL,
 profit      numeric NOT NULL,
 order_id    varchar(50) NOT NULL,
 row_id      integer NOT NULL,
 CONSTRAINT PK_17 PRIMARY KEY ( row_id ),
 CONSTRAINT FK_99 FOREIGN KEY ( customer_id ) REFERENCES model.customers ( customer_id ),
 CONSTRAINT FK_20 FOREIGN KEY ( order_date ) REFERENCES model.order_calendar ( order_date ),
 CONSTRAINT FK_31 FOREIGN KEY ( ship_date ) REFERENCES model.ship_calendar ( ship_date ),
 CONSTRAINT FK_75 FOREIGN KEY ( geo_id ) REFERENCES model.geography ( geo_id ),
 CONSTRAINT FK_82 FOREIGN KEY ( ship_id ) REFERENCES model.shipment ( ship_id ),
 CONSTRAINT FK_91 FOREIGN KEY ( product_id ) REFERENCES model.products ( product_id )
);

CREATE INDEX fkIdx_101 ON model.sales_fact
(
 customer_id
);

CREATE INDEX fkIdx_22 ON model.sales_fact
(
 order_date
);

CREATE INDEX fkIdx_33 ON model.sales_fact
(
 ship_date
);

CREATE INDEX fkIdx_77 ON model.sales_fact
(
 geo_id
);

CREATE INDEX fkIdx_84 ON model.sales_fact
(
 ship_id
);

CREATE INDEX fkIdx_93 ON model.sales_fact
(
 product_id
);

