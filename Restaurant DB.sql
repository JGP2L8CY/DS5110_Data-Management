CREATE SCHEMA restaurant;
USE restaurant;
CREATE TABLE reservation(
	reservation_id int PRIMARY KEY,
	reservation_date date,
	reservation_time TIME,
	party_size int check(party_size < 20)
    );
    
CREATE TABLE tables_(
	table_id int PRIMARY KEY default 0,
	total_seats int check(total_seats < 8),
	table_status varchar(20)
    );

create table reserve_table(
		reservation_id int, 
		table_id int,
        primary key (reservation_id, table_id),
        foreign key (reservation_id) references reservation (reservation_id),
		foreign key (table_id) references tables_ (table_id) 
        );

create table customer(
		customer_id int, 
        name varchar(20) not null, 
		phone varchar(20), 
        email varchar(50),
        primary key (customer_id) 
        );

create table makes(
		customer_id int, 
        reservation_id int,
        primary key (customer_id, reservation_id),
        foreign key (customer_id) references customer (customer_id),
        foreign key (reservation_id) references reservation (reservation_id)
        );

create table order_meta(
	order_id int,
	order_date date,
	order_time TIME,
	order_status varchar(30), 
	table_id int default 0,
	dine_in varchar(20),
	primary key (order_id),
    foreign key (table_id) references tables_ (table_id)
        );

create table places(
		customer_id int, 
        order_id int, 
        primary key (customer_id, order_id),
        foreign key (customer_id) references customer (customer_id),
        foreign key (order_id) references order_meta (order_id) 
        ); 
	
CREATE TABLE manager(
	manager_id int PRIMARY KEY,
	first_name varchar(20) not null,
	last_name varchar(20) not null,
	phone varchar(20),
	email varchar(50),
	message varchar(50)
    );

CREATE TABLE chef(
	chef_id int PRIMARY KEY,
	first_name varchar(20) not null,
    	last_name varchar(20) not null,
    	phone varchar(20),
    	email varchar(50),
	manager_id int,
	foreign key (manager_id) references manager (manager_id)
    );
    
create table views( 
		order_id int, 
        chef_id int,
        primary key (order_id, chef_id),
        foreign key (order_id) references order_meta (order_id),
        foreign key (chef_id) references chef (chef_id)
        ); 
        
Create table order_detail( 
	order_id int, 
	item_id int, 
	item_name varchar(50), 
	quantity int,
    	total float,
	Primary key (order_id, item_id)
    );

Create table menu( 
	item_id int, 
	menu_type varchar(20), 
	item_name varchar(50), 
	dietary_notes varchar(50), 
	price int,
	primary key (item_id)
	);

Create table ingredient( 
	item_id int,
	ingredient_id varchar(30), 
	ingredient_name varchar(30),
	count_package int,
	package_type varchar(20),
    	primary key (ingredient_id), 
	foreign key (item_id) references menu(item_id)
    );

Create table menu_inventory(
	item_id int, 
	ingredient_id varchar(30), 
	foreign key (item_id) references menu(item_id),
	foreign key (ingredient_id) references ingredient (ingredient_id)
    );

CREATE TABLE waiter(
	waiter_id int PRIMARY KEY,
	first_name varchar(20) not null,
    	last_name varchar(20) not null,
    	phone varchar(20),
    	email varchar(50),
	manager_id int,
	foreign key (manager_id) references manager (manager_id)
    );

CREATE TABLE assists(
	waiter_id int,
	reservation_id int,
	PRIMARY KEY(waiter_id, reservation_id),
	FOREIGN KEY(waiter_id) references waiter(waiter_id),
	FOREIGN KEY(reservation_id) references Reservation(reservation_id)
    );
    

-- FINAL EXECUTED VERSION

INSERT INTO reservation(reservation_id, reservation_date, reservation_time, party_size)
VALUES (6061112, '2022-09-27', '19:00', 7),
(6061121, '2022-10-01', '18:00', 2),
(6061211, '2022-10-03', '21:00', 3),
(6062111, '2022-10-06', '19:00', 5),
(6062211, '2022-10-11', '20:00',4),
(6062231, '2022-10-12', '12:00', 5),
(6062233, '2022-11-01', '14:00',8),
(6062243, '2022-11-01', '18:00',10),
(6062244, '2022-11-01', '19:00',3),
(6062434, '2022-11-01', '20:00',6);

