CREATE DATABASE IF NOT EXISTS project5;

USE project5;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS delivery_men;
DROP TABLE IF EXISTS dishes;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;

DROP TRIGGER IF EXISTS calc_total_after_insert;
DROP TRIGGER IF EXISTS calc_total_after_update;
DROP TRIGGER IF EXISTS calc_total_after_delete;

SET FOREIGN_KEY_CHECKS = 1;



/*Table structure clients */


CREATE TABLE clients(

client_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
phone VARCHAR(15),
email VARCHAR(20) NOT NULL,
address_line1 VARCHAR(50),
address_line2 VARCHAR(50),
city VARCHAR(30),
postal_code VARCHAR(10),
country VARCHAR(20)

);


/*Table structure delivery men */


CREATE TABLE delivery_men(

employee_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL

);


/*Table structure dishes */


CREATE TABLE dishes(

dish_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
name VARCHAR(50) NOT NULL,
type ENUM("main", "desert") NOT NULL,
description VARCHAR(100) NOT NULL,
date DATE NOT NULL,
price DECIMAL(4 , 2) NOT NULL

);

/*Table structure order items */


CREATE TABLE order_items(

order_item_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
dish_id INT NOT NULL,
order_id INT NOT NULL, 
quantity DECIMAL(4, 2) NOT NULL,
price DECIMAL(4, 2) NOT NULL



);


/*Table structure orders */


CREATE TABLE orders(

order_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
client_id INT NOT NULL,
employee_id INT NOT NULL,
date DATETIME NOT NULL,
address_line_1 VARCHAR(50) NOT NULL,
address_line_2 VARCHAR(50),
city VARCHAR(50) NOT NULL,
postal_code VARCHAR(10) NOT NULL,
country VARCHAR(20) NOT NULL,
payment_method ENUM("credit_card" , "paypal") NOT NULL,
status ENUM("pending" , "preparing" , "out_for_delivery" , "delivered") NOT NULL DEFAULT"pending",
total_price DECIMAL(4 , 2 ) DEFAULT 0.00
);


/*Add Foreign Key*/

ALTER TABLE order_items
ADD FOREIGN KEY (dish_id) REFERENCES dishes (dish_id);
ALTER TABLE order_items
ADD FOREIGN KEY (order_id) REFERENCES orders (order_id);


ALTER TABLE orders
ADD FOREIGN KEY (client_id) REFERENCES clients (client_id);
ALTER TABLE orders
ADD FOREIGN KEY (employee_id) REFERENCES delivery_men (employee_id);



DELIMITER $$

CREATE TRIGGER calc_total_after_insert
    AFTER INSERT
    ON order_items FOR EACH ROW
BEGIN

	DECLARE order_total FLOAT;
    
    SELECT SUM(total_per_line)
	FROM (
		SELECT order_id, quantity * price total_per_line
		FROM order_items
	) AS Q1
	WHERE order_id = NEW.order_id
	INTO order_total;

	UPDATE orders SET total_price = order_total WHERE order_id = NEW.order_id;
    
END$$    

DELIMITER ;


DELIMITER $$

CREATE TRIGGER calc_total_after_update
    AFTER UPDATE
    ON order_items FOR EACH ROW
BEGIN

	DECLARE order_total FLOAT;
    
    SELECT SUM(total_per_line)
	FROM (
		SELECT order_id, quantity * price total_per_line
		FROM order_items
	) AS Q1
	WHERE order_id = NEW.order_id
	INTO order_total;

	UPDATE orders SET total_price = order_total WHERE order_id = NEW.order_id;
    
END$$    

DELIMITER ;



DELIMITER $$

CREATE TRIGGER calc_total_after_delete
    AFTER DELETE
    ON order_items FOR EACH ROW
BEGIN

	DECLARE order_total FLOAT;
    
    SELECT SUM(total_per_line)
	FROM (
		SELECT order_id, quantity * price total_per_line
		FROM order_items
	) AS Q1
	WHERE order_id = OLD.order_id
	INTO order_total;

	UPDATE orders SET total_price = order_total WHERE order_id = OLD.order_id;
    
END$$    

DELIMITER ;

/* Add Data CLIENTS*/ 

INSERT INTO clients (client_id ,first_name, last_name, phone, email, address_line1, address_line2, city, postal_code, country) VALUES 

