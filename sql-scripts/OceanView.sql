DELETE FROM Users WHERE idusers = 1;

INSERT INTO users (username, password) VALUES ('admin', '1234');

ALTER TABLE users MODIFY COLUMN role ENUM('Admin', 'Manager', 'Receptionist') NOT NULL;

SELECT * FROM USERS

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role ENUM('Admin', 'Manager', 'Receptionist') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, full_name, role) VALUES 
('admin_user', 'admin123', 'System Administrator', 'Admin'),
('manager_user', 'man123', 'Hotel Manager', 'Manager'),
('recept_user', 'rec123', 'Front Desk Receptionist', 'Receptionist');

ALTER TABLE users 
ADD COLUMN failed_attempts INT DEFAULT 0,
ADD COLUMN account_status VARCHAR(20) DEFAULT 'Active';

SELECT * FROM USERS

CREATE TABLE reservations (
    reservation_no VARCHAR(20) PRIMARY KEY,
    guest_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    contact_no VARCHAR(15),
    room_type VARCHAR(50),
    check_in DATE,
    check_out DATE
);

ALTER TABLE reservations ADD COLUMN room_id INT;

ALTER TABLE reservations
ADD CONSTRAINT fk_room FOREIGN KEY (room_id) REFERENCES rooms(room_id);

ALTER TABLE reservations 
ADD COLUMN id_type VARCHAR(20),
ADD COLUMN id_number VARCHAR(50);

SELECT * FROM reservations

DROP TABLE IF EXISTS reservations;

CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50) NOT NULL,
    price_per_night DOUBLE NOT NULL,
    status VARCHAR(20) DEFAULT 'Available'
);

INSERT INTO rooms (room_type, price_per_night, status) VALUES 
('Suite', 20000.00, 'Available');

SELECT * FROM rooms

DROP TABLE IF EXISTS rooms;

CREATE TABLE system_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(50),
    action VARCHAR(255),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM system_logs