# tables_
	# table_id, total_setas, table_status
INSERT INTO tables_(table_id, total_seats, table_status)
VALUES (1, 2, 'open'),
(2,2, 'open'),
(3,4,'open'),
(4,4, 'open'),
(5,4, 'open'),
(6,4,'open'),
(7,7,'open'),
(8,7,'open'),
(9,7, 'open'),
(10, 2, 'open'),
(0,0,'online');

# reserve_table
	# reservation_id, table_id
Insert into reserve_table(reservation_id, table_id)
values(6061112,1),
(6061121,2),
(6061211,3),
(6062111,4),
(6062211,5),
(6062231,6),
(6062233,7),
(6062243,8),
(6062244,9),
(6062434,10);

# customer
	# customer_id, name, phone, email
insert into customer values (2071234, 'Samuel', '(555) 554-1234', 'samuela@northeastern.edu');
insert into customer values (2074242, 'Patricia', '(423) 124-1544', 'patriciak@northeastern.edu');
insert into customer values (2072482, 'Bailey', '(456) 542-1634', 'baileyl@northeastern.edu');
insert into customer values (2072923, 'Wanda', '(123) 355-1634', 'wandar@northeastern.edu');
insert into customer values (2074813, 'David', '(775) 666-9834', 'davidg@northeastern.edu');
insert into customer values (2071938, 'Grant', '(126) 019-0836', 'granto@northeastern.edu');
insert into customer values (2071111, 'Sarah', '(864) 928-8534', 'sarahy@northeastern.edu');
insert into customer values (2073333, 'May', '(019) 492-6234', 'mayp@northeastern.edu');
insert into customer values (2075555, 'Kim', '(294) 292-1545', 'kimk@northeastern.edu');
insert into customer values (2079999, 'Robby', '(495) 135-3933', 'robbyg@northeastern.edu');

# makes
	# customer_id, reservation_id
insert into makes values (2071234, 6061112);
insert into makes values (2074242, 6061121);
insert into makes values (2072482, 6061211);
insert into makes values (2072923, 6062111);
insert into makes values (2074813, 6062211);
insert into makes values (2071938, 6062231);
insert into makes values (2071111, 6062233);
insert into makes values (2073333, 6062243);
insert into makes values (2075555, 6062244);
insert into makes values (2079999, 6062434);


insert into order_meta values (3061234,'2022-09-27','19:00' ,'served', 1, 'yes' );
insert into order_meta values (3063938,'2022-10-01','18:00', 'served', 2, 'yes');
insert into order_meta values (3063844, '2022-10-03', '21:00', 'served', 3, 'yes');
insert into order_meta values (3060000,'2022-10-06','19:00',   'served', 5, 'yes' );
insert into order_meta values (3069999,'2022-10-11','20:00', 'served', 6, 'yes' );
insert into order_meta values (3062022,'2022-10-12', '12:00', 'served', 2, 'yes' );
insert into order_meta values (3067777, '2022-11-01','14:00', 'served', 3, 'yes' );
insert into order_meta values (3062633,'2022-11-01','18:00', 'served', 5, 'yes' );
insert into order_meta values (3064444,'2022-11-01', '19:00', 'cooking', 6, 'yes' );
insert into order_meta values (3061769,'2022-11-01','20:00', 'cooking', 7, 'yes' );

-- places
-- customer_id, order_id
insert into places values (2071234, 3061234);
insert into places values (2074242, 3063938);
insert into places values (2072482, 3063844);
insert into places values (2072923, 3060000);
insert into places values (2074813, 3069999);
insert into places values (2071938, 3062022);
insert into places values (2071111, 3067777);
insert into places values (2073333, 3062633);
insert into places values (2075555, 3064444);
insert into places values (2079999, 3061769);

# manager
	# manager_id, name
INSERT INTO manager(manager_id, first_name, last_name, phone, email, message)
VALUES (3031112, 'John', 'Smith', '(555) 125-5587', 'jsmith@northeastern.edu',''),
(3031121, 'Adele', 'Puckett','(858) 123-5679','apuckett@northeastern.edu',''),
(3031211, 'Shirley', 'Khan', '(760) 133-5677', 'skhan@northeastern.edu',''),
(3032111, 'Aaron', 'Lee', '(615) 143-5676', 'alee@northeastern.edu',''),
(3032211, 'Stanley', 'Price', '(843) 183-5675', 'sprice@northeastern.edu',''),
(3032231, 'Amber', 'Brooks', '(555) 129-5674', 'abrooks@northeastern.edu',''),
(3032233, 'Connell', 'Johnson', '(843) 173-5673', 'cjohnson@northeastern.edu',''),
(3032243, 'Kayla', 'Jenkins', '(715) 127-5672', 'kjenkins@northeastern.edu',''),
(3032244, 'Isabella', 'Chan', '(860) 123-5671', 'ichan@northeastern.edu',''),
(3032434, 'James', 'Galloway', '(732) 578-5558', 'jgalloway@northeastern.edu','');