(DEFAULT, "John", "Smith", "111 111 1111", "john@smith.com", "", "", "", "", ""),
(DEFAULT, "Sean", "Obrien", "222 222 2222", "sean@obrien.com", "", "", "", "", ""),
(DEFAULT, "Manuel", "Rivera", "333 333 3333", "manuel@rivera.com", "", "", "", "", ""),
(DEFAULT, "Laura", "Piccoli", "444 444 4444", "laura@piccoli.com", "", "", "", "", ""),
(DEFAULT, "Maria", "Obrador", "555 555 5555", "john@smith.com", "", "", "", "", "");


/* Add Data DELIVERY_MEN */
INSERT INTO delivery_men (employee_id ,first_name, last_name) VALUES

(DEFAULT, "Igor", "Navrov"),
(DEFAULT, "Lisa", "Dupond"),
(DEFAULT, "Robert", "Digne"),
(DEFAULT, "Olivier", "Kos"),
(DEFAULT, "Nathalie", "Proust");

/* Add Data DISHES */
INSERT INTO dishes (dish_id, `name`, `type`, description, `date`, price) VALUES

(DEFAULT, "Risotto", "main", "This is the first main dish", "2021-12-01", 10.00),
(DEFAULT, "Coucous", "main", "This is the second main dish", "2021-12-01", 15.50),
(DEFAULT, "Glace", "desert", "This is the first desert", "2021-12-01" , 5.00),
(DEFAULT, "Cake", "desert", "This is the second desert", "2021-12-01", 3.50),

(DEFAULT, "Spaguetti", "main", "This is the first main dish", "2021-12-04", 10.00),
(DEFAULT, "Pizza", "main", "This is the second main dish", "2021-12-04", 15.50),
(DEFAULT, "Tiramisu", "desert", "This is the first desert", "2021-12-04" , 5.00),
(DEFAULT, "Yogurt", "desert", "This is the second desert", "2021-12-04", 3.50);


/*Add Data ORDERS*/
INSERT INTO orders (order_id, client_id, employee_id, `date`, address_line_1, address_line_2, city, postal_code, country, total_price, payment_method, status) VALUES

(DEFAULT, 1, 1, "2021-12-01", "Times Square", "Manhatan", "New York", "DFE T34", "USA", DEFAULT, "credit_card", "Pending"),
(DEFAULT, 1, 1, "2021-12-01", "Times Square", "Manhatan", "New York", "DFE T34", "USA", DEFAULT, "credit_card", "Pending"),
(DEFAULT, 2, 2, "2021-12-02", "Champs élysées", "8ieme arroudissement", "Paris", "75865", "France", DEFAULT, "paypal", "out_for_delivery"),
(DEFAULT, 3, 3, "2021-12-03", "Place du jeu de ballon", "", "Montpellier", "34000", "France", DEFAULT, "credit_card", "delivered"),
(DEFAULT, 4, 4, "2021-12-04", "Plazza bella", "N/A", "Milan", "FGE 343", "Italia", DEFAULT, "paypal", "pending"),
(DEFAULT, 5, 5, "2021-12-05", "Union quay", "N/A", "Dublin", "FD3 324", "Ireland", DEFAULT, "credit_card", "pending");

/*Add Data ORDER_ITEMS*/
SET FOREIGN_KEY_CHECKS = 0;
INSERT INTO order_items (order_item_id, dish_id,order_id ,quantity, price) VALUES

(DEFAULT, 1, 1, 1, 10.00),
(DEFAULT, 3, 1, 1, 05.00),

(DEFAULT, 1, 2, 1, 10.00),
(DEFAULT, 3, 2, 1, 05.00),

(DEFAULT, 2, 3, 1, 15.00),
(DEFAULT, 4, 3, 1, 03.50),

(DEFAULT, 5, 4, 1, 10.00),
(DEFAULT, 8, 4, 1, 03.50);
SET FOREIGN_KEY_CHECKS = 1;


SELECT 
	o.*,
	CONCAT(c.first_name, ' ', c.last_name) client,
	c.phone,
	CONCAT(d.first_name, ' ', d.last_name) 'delivered by',
	1+1 as total
FROM orders o
JOIN clients c USING(client_id)
JOIN delivery_men d USING(employee_id)
WHERE client_id = 1;

describe delivery_men;

/* 

describe orders;
SELECT * FROM order_items where order_id = 1;
SELECT * FROM orders;


UPDATE order_items SET quantity = 2 WHERE order_item_id = 1;

DELETE FROM order_items  WHERE order_item_id = 2;


*/









