-- Task Manager Database
-- Week 8 Assignment - Question 2
-- Created on: May 6, 2025

-- Drop the database if it exists to start fresh
DROP DATABASE IF EXISTS task_manager;

-- Create the database
CREATE DATABASE task_manager;

-- Use the database
USE task_manager;

-- -----------------------------------------------------
-- Table structure for Users
-- -----------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- Table structure for Categories
-- -----------------------------------------------------
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- Table structure for Projects
-- -----------------------------------------------------
CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    user_id INT NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('Not Started', 'In Progress', 'Completed', 'On Hold') DEFAULT 'Not Started',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table structure for Tasks
-- -----------------------------------------------------
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    user_id INT NOT NULL,
    project_id INT,
    category_id INT,
    due_date DATE,
    priority ENUM('Low', 'Medium', 'High', 'Urgent') DEFAULT 'Medium',
    status ENUM('To Do', 'In Progress', 'Completed', 'Deferred') DEFAULT 'To Do',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- -----------------------------------------------------
-- Insert Sample Data for Users
-- -----------------------------------------------------
INSERT INTO users (username, email, password_hash, first_name, last_name) VALUES
('johndoe', 'john.doe@email.com', '$2b$12$1234567890abcdefghijkl', 'John', 'Doe'),
('janedoe', 'jane.doe@email.com', '$2b$12$abcdefghijkl1234567890', 'Jane', 'Doe'),
('bobsmith', 'bob.smith@email.com', '$2b$12$qwertyuiopasdfghjklzxc', 'Bob', 'Smith');

-- -----------------------------------------------------
-- Insert Sample Data for Categories
-- -----------------------------------------------------
INSERT INTO categories (name, description) VALUES
('Work', 'Tasks related to my job'),
('Personal', 'Personal tasks and errands'),
('Study', 'Educational tasks and projects'),
('Health', 'Health and fitness related tasks');

-- -----------------------------------------------------
-- Insert Sample Data for Projects
-- -----------------------------------------------------
INSERT INTO projects (name, description, user_id, start_date, end_date, status) VALUES
('Website Redesign', 'Redesign company website with new brand guidelines', 1, '2025-04-01', '2025-06-30', 'In Progress'),
('Learn FastAPI', 'Complete FastAPI course and build a project', 2, '2025-05-01', '2025-05-31', 'Not Started'),
('Home Renovation', 'Kitchen and bathroom renovation project', 3, '2025-03-15', '2025-07-15', 'In Progress');

-- -----------------------------------------------------
-- Insert Sample Data for Tasks
-- -----------------------------------------------------
INSERT INTO tasks (title, description, user_id, project_id, category_id, due_date, priority, status) VALUES
('Design mockups', 'Create new website mockups in Figma', 1, 1, 1, '2025-05-15', 'High', 'In Progress'),
('Frontend implementation', 'Implement new design in React', 1, 1, 1, '2025-06-01', 'Medium', 'To Do'),
('Complete FastAPI tutorial', 'Finish chapters 1-5 of FastAPI tutorial', 2, 2, 3, '2025-05-10', 'Medium', 'To Do'),
('Buy materials', 'Purchase tiles, paint, and fixtures for renovation', 3, 3, 2, '2025-05-20', 'High', 'To Do'),
('Schedule contractor', 'Set up meetings with potential contractors', 3, 3, 2, '2025-05-15', 'Urgent', 'Completed'),
('Doctor appointment', 'Annual checkup at Dr. Smith', 2, NULL, 4, '2025-05-30', 'Medium', 'To Do'),
('Update resume', 'Refresh resume with recent projects', 1, NULL, 1, '2025-06-15', 'Low', 'To Do');