# chef
	# id, name
INSERT INTO chef(chef_id,first_name, last_name, phone, email, manager_id)
VALUES (4041112, 'Chris', 'Ratt', '(732) 583-5558', 'cratt@gmail.com',3031112),
(4041121, 'Gordon', 'Ramsey', '(860) 145-5671', 'gramsey@gmail.com', 3031121),
(4041211, 'Guy', 'Fieri','(715) 174-5672', 'gfieri@gmail.com', 3031121),
(4042111, 'Martha', 'Stewart','(843) 734-5673', 'mstewart@gmail.com', 3032231),
(4042211, 'Rachel', 'Ray', '(575) 129-5474', 'rray@gmail.com', 3032233),
(4042231, 'Julia', 'Child', '(843) 144-5675', 'jchild@gmail.com', 3032244),
(4042233, 'Anthony', 'Bourdain', '(615) 637-5676', 'abourdain@gmail.com', 3032244),
(4042243, 'David', 'Chang','(767) 193-5677', 'dchang@gmail.com', 3032244),
(4042244, 'Mario', 'Batali','(858) 553-5679', 'mbatali@gmail.com', 3032243),
(4042434, 'Bobby', 'Flay','(585) 195-5587', 'bflay@gmail.com', 3031112);

# views
	# order_id, chef_id 
insert into views values (3061234,4041112);
insert into views values (3063938,4041121);
insert into views values (3063844,4041211);
insert into views values (3060000,4042111);
insert into views values (3069999,4042211);
insert into views values (3062022,4042231);
insert into views values (3067777,4042233);
insert into views values (3062633,4042243);
insert into views values (3062633,4042244);
insert into views values (3061769,4042434);

#order detail
Insert into order_detail(order_ID, item_ID, item_name, quantity, total)
Values (3061234, 123, 'Bacon egg and cheese', 2, 9.98),
 (3063938, 126, 'Bagel with cream cheese', 3, 5.97),
(3063844, 133, 'Pasta', 2, 17.98),
(3060000, 142, 'Apple crisp', 1, 8.99),
(3069999, 131, 'Chicken Sandwich', 2, 15.98),
(3062022, 125, 'Vegan breakfast sandwich', 1, 4.99),
(3067777, 134, 'Lasagne', 5, 44.95),
(3062633, 143, 'Cheesecake', 3, 23.97),
(3064444, 132, 'Meatball parm', 4, 31.96),
(3061768, 124, 'Stuffed mushrooms', 2, 17.98);

#menu
Insert into menu(item_ID, menu_type, item_name, dietary_notes, price)
values(123, 'Breakfast', 'Bacon egg and cheese', 'dairy', 4.99),
(124, 'Breakfast', 'Sausage egg and cheese', 'dairy', 4.99),
(125, 'Breakfast', 'vegan breakfast sandwich', 'vegan', 4.99),
(126, 'Breakfast', 'Bagel with cream cheese', 'dairy', 1.99),
(131, 'Lunch', 'Chicken Sandwich', 'meat', 7.99),
(132, 'Lunch', 'Meatball parm', 'meat', 7.99),
(133, 'Lunch', 'Pasta', 'veg', 8.99),
(134, 'Lunch', 'Lasagne', 'meat', 8.99),
(141, 'Dessert', 'Brownie with ice cream', 'dairy', 10.99),
(142, 'Dessert', 'Apple crisp', 'gluten', 8.99),
(143, 'Dessert', 'Cheesecake', 'gluten', 7.99),
(144, 'Dessert', 'Triple berry pie', 'gluten', 7.99),
(151, 'Dinner', 'Stuffed Mushrooms', 'dairy', 8.99),
(152, 'Dinner', 'Steak', 'meat', 21.99),
(153, 'Dinner', 'Pork ribs', 'meat', 20.99),
(154, 'Dinner', 'Chicken breast with potato mash', 'meat', 15.99);

