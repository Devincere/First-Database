CREATE DATABASE IF NOT EXISTS project5;

USE project5;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS delivery_men;
DROP TABLE IF EXISTS dishes;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
SET FOREIGN_KEY_CHECKS = 1;



/*Table structure clients */


CREATE TABLE clients(

client_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
phone VARCHAR(15) NOT NULL,
email VARCHAR(20) NOT NULL,
address_line1 VARCHAR(50) NOT NULL,
address_line2 VARCHAR(50) NOT NULL,
city VARCHAR(30) NOT NULL,
postal_code VARCHAR(10) NOT NULL,
country VARCHAR(20) NOT NULL

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
type VARCHAR(20) NOT NULL,
description VARCHAR(100) NOT NULL,
date DATE NOT NULL,
price DECIMAL(3 , 2) NOT NULL

);

/*Table structure order items */


CREATE TABLE order_items(

order_item_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
dish_id INT NOT NULL,
order_id INT NOT NULL, 
quantity INT NOT NULL,
price DECIMAL(3 , 2) NOT NULL



);


/*Table structure orders */


CREATE TABLE orders (

	order_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    client_id INT NOT NULL,
    employee_id INT NOT NULL,
    date DATETIME NOT NULL,
    adress_line_1 VARCHAR(50) NOT NULL,
    adress_line_2 VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    country VARCHAR(20) NOT NULL,
    payment_method ENUM("credit_card" , "paypal") NOT NULL,
    status ENUM("preparing_the_order" , "out_for_delivery" , "delivered") NOT NULL,
    total_price DECIMAL(3 , 2 ) NOT NULL
    
   
    
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



