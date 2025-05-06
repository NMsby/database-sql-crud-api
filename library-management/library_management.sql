-- Library Management System Database
-- Week 8 Assignment - Question 1
-- Created on: May 6, 2025

-- Drop the database if it exists to start fresh
DROP DATABASE IF EXISTS library_management;

-- Create a database
CREATE DATABASE library_management;

-- Use the database
USE library_management;

-- -----------------------------------------------------
-- Table structure for Members
-- -----------------------------------------------------
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    date_joined DATE NOT NULL,
    membership_status ENUM('Active', 'Expired', 'Suspended') DEFAULT 'Active',
    date_of_birth DATE,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- -----------------------------------------------------
-- Table structure for Authors
-- -----------------------------------------------------
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    biography TEXT
);

-- -----------------------------------------------------
-- Table structure for Categories
-- -----------------------------------------------------
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- -----------------------------------------------------
-- Table structure for Publishers
-- -----------------------------------------------------
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(255)
);

-- -----------------------------------------------------
-- Table structure for Books
-- -----------------------------------------------------
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    publication_date DATE,
    edition VARCHAR(20),
    pages INT,
    language VARCHAR(50) DEFAULT 'English',
    summary TEXT,
    available_copies INT NOT NULL DEFAULT 0,
    total_copies INT NOT NULL DEFAULT 0,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL
);

-- -----------------------------------------------------
-- Table structure for Book Authors (Many-to-Many relationship)
-- -----------------------------------------------------
CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table structure for Book Categories (Many-to-Many relationship)
-- -----------------------------------------------------
CREATE TABLE book_categories (
    book_id INT,
    category_id INT,
    PRIMARY KEY (book_id, category_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table structure for Loans
-- -----------------------------------------------------
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('Borrowed', 'Returned', 'Overdue', 'Lost') DEFAULT 'Borrowed',
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    CONSTRAINT chk_dates CHECK (due_date >= issue_date)
);

-- -----------------------------------------------------
-- Table structure for Fines
-- -----------------------------------------------------
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    fine_amount DECIMAL(10, 2) NOT NULL,
    fine_date DATE NOT NULL,
    payment_date DATE,
    payment_status ENUM('Paid', 'Unpaid') DEFAULT 'Unpaid',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table structure for Staff
-- -----------------------------------------------------
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    CONSTRAINT chk_staff_email CHECK (email LIKE '%@%.%')
);

-- -----------------------------------------------------
-- Table structure for Book Reservations
-- -----------------------------------------------------
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    status ENUM('Active', 'Fulfilled', 'Expired', 'Cancelled') DEFAULT 'Active',
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    CONSTRAINT chk_reservation_dates CHECK (expiry_date >= reservation_date)
);

-- -----------------------------------------------------
-- Insert Sample Data for Members
-- -----------------------------------------------------
INSERT INTO members (first_name, last_name, email, phone, address, date_joined, membership_status, date_of_birth) VALUES
('John', 'Smith', 'john.smith@email.com', '1234567890', '123 Main St, City', '2024-01-15', 'Active', '1985-06-10'),
('Sarah', 'Johnson', 'sarah.j@email.com', '2345678901', '456 Oak Ave, Town', '2024-02-20', 'Active', '1990-03-22'),
('Michael', 'Williams', 'michael.w@email.com', '3456789012', '789 Pine Rd, Village', '2024-01-05', 'Suspended', '1978-11-15'),
('Emily', 'Brown', 'emily.b@email.com', '4567890123', '101 Elm St, City', '2024-03-10', 'Active', '1995-08-30'),
('David', 'Jones', 'david.j@email.com', '5678901234', '202 Maple Dr, Town', '2024-02-28', 'Expired', '1982-04-17');

-- -----------------------------------------------------
-- Insert Sample Data for Authors
-- -----------------------------------------------------
INSERT INTO authors (first_name, last_name, birth_date, nationality, biography) VALUES
('Jane', 'Austen', '1775-12-16', 'British', 'English novelist known primarily for her six major novels'),
('George', 'Orwell', '1903-06-25', 'British', 'English novelist, essayist, journalist, and critic'),
('Agatha', 'Christie', '1890-09-15', 'British', 'English writer known for her detective novels'),
('Chinua', 'Achebe', '1930-11-16', 'Nigerian', 'Nigerian novelist, poet, professor, and critic'),
('Gabriel', 'García Márquez', '1927-03-06', 'Colombian', 'Colombian novelist, short-story writer, screenwriter, and journalist');

-- -----------------------------------------------------
-- Insert Sample Data for Categories
-- -----------------------------------------------------
INSERT INTO categories (category_name, description) VALUES
('Fiction', 'Literature created from the imagination, not presented as fact'),
('Non-Fiction', 'Prose writing that is based on facts, real events, and real people'),
('Mystery', 'Fiction dealing with the solution of a crime or the unraveling of secrets'),
('Science Fiction', 'Fiction based on imagined future scientific or technological advances'),
('Biography', 'A detailed description of a person''s life');

