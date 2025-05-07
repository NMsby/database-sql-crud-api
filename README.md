# Task Manager API and Library Management System

## Project Overview

This repository contains two comprehensive database systems developed as part of the Week 8 Assignment for the Database Design & Programming with SQL module:

1. **Library Management System**: A complete MySQL database solution for managing a library's operations including members, books, loans, and more.
2. **Task Manager API**: A fully-functional CRUD API built with FastAPI and MySQL that allows users to manage tasks, projects, and categories.

## Repository Structure

```
database-sql-crud-api/
├── README.md
├── library-management/
│   └── library_management.sql
├── task-manager/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── crud.py
│   │   ├── database.py
│   │   ├── main.py
│   │   ├── models.py
│   │   └── schemas.py
│   ├── database/
│   │   └── task_manager.sql
│   ├── tests/
│   │   ├── __init__.py
│   │   └── test_api.py
│   ├── .env.example
│   ├── requirements.txt
│   └── setup.py
└── docs/
    ├── library_erd.png
    └── task_manager_erd.png
```

## Part 1: Library Management System

### Features

- Complete relational database design with 9 interconnected tables
- Primary and foreign key constraints for data integrity
- Multiple relationship types (one-to-one, one-to-many, many-to-many)
- Comprehensive sample data for testing
- Views for common complex queries
- Stored procedures for operations like checking out and returning books
- Triggers for maintaining data integrity and automation

### Entity Relationship Diagram

![Library Management System ERD](docs/library_erd.png)

### Tables

1. **members**: Stores library member information
2. **books**: Contains book details and availability information
3. **authors**: Information about book authors
4. **publishers**: Details of book publishers
5. **categories**: Book categories/genres
6. **book_authors**: Junction table for many-to-many relationship between books and authors
7. **book_categories**: Junction table for many-to-many relationship between books and categories
8. **loans**: Records of books borrowed by members
9. **fines**: Tracks overdue fines for late returns
10. **staff**: Library staff information
11. **reservations**: Book reservation records

### Setup Instructions

1. Create a MySQL database
2. Import the SQL script:
   ```bash
   mysql -u yourusername -p < library-management/library_management.sql
   ```
3. The database will be created with all tables, relationships, sample data, stored procedures, and triggers

## Part 2: Task Manager API

### Features

- RESTful API built with FastAPI and SQLAlchemy
- Complete CRUD operations for all entities
- MySQL database integration
- Data validation with Pydantic schemas
- Comprehensive API documentation with Swagger UI
- Proper error handling and status codes
- Relationship management between entities
- Automated testing

### Entity Relationship Diagram

![Task Manager ERD](docs/task_manager_erd.png)

### Database Design

The Task Manager uses four main tables:

1. **users**: Stores user information
2. **projects**: Contains project details associated with users
3. **categories**: Task categories for organization
4. **tasks**: Main task data with relationships to users, projects, and categories

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | / | Welcome message |
| **Users** |
| POST | /users/ | Create a new user |
| GET | /users/ | Get all users |
| GET | /users/{user_id} | Get user by ID |
| PUT | /users/{user_id} | Update user information |
| DELETE | /users/{user_id} | Delete a user |
| **Categories** |
| POST | /categories/ | Create a new category |
| GET | /categories/ | Get all categories |
| GET | /categories/{category_id} | Get category by ID |
| PUT | /categories/{category_id} | Update category information |
| DELETE | /categories/{category_id} | Delete a category |
| **Projects** |
| POST | /projects/ | Create a new project |
| GET | /projects/ | Get all projects |
| GET | /projects/{project_id} | Get project by ID |
| PUT | /projects/{project_id} | Update project information |
| DELETE | /projects/{project_id} | Delete a project |
| GET | /users/{user_id}/projects/ | Get all projects for a user |
| **Tasks** |
| POST | /tasks/ | Create a new task |
| GET | /tasks/ | Get all tasks |
| GET | /tasks/{task_id} | Get task by ID |
| PUT | /tasks/{task_id} | Update task information |
| DELETE | /tasks/{task_id} | Delete a task |
| GET | /users/{user_id}/tasks/ | Get all tasks for a user |
| GET | /projects/{project_id}/tasks/ | Get all tasks for a project |
| GET | /categories/{category_id}/tasks/ | Get all tasks for a category |

### Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/NMsby/database-sql-crud-api.git
   cd database-sql-crud-api/task-manager
   ```

2. Create a MySQL database for the Task Manager:
   ```bash
   mysql -u yourusername -p < database/task_manager.sql
   ```

3. Create a virtual environment and install dependencies:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

4. Create a `.env` file based on the `.env.example` template:
   ```bash
   cp .env.example .env
   # Edit the .env file with your database credentials
   ```

5. Run the FastAPI application:
   ```bash
   uvicorn app.main:app --reload
   ```

6. Access the API documentation at http://localhost:8000/docs

### Running Tests

1. Install the testing dependencies:
   ```bash
   pip install pytest pytest-asyncio httpx
   ```

2. Run the tests:
   ```bash
   pytest
   ```

## API Testing with Postman

1. Download and install Postman from the [official website](https://www.postman.com/downloads/).
2. Create a new collection in Postman named "Task Manager API".
3. Create a new environment with a variable `base_url` set to `http://localhost:8000`.
4. Import the provided Postman collection or create requests for each endpoint.

## Code Documentation

### Database Connection (database.py)

This module handles the connection to the MySQL database using SQLAlchemy. It loads environment variables from a `.env` file and creates an engine, session, and base model class.

### Models (models.py)

The models module defines the SQLAlchemy ORM models that map to database tables:

- **User**: Represents a user in the system
- **Category**: A category for organizing tasks
- **Project**: A project that contains tasks and belongs to a user
- **Task**: The main task entity with relationships to users, projects, and categories

Each model includes appropriate fields, relationships, and constraints.

### Schemas (schemas.py)

This module contains Pydantic models for request and response validation:

- **Base models**: Define common fields for each entity
- **Create models**: Used for creating new entities
- **Update models**: Used for updating existing entities
- **Response models**: Used for returning data to clients

### CRUD Operations (crud.py)

This module provides functions for interacting with the database:

- Create: Add new entities to the database
- Read: Retrieve entities from the database
- Update: Modify existing entities
- Delete: Remove entities from the database

Each entity type (User, Category, Project, Task) has its own set of CRUD functions.

### API Routes (main.py)

The main module defines the FastAPI application and all the API routes. It integrates the schemas, models, and CRUD functions to handle HTTP requests.

## Best Practices Implemented

- **Separation of Concerns**: Database operations, models, schemas, and API routes are separated into different modules
- **Data Validation**: All input and output data is validated using Pydantic schemas
- **Error Handling**: Proper HTTP status codes and error messages are returned for different scenarios
- **Code Organization**: The code is organized into logical modules and folders
- **Documentation**: Comprehensive documentation is provided for the API endpoints
- **Testing**: Automated tests ensure the API functions correctly
- **Environment Variables**: Sensitive configuration is managed through environment variables
- **Database Relationships**: Proper relationships and constraints are set up between entities
- **Cascading Deletes**: Deleting a parent record automatically deletes related child records

## Future Enhancements

- Add user authentication with JWT tokens
- Implement role-based access control
- Add pagination for list endpoints
- Implement filtering and sorting options
- Add file uploads for tasks and projects
- Create a front-end web application
- Add email notifications for task deadlines
- Implement task priority queues
- Add time tracking functionality
- Create reports and analytics

## Contributors

- [Nelson Masbayi](https://github.com/NMsby/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---