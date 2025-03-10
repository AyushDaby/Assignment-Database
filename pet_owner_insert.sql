INSERT INTO Owner (owner_id, fname, lname, street, city, post_code, owner_email, owner_phoneNo,Quantity) VALUES
('O001', 'John', 'Doe', '123 Elm St', 'Springfield', '12345', 'john.doe@example.com', '555-1234', 2),
('O002', 'Jane', 'Smith', '456 Oak St', 'Shelbyville', '67890', 'jane.smith@example.com', '555-5678', 1),
('O003', 'Alice', 'Johnson', '789 Pine St', 'Capital City', '11223', 'alice.johnson@example.com', '555-9101', 2),
('O004', 'Bob', 'Brown', '101 Maple St', 'Ogdenville', '44556', 'bob.brown@example.com', '555-1122', 1),
('O005', 'Charlie', 'Davis', '202 Birch St', 'North Haverbrook', '77889', 'charlie.davis@example.com', '555-3344', 2),
('O006', 'Diana', 'Evans', '303 Cedar St', 'Springfield', '99001', 'diana.evans@example.com', '555-5566', 1),
('O007', 'Ethan', 'Harris', '404 Spruce St', 'Shelbyville', '22334', 'ethan.harris@example.com', '555-7788', 1),
('O008', 'Fiona', 'Clark', '505 Fir St', 'Capital City', '55667', 'fiona.clark@example.com', '555-9900', 0),
('O009', 'George', 'Lewis', '606 Redwood St', 'Ogdenville', '88990', 'george.lewis@example.com', '555-0011', 0),
('O010', 'Hannah', 'Walker', '707 Sequoia St', 'North Haverbrook', '11212', 'hannah.walker@example.com', '555-2233', 0);

INSERT INTO pets (pet_id, name, age, species, owner_id)
VALUES
('P001', 'Buddy', 3, 'mammals', 'O001'),
('P002', 'Milo', 2, 'mammals', 'O001'),
('P003', 'Charlie', 5, 'birds', 'O002'),
('P004', 'Lucy', 4, 'mammals', 'O003'),
('P005', 'Max', 1, 'reptiles', 'O003'),
('P006', 'Bella', 7, 'mammals', 'O004'),
('P007', 'Daisy', 2, 'birds', 'O005'),
('P008', 'Luna', 3, 'mammals', 'O005'),
('P009', 'Rocky', 6, 'fish', 'O006'),
('P010', 'Coco', 4, 'mammals', 'O007');