#ingredient
Insert into ingredient( ingredient_ID, ingredient_name, count_package, package_type)
values('B11', 'Bacon', 5 ,'Box'),
('B12', 'Sausage', 4 ,'Box'),
('B13', 'Egg', 6 ,'Box'),
('B14', 'Cheese', 8 ,'Box'),
('B15', 'Plain Bagel', 4 ,'Box'),
('B16', 'Sesame Bagel', 4 ,'Box'),
('B17', 'Subroll', 10 ,'Box'),
('B18', 'Vegan bread', 2 ,'Box'),
('B19', 'Vegan cheese', 3 ,'Box'),
('B20', 'Vegan egg', 2 ,'Box'),
('B21', 'vegan patty', 3 ,'Box'),
('B22', 'cream cheese', 4 ,'Box'),
('L11', 'chicken breast', 5 ,'Box'),
('L12', 'meatball marinara', 4 ,'Box'),
('L13', 'boiled pasta', 4 ,'Box'),
('L14', 'Pasta sheets', 3 ,'Box'),
('L15', 'Pasta sauce', 4 ,'Box'),
('L16', 'Mixed Veggies', 4 ,'Box'),
('L17', 'Shredded Cheese', 6 ,'Box'),
('L18', 'Sliced chicken', 6 ,'Box'),
('D11', 'Brownie', 4 ,'Box'),
('D12', 'Vanilla ice cream', 3 ,'Box'),
('D13', 'Apple slices', 5 ,'Box'),
('D14', 'Cheesecake slices', 8 ,'Box'),
('D15', 'Triple berry mix', 5 ,'Box'),
('D16', 'Pie base', 3 ,'Box'),
('DI11', 'Mushroom stuffing', 6 ,'Packet'),
('DI12', 'Mushroom', 4 ,'Box'),
('DI13', 'Sauce base', 5 ,'Box'),
('DI14', 'Steak', 8 ,'Packet'),
('DI15', 'Pork', 7 ,'Packet'),
('DI16', 'Potato', 10 ,'Bag'),
('DI17', 'Rice', 5 ,'Bag');

# waiter
	# id, name
INSERT INTO waiter(waiter_id, first_name, last_name, phone, email , manager_id)
VALUES (5051112, 'Ivana', 'Jones','(737) 583-5758', 'ijones@northeastern.edu', 3031121),
(5051121, 'Liza', 'Templeton','(869) 195-5671', 'ltempleton@northeastern.edu', 3031112),
(5051211, 'Carmen', 'Cresto','(713) 184-5672', 'ccresto@northeastern.edu', 3032233),
(5052111, 'Brandon', 'Joe','(848) 794-5673', 'bjoe@northeastern.edu', 3032233),
(5052211, 'Julien', 'Porto','(505) 120-5474', 'jporto@northeastern.edu', 3032111),
(5052231, 'Michael', 'Carpenter', '(873) 044-5075', 'mcarpenter@northeastern.edu', 3032231),
(5052233,  'Gary', 'Atwater','(610) 633-5676', 'gatwater@northeastern.edu', 3032434),
(5052243, 'Lewis', 'Briggs','(747) 143-5677', 'lbriggs@northeastern.edu', 3032111),
(5052244, 'Anton', 'Jarvis', '(958) 593-5679', 'ajarvis@northeastern.edu', 3032231),
(5052434, 'Damien','Harris','(503) 193-5587', 'dharris@northeastern.edu', 3032244);

# assists
	# waiter_id, reservation_id
INSERT INTO assists(waiter_id, reservation_id)
Values (5051112,6061112),
(5051121, 6061121),
(5051211, 6061211),
(5052111,6062111),
(5052211,6062211),
(5052231,6062231),
(5052233,6062233),
(5052243,6062243),
(5052244,6062244),
(5052434, 6062434);


