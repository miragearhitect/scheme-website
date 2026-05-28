PRAGMA foreign_keys = OFF;

DELETE FROM sales;
DELETE FROM inventory;
DELETE FROM users;
DELETE FROM employees;

-- EMPLOYEES

INSERT INTO employees (fullname, tel, address, email, salary) VALUES
('John Smith', '+1-555-1001', '12 Oak Street', 'john.smith@company.com', 4500),
('Emma Johnson', '+1-555-1002', '55 Pine Avenue', 'emma.johnson@company.com', 5200),
('Michael Brown', '+1-555-1003', '78 Cedar Road', 'michael.brown@company.com', 4700),
('Sophia Davis', '+1-555-1004', '91 Maple Lane', 'sophia.davis@company.com', 6100),
('Daniel Wilson', '+1-555-1005', '15 Birch Drive', 'daniel.wilson@company.com', 3900),
('Olivia Martinez', '+1-555-1006', '44 Walnut Street', 'olivia.martinez@company.com', 5800),
('James Anderson', '+1-555-1007', '88 Elm Street', 'james.anderson@company.com', 4300),
('Isabella Taylor', '+1-555-1008', '7 River Road', 'isabella.taylor@company.com', 5600),
('William Thomas', '+1-555-1009', '33 Sunset Blvd', 'william.thomas@company.com', 4100),
('Mia Jackson', '+1-555-1010', '100 Hill Street', 'mia.jackson@company.com', 4950),
('Benjamin White', '+1-555-1011', '11 Lake Avenue', 'benjamin.white@company.com', 6200),
('Charlotte Harris', '+1-555-1012', '25 Forest Road', 'charlotte.harris@company.com', 5300),
('Lucas Martin', '+1-555-1013', '63 Willow Drive', 'lucas.martin@company.com', 4700),
('Amelia Thompson', '+1-555-1014', '77 Green Street', 'amelia.thompson@company.com', 5900),
('Henry Garcia', '+1-555-1015', '84 Highland Ave', 'henry.garcia@company.com', 4400),
('Evelyn Martinez', '+1-555-1016', '5 Cherry Lane', 'evelyn.martinez@company.com', 5100),
('Alexander Robinson', '+1-555-1017', '47 Rose Street', 'alexander.robinson@company.com', 6000),
('Harper Clark', '+1-555-1018', '96 Valley Road', 'harper.clark@company.com', 5400),
('Sebastian Lewis', '+1-555-1019', '72 Brook Street', 'sebastian.lewis@company.com', 4800),
('Abigail Walker', '+1-555-1020', '18 Garden Lane', 'abigail.walker@company.com', 5750);

-- =========================================================

INSERT INTO users (username, password_hash, role) VALUES
('admin', 'hash_admin', 'admin'),
('manager1', 'hash_manager1', 'manager'),
('manager2', 'hash_manager2', 'manager'),
('employee1', 'hash_employee1', 'employee'),
('employee2', 'hash_employee2', 'employee'),
('employee3', 'hash_employee3', 'employee'),
('employee4', 'hash_employee4', 'employee'),
('employee5', 'hash_employee5', 'employee'),
('employee6', 'hash_employee6', 'employee'),
('employee7', 'hash_employee7', 'employee'),
('employee8', 'hash_employee8', 'employee'),
('employee9', 'hash_employee9', 'employee'),
('employee10', 'hash_employee10', 'employee'),
('cashier1', 'hash_cashier1', 'cashier'),
('cashier2', 'hash_cashier2', 'cashier'),
('warehouse1', 'hash_warehouse1', 'warehouse'),
('warehouse2', 'hash_warehouse2', 'warehouse'),
('auditor1', 'hash_auditor1', 'auditor'),
('support1', 'hash_support1', 'support'),
('guest1', 'hash_guest1', 'guest');

-- INVENTORY

INSERT INTO inventory (name, description, sku, price, quantity) VALUES
('Laptop Pro 15', '15 inch business laptop', 'LAP-1001', 1500, 25),
('Wireless Mouse', 'Bluetooth ergonomic mouse', 'MOU-1002', 45, 120),
('Mechanical Keyboard', 'RGB mechanical keyboard', 'KEY-1003', 95, 75),
('27 Inch Monitor', '4K IPS display', 'MON-1004', 320, 40),
('USB-C Dock', 'Multiport docking station', 'DOC-1005', 110, 60),
('Office Chair', 'Ergonomic office chair', 'CHA-1006', 260, 30),
('Standing Desk', 'Adjustable standing desk', 'DES-1007', 480, 15),
('Webcam HD', '1080p USB webcam', 'WEB-1008', 70, 90),
('Noise Cancel Headphones', 'Wireless ANC headphones', 'HEA-1009', 210, 35),
('External SSD 1TB', 'Portable SSD storage', 'SSD-1010', 140, 55),
('Network Switch', '24-port gigabit switch', 'NET-1011', 180, 20),
('Printer Laser', 'Office laser printer', 'PRI-1012', 350, 12),
('Smartphone X', '128GB smartphone', 'PHO-1013', 999, 28),
('Tablet Plus', '10 inch tablet device', 'TAB-1014', 650, 18),
('Projector HD', 'Conference room projector', 'PRO-1015', 720, 10),
('Router AX6000', 'High speed WiFi router', 'ROU-1016', 240, 22),
('Graphics Tablet', 'Digital drawing tablet', 'GRA-1017', 190, 14),
('Portable Scanner', 'Compact document scanner', 'SCA-1018', 130, 17),
('Microphone USB', 'Podcast microphone', 'MIC-1019', 115, 32),
('Server Rack', '42U enterprise rack', 'SER-1020', 890, 6);

-- SALES

INSERT INTO sales (inventory_id, user_id, quantity, total_price) VALUES
(1, 1, 1, 1500),
(2, 4, 2, 90),
(3, 5, 1, 95),
(4, 2, 3, 960),
(5, 6, 1, 110),
(6, 3, 2, 520),
(7, 7, 1, 480),
(8, 8, 4, 280),
(9, 9, 1, 210),
(10, 10, 2, 280),
(11, 11, 1, 180),
(12, 12, 1, 350),
(13, 13, 2, 1998),
(14, 14, 1, 650),
(15, 15, 1, 720),
(16, 16, 3, 720),
(17, 17, 1, 190),
(18, 18, 2, 260),
(19, 19, 2, 230),
(20, 20, 1, 890);

PRAGMA foreign_keys = ON;
