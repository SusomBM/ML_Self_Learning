create database market_star_schema;

use market_star_schema;

create table shipping_mode_dimen
(Ship_Mode varchar(25),
Vehicke_Company varchar(25),
Toll_Required Boolean
);

alter table shipping_mode_dimen add constraint primary key (Ship_Mode);

DESC shipping_mode_dimen;
SHOW CREATE TABLE shipping_mode_dimen;

insert into shipping_mode_dimen (Ship_Mode,Vehicke_Company,Toll_Required)
values ('DELIVERY TRUCK', 'Ashok Leyland', 0),
('REGULAR AIR', 'Air India', 0);

select * from shipping_mode_dimen;

-- changing the column name and type
alter table shipping_mode_dimen change Vehicke_Company Vehicle_Company varchar(30); 

drop table shipping_mode_dimen;

-- If we want to find all names that start with 'J', have any one character in the second position, and then 'n' as the third letter, we can use _ as follows

-- limit 3 at the end of a query will limit the displayed records to 3

SELECT * FROM employees WHERE name REGEXP '^J';       -- Matches any string that starts with "J" any case
SELECT * FROM employees WHERE name REGEXP 'n$';       -- Matches names ending with "n" , any case.
SELECT * FROM employees WHERE name REGEXP 'a|e';      -- Matches any name containing either "a" or "e"
SELECT * FROM employees WHERE name REGEXP '^.{5}$';   -- Matches names with exactly 5 characters (any character . repeated {5} times)
SELECT * FROM orders WHERE order_code REGEXP '[0-9]'; -- Matches any row where order_code contains a number
SELECT * FROM employees WHERE name REGEXP 'abc';      -- Matches any name containing either "abc" string
SELECT * FROM employees WHERE name REGEXP '^[abc].*n$' --  Matches any string that starts with either 'a', or 'b' or 'c' and ends with 'n' 
-- ^<character1> begin with  <character1>
-- [<character1><character2>] any character <character1> or <character2> in square bracket
-- <character1>$ ends with <character1>
-- .* any character repets any number of times