#menu inventory
Insert into menu_inventory( item_ID, ingredient_ID)
values(123, 'B11'),
(123, 'B13'),
(123, 'B14'),
(123, 'B15'),
(124, 'B12'),
(124, 'B13'),
(124, 'B14'),
(124, 'B15'),
(125, 'B18'),
(126, 'B15'),
(126, 'B22'),
(131, 'B17'),
(131, 'L11'),
(131, 'L16'),
(131, 'L17'),
(132, 'L12'),
(132, 'B17'),
(132, 'L17'),
(133, 'L13'),
(133, 'L15'),
(133, 'L17'),
(134, 'L14'),
(134, 'L15'),
(134, 'L18'),
(141, 'D11'),
(141, 'D12'),
(142, 'D13'),
(142, 'D16'),
(142, 'D12'),
(143, 'D14'),
(144, 'D15'),
(144, 'D16'),
(151, 'DI11'),
(151, 'DI12'),
(152, 'DI14'),
(153, 'DI15'),
(154, 'L11'),
(154, 'DI16');

DROP VIEW IF EXISTS chef_order;
CREATE VIEW chef_order AS
SELECT order_meta.order_id, views.chef_id,order_meta.order_date,
order_meta.order_status,order_meta.dine_in,order_detail.item_id, 
order_detail.item_name, order_detail.quantity
FROM views RIGHT OUTER JOIN order_meta ON views.order_id = order_meta.order_id 
INNER JOIN order_detail ON order_detail.order_id = order_meta.order_id;

DROP VIEW IF EXISTS chef_inventory;
CREATE VIEW chef_inventory AS
SELECT menu.item_id,menu.menu_type,menu.item_name,ingredient.ingredient_id, ingredient.ingredient_name,ingredient.count_package, ingredient.package_type
FROM menu INNER JOIN menu_inventory ON menu.item_id = menu_inventory.item_id INNER JOIN ingredient ON menu_inventory.ingredient_id = ingredient.ingredient_id;

-- Customer 
DROP VIEW IF EXISTS show_menu;
create view show_menu as 
	select distinct menu.menu_type, menu.item_name, menu.price
    from menu INNER JOIN menu_inventory ON menu.item_id = menu_inventory.item_id INNER JOIN ingredient ON menu_inventory.ingredient_id = ingredient.ingredient_id
    WHERE menu.item_id NOT IN (SELECT menu.item_id
							FROM menu_inventory m INNER JOIN ingredient i ON m.ingredient_id = i.ingredient_id
							WHERE i.count_package = 0)
    ORDER BY menu_type DESC; 

DROP VIEW IF EXISTS waiter_view;
CREATE VIEW waiter_view AS
SELECT r.reservation_id,r.reservation_date,r.reservation_time,r.party_size,reserve_table.table_id, tables_.total_seats, tables_.table_status
FROM reservation r INNER JOIN reserve_table ON r.reservation_id = reserve_table.reservation_id 
INNER JOIN tables_ ON tables_.table_id = reserve_table.table_id;

DROP PROCEDURE IF EXISTS store_order_meta;
delimiter $$
CREATE PROCEDURE store_order_meta(in order_id int, in order_date date, in order_time TIME, in order_status varchar(20), in table_id int, in dine_delivery varchar(20))
BEGIN
	INSERT INTO order_meta(order_id,order_date, order_time, order_status, table_id, dine_in)
	VALUES (order_id,order_date, order_time,order_status, table_id, dine_delivery);
END $$
delimiter ;

DROP PROCEDURE IF EXISTS store_order_detail;
-- store order_detail TESTED
delimiter $$
CREATE PROCEDURE store_order_detail(order_ID int,item_ID int, item_name text, quantity int, total float)
BEGIN 
INSERT INTO order_detail(order_id,item_id, item_name, quantity, total)
VALUES (order_ID, item_ID, item_name,quantity, total);
END $$
delimiter ;


/*Modify ingredient quantity/inventory: TESTED */
DROP PROCEDURE IF EXISTS modify_ing_quantity;
delimiter $$
CREATE PROCEDURE modify_ing_quantity(ingredientid varchar(30), quantity int)
BEGIN 
UPDATE ingredient
SET count_package = quantity 
WHERE ingredient_id = ingredientid;
END $$
delimiter ;

-- Get reservation: TESTED
DROP PROCEDURE IF EXISTS get_reservation01;
delimiter $$
create procedure get_reservation01( 
	    in reservation_id int) 
begin 
    select reservation_id,
    reservation_date, 
	reservation_time, 
	party_size
    from reservation 
    where reservation.reservation_id = reservation_id;
end $$ 
delimiter ; 