-- -----------------------------------------------------
-- Insert Sample Data for Publishers
-- -----------------------------------------------------
INSERT INTO publishers (publisher_name, address, phone, email, website) VALUES
('Penguin Random House', '1745 Broadway, New York, NY', '1234567890', 'info@penguinrandomhouse.com', 'www.penguinrandomhouse.com'),
('HarperCollins', '195 Broadway, New York, NY', '2345678901', 'info@harpercollins.com', 'www.harpercollins.com'),
('Simon & Schuster', '1230 Avenue of the Americas, New York, NY', '3456789012', 'info@simonandschuster.com', 'www.simonandschuster.com'),
('Oxford University Press', 'Great Clarendon Street, Oxford', '4567890123', 'info@oup.com', 'www.oup.com'),
('Macmillan Publishers', '120 Broadway, New York, NY', '5678901234', 'info@macmillan.com', 'www.macmillan.com');

-- -----------------------------------------------------
-- Insert Sample Data for Books
-- -----------------------------------------------------
INSERT INTO books (isbn, title, publisher_id, publication_date, edition, pages, language, summary, available_copies, total_copies) VALUES
('9780141439518', 'Pride and Prejudice', 1, '1813-01-28', '1st', 432, 'English', 'A romantic novel of manners by Jane Austen', 3, 5),
('9780451524935', '1984', 2, '1949-06-08', '1st', 328, 'English', 'A dystopian social science fiction novel by George Orwell', 2, 4),
('9780062073488', 'Murder on the Orient Express', 2, '1934-01-01', '2nd', 256, 'English', 'A detective novel by Agatha Christie', 1, 3),
('9780385474542', 'Things Fall Apart', 3, '1958-06-17', '3rd', 209, 'English', 'A novel by Chinua Achebe', 4, 5),
('9780060883287', 'One Hundred Years of Solitude', 4, '1967-05-30', '5th', 417, 'English', 'A landmark novel by Gabriel García Márquez', 0, 2);

-- -----------------------------------------------------
-- Insert Sample Data for Book Authors
-- -----------------------------------------------------
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), -- Pride and Prejudice by Jane Austen
(2, 2), -- 1984 by George Orwell
(3, 3), -- Murder on the Orient Express by Agatha Christie
(4, 4), -- Things Fall Apart by Chinua Achebe
(5, 5); -- One Hundred Years of Solitude by Gabriel García Márquez

-- -----------------------------------------------------
-- Insert Sample Data for Book Categories
-- -----------------------------------------------------
INSERT INTO book_categories (book_id, category_id) VALUES
(1, 1), -- Pride and Prejudice - Fiction
(2, 1), -- 1984 - Fiction
(2, 4), -- 1984 - Science Fiction
(3, 1), -- Murder on the Orient Express - Fiction
(3, 3), -- Murder on the Orient Express - Mystery
(4, 1), -- Things Fall Apart - Fiction
(5, 1); -- One Hundred Years of Solitude - Fiction

-- -----------------------------------------------------
-- Insert Sample Data for Loans
-- -----------------------------------------------------
INSERT INTO loans (book_id, member_id, issue_date, due_date, return_date, status) VALUES
(1, 1, '2025-04-10', '2025-04-24', '2025-04-22', 'Returned'),
(2, 2, '2025-04-15', '2025-04-29', NULL, 'Borrowed'),
(3, 3, '2025-04-05', '2025-04-19', '2025-04-25', 'Returned'),
(4, 4, '2025-04-20', '2025-05-04', NULL, 'Borrowed'),
(5, 5, '2025-04-01', '2025-04-15', NULL, 'Overdue');

-- -----------------------------------------------------
-- Insert Sample Data for Fines
-- -----------------------------------------------------
INSERT INTO fines (loan_id, fine_amount, fine_date, payment_date, payment_status) VALUES
(3, 6.00, '2025-04-25', '2025-04-26', 'Paid'),
(5, 20.00, '2025-04-16', NULL, 'Unpaid');

-- -----------------------------------------------------
-- Insert Sample Data for Staff
-- -----------------------------------------------------
INSERT INTO staff (first_name, last_name, email, phone, position, hire_date, salary) VALUES
('Robert', 'Brown', 'robert.b@library.com', '1234567890', 'Librarian', '2022-01-10', 45000.00),
('Jennifer', 'Lee', 'jennifer.l@library.com', '2345678901', 'Assistant Librarian', '2022-03-15', 35000.00),
('William', 'Davis', 'william.d@library.com', '3456789012', 'IT Specialist', '2022-02-01', 48000.00),
('Jessica', 'Miller', 'jessica.m@library.com', '4567890123', 'Administrative Assistant', '2022-04-01', 32000.00),
('Thomas', 'Wilson', 'thomas.w@library.com', '5678901234', 'Library Director', '2021-06-15', 65000.00);

-- -----------------------------------------------------
-- Insert Sample Data for Reservations
-- -----------------------------------------------------
INSERT INTO reservations (book_id, member_id, reservation_date, expiry_date, status) VALUES
(1, 3, '2025-04-05', '2025-04-12', 'Fulfilled'),
(2, 4, '2025-04-10', '2025-04-17', 'Cancelled'),
(3, 5, '2025-04-15', '2025-04-22', 'Expired'),
(4, 1, '2025-04-20', '2025-04-27', 'Active'),
(5, 2, '2025-04-25', '2025-05-02', 'Active');
