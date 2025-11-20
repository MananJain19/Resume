CREATE DATABASE IF NOT EXISTS restaurant_website CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restaurant_website;
CREATE TABLE IF NOT EXISTS branches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS menu_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  branch_id INT DEFAULT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  category VARCHAR(100),
  FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(255),
  total DECIMAL(10,2),
  status ENUM('pending','preparing','served','cancelled') DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  delivery_boy_id INT DEFAULT NULL
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  menu_item_id INT NOT NULL,
  qty INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100),
  total_points INT DEFAULT 0
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS feedback (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  customer_name VARCHAR(100),
  rating INT,
  comments TEXT,
  feedback_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS delivery_boys (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  phone VARCHAR(30),
  branch_id INT,
  is_available TINYINT(1) DEFAULT 1,
  FOREIGN KEY (branch_id) REFERENCES branches(id)
) ENGINE=InnoDB;
INSERT INTO branches (name) VALUES ('Central - MG Road') ;
INSERT INTO branches (name) VALUES ('North - Hinjewadi') ;
INSERT INTO branches (name) VALUES ('East - Kothrud') ;
INSERT INTO menu_items (branch_id,name,description,price,category) VALUES (1, 'Margherita Pizza', 'Cheese pizza', 249.0, 'Pizza');
INSERT INTO menu_items (branch_id,name,description,price,category) VALUES (1, 'Veg Extravaganza', 'Loaded veg pizza', 349.0, 'Pizza');
INSERT INTO menu_items (branch_id,name,description,price,category) VALUES (2, 'Paneer Butter Masala', 'Creamy paneer', 199.0, 'Main Course');
INSERT INTO menu_items (branch_id,name,description,price,category) VALUES (2, 'Butter Naan', 'Soft naan', 40.0, 'Bread');
INSERT INTO menu_items (branch_id,name,description,price,category) VALUES (3, 'Veg Fried Rice', 'Fried rice', 129.0, 'Rice');
INSERT INTO menu_items (branch_id,name,description,price,category) VALUES (3, 'Momos', 'Steamed momos', 99.0, 'Snacks');
INSERT INTO menu_items (branch_id,name,description,price,category) VALUES (1, 'Brownie', 'Chocolate dessert', 99.0, 'Dessert');
INSERT INTO menu_items (branch_id,name,description,price,category) VALUES (2, 'Cold Coffee', 'Iced coffee', 79.0, 'Beverage');
INSERT INTO delivery_boys (name,phone,branch_id,is_available) VALUES ('Ramesh','9998887777',1,1),('Suresh','9998886666',2,1);
INSERT INTO customers (name,email,total_points) VALUES ('Rahul','rahul@example.com',50),('Priya','priya@example.com',20);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Rahul', 778.00, 'served', '2025-10-26 12:06:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 2, 2, 349.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 4, 2, 40.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Priya', 198.00, 'served', '2025-10-27 12:09:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 7, 2, 99.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Priya', 298.00, 'served', '2025-10-28 12:00:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 4, 1, 40.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 5, 2, 129.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Guest_13', 428.00, 'served', '2025-10-29 12:08:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 1, 1, 249.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 4, 2, 40.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 6, 1, 99.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Priya', 1136.00, 'served', '2025-10-30 12:00:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 4, 1, 40.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 3, 2, 199.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 2, 2, 349.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Guest_81', 398.00, 'served', '2025-10-31 12:01:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 3, 2, 199.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Guest_52', 555.00, 'served', '2025-10-31 12:09:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 7, 1, 99.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 5, 2, 129.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 6, 2, 99.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Priya', 927.00, 'served', '2025-11-01 12:05:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 1, 2, 249.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 4, 2, 40.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 2, 1, 349.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Guest_80', 428.00, 'served', '2025-11-01 12:05:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 6, 1, 99.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 1, 1, 249.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 4, 2, 40.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Priya', 258.00, 'served', '2025-11-02 12:02:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 5, 2, 129.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Guest_31', 249.00, 'served', '2025-11-02 12:08:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 1, 1, 249.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Priya', 654.00, 'served', '2025-11-03 12:08:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 6, 2, 99.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 7, 2, 99.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 5, 2, 129.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Guest_87', 99.00, 'served', '2025-11-03 12:08:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 7, 1, 99.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Rahul', 538.00, 'served', '2025-11-03 12:08:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 1, 2, 249.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 4, 1, 40.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Priya', 696.00, 'served', '2025-11-04 12:09:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 6, 2, 99.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 1, 2, 249.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Rahul', 526.00, 'served', '2025-11-04 12:00:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 3, 1, 199.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 5, 1, 129.00);
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 7, 2, 99.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Rahul', 79.00, 'served', '2025-11-05 12:04:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 8, 1, 79.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Priya', 398.00, 'served', '2025-11-05 12:04:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 3, 2, 199.00);
INSERT INTO orders (customer_name,total,status,created_at) VALUES ('Rahul', 129.00, 'served', '2025-11-05 12:04:00');
SET @last = LAST_INSERT_ID();
INSERT INTO order_items (order_id,menu_item_id,qty,price) VALUES (@last, 5, 1, 129.00);
INSERT INTO feedback (order_id,customer_name,rating,comments) VALUES (1,'Rahul',5,'Excellent service'),(2,'Priya',4,'Good food');