-- TESTED
DROP TRIGGER IF EXISTS inventory_empty_message;
delimiter $$
CREATE TRIGGER inventory_empty_message after update on ingredient
FOR EACH ROW
BEGIN
	IF new.count_package = 0 OR NULL THEN
		UPDATE manager
		SET manager.message = 'Empty inventory Alert'
        WHERE manager_id in (3031112,3031121,3031211,3032111,3032211,3032231,3032233,3032243,3032244,3032434) ;
        -- Sets empty inventory alert for all managers, on the business end of things, the alert can go to everyone, and the first person to see it can address it
	END if;
END $$
delimiter ;

-- TESTED
DROP TRIGGER IF EXISTS remove_inventory_message;
delimiter $$
CREATE TRIGGER remove_inventory_message after update on ingredient
FOR EACH ROW
BEGIN
	IF new.count_package > 0 AND old.count_package = 0 THEN
		UPDATE manager
        SET manager.message = ''
        WHERE manager_id in (3031112,3031121,3031211,3032111,3032211,3032231,3032233,3032243,3032244,3032434);
        -- changes empty inventory alert for all managers after inventory has been restored
	END IF;
END $$
delimiter ;

drop function if exists get_sales;
DELIMITER $$;
CREATE FUNCTION get_sales
     ( manager_id_inp INT, 
      week_start_date date)
     RETURNS decimal(7,2)
deterministic
 BEGIN
#Some variables
   DECLARE weekly_sales DECIMAL(7,2); 
   
   with order_manager as (SELECT r.*,m.customer_id,order_id,w.waiter_id,manager_id FROM 
		reservation r
		inner join makes m 
		on r.reservation_id = m.reservation_id
		inner join places p 
		on p.customer_id = m.customer_id
		inner join assists a
		on a.reservation_id = m.reservation_id
		inner join waiter w
		on a.waiter_id = w.waiter_id),
		weekly_sales as (
		select manager_id,week(reservation_date) as week_no,
		round(sum(o.total),2) as total_sales from order_detail o 
		inner join order_manager om 
		on o.order_id = om.order_id 
		where manager_id = manager_id_inp
        and week(reservation_date) = week(week_start_date) AND year(reservation_date) = year(week_start_date)
		group by 1,2)
		select total_sales  into weekly_sales 
		from weekly_sales;

   RETURN weekly_sales;
 END	
 $$;
 
 -- TESTED
 DROP FUNCTION IF EXISTS customer_reservation;
 DELIMITER $$;
CREATE FUNCTION customer_reservation
     ( reservation_id_inp INT)
     RETURNS varchar(30)
     DETERMINISTIC
 BEGIN
#Some variables
   DECLARE customer_reservation_output varchar(30); 

SELECT case when table_status != 'open' or party_size>total_seats then 'Table Reassignment Needed' 
else 'Reservation Successful' end as booking_status into customer_reservation_output
 FROM reserve_table rt
inner join tables_ t 
on rt.table_id = t.table_id
inner join reservation r 
on rt.reservation_id = r.reservation_id
where r.reservation_id = reservation_id_inp;

RETURN customer_reservation_output;
 END	
 $$;

 
/* Create function to get order_total */
-- TESTED
DROP FUNCTION IF EXISTS get_total;
delimiter $$
CREATE FUNCTION get_total(ID int)
RETURNS float
DETERMINISTIC
BEGIN
	DECLARE order_total float;
	SELECT SUM(total) into order_total
FROM order_detail
WHERE order_detail.order_id = ID;
    RETURN order_total;
END $$
delimiter ;

/* Create function to get week total */
-- TESTED
DROP FUNCTION IF EXISTS get_week_total;
delimiter $$
CREATE FUNCTION get_week_total(week_ int, year_ int)
RETURNS decimal (7,2)
DETERMINISTIC
BEGIN
	DECLARE week_total decimal (7,2);
    SELECT SUM(total) INTO week_total
    FROM order_meta INNER JOIN order_detail ON order_meta.order_id = order_detail.order_id
    WHERE week(order_meta.order_date) = week_ AND year(order_meta.order_date) = year_;
    RETURN week_total;
END $$
delimiter ;
 
-- SELECT get_week_total(39, 2022);

/* return how many items in inventory have count of 0 */
-- TESTED
DROP FUNCTION IF EXISTS inventory_empty_count;
delimiter $$
create function inventory_empty_count()
returns int 
DETERMINISTIC
begin 
	declare empty_count int; 
    select COUNT(ingredient.ingredient_id) INTO empty_count
    from ingredient 
    where ingredient.count_package = 0;
    return empty_count;
end $$
delimiter ;
