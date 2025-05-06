from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
import os
from dotenv import load_dotenv

from . import crud, models, schemas
from .database import engine, get_db

# Load environment variables
load_dotenv()

# Create database tables
models.Base.metadata.create_all(bind=engine)

# FastAPI app
app = FastAPI(
    title=os.getenv("APP_NAME", "Task Manager API"),
    description="A CRUD API for managing tasks, projects, and categories",
    version=os.getenv("APP_VERSION", "1.0.0")
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Root endpoint
@app.get("/", tags=["Root"])
async def root():
    return {"message": "Welcome to the Task Manager API"}


# User endpoints
@app.post("/users/", response_model=schemas.UserResponse, status_code=status.HTTP_201_CREATED, tags=["Users"])
async def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_username(db, username=user.username)
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")

    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    return crud.create_user(db=db, user=user)


@app.get("/users/", response_model=List[schemas.UserResponse], tags=["Users"])
async def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = crud.get_users(db, skip=skip, limit=limit)
    return users


@app.get("/users/{user_id}", response_model=schemas.UserResponse, tags=["Users"])
async def read_user(user_id: int, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user


@app.put("/users/{user_id}", response_model=schemas.UserResponse, tags=["Users"])
async def update_user(user_id: int, user: schemas.UserUpdate, db: Session = Depends(get_db)):
    db_user = crud.update_user(db, user_id=user_id, user=user)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user


@app.delete("/users/{user_id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Users"])
async def delete_user(user_id: int, db: Session = Depends(get_db)):
    success = crud.delete_user(db, user_id=user_id)
    if not success:
        raise HTTPException(status_code=404, detail="User not found")
    return {"ok": True}


# Category endpoints
@app.post("/categories/", response_model=schemas.CategoryResponse, status_code=status.HTTP_201_CREATED,
          tags=["Categories"])
async def create_category(category: schemas.CategoryCreate, db: Session = Depends(get_db)):
    db_category = crud.get_category_by_name(db, name=category.name)
    if db_category:
        raise HTTPException(status_code=400, detail="Category with this name already exists")

    return crud.create_category(db=db, category=category)


@app.get("/categories/", response_model=List[schemas.CategoryResponse], tags=["Categories"])
async def read_categories(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    categories = crud.get_categories(db, skip=skip, limit=limit)
    return categories


@app.get("/categories/{category_id}", response_model=schemas.CategoryResponse, tags=["Categories"])
async def read_category(category_id: int, db: Session = Depends(get_db)):
    db_category = crud.get_category(db, category_id=category_id)
    if db_category is None:
        raise HTTPException(status_code=404, detail="Category not found")
    return db_category


@app.put("/categories/{category_id}", response_model=schemas.CategoryResponse, tags=["Categories"])
async def update_category(category_id: int, category: schemas.CategoryUpdate, db: Session = Depends(get_db)):
    db_category = crud.update_category(db, category_id=category_id, category=category)
    if db_category is None:
        raise HTTPException(status_code=404, detail="Category not found")
    return db_category


@app.delete("/categories/{category_id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Categories"])
async def delete_category(category_id: int, db: Session = Depends(get_db)):
    success = crud.delete_category(db, category_id=category_id)
    if not success:
        raise HTTPException(status_code=404, detail="Category not found")
    return {"ok": True}


# Project endpoints
@app.post("/projects/", response_model=schemas.ProjectResponse, status_code=status.HTTP_201_CREATED, tags=["Projects"])
async def create_project(project: schemas.ProjectCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=project.user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")

    return crud.create_project(db=db, project=project)


@app.get("/projects/", response_model=List[schemas.ProjectResponse], tags=["Projects"])
async def read_projects(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    projects = crud.get_projects(db, skip=skip, limit=limit)
    return projects


@app.get("/projects/{project_id}", response_model=schemas.ProjectResponse, tags=["Projects"])
async def read_project(project_id: int, db: Session = Depends(get_db)):
    db_project = crud.get_project(db, project_id=project_id)
    if db_project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    return db_project


@app.put("/projects/{project_id}", response_model=schemas.ProjectResponse, tags=["Projects"])
async def update_project(project_id: int, project: schemas.ProjectUpdate, db: Session = Depends(get_db)):
    db_project = crud.update_project(db, project_id=project_id, project=project)
    if db_project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    return db_project


@app.delete("/projects/{project_id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Projects"])
async def delete_project(project_id: int, db: Session = Depends(get_db)):
    success = crud.delete_project(db, project_id=project_id)
    if not success:
        raise HTTPException(status_code=404, detail="Project not found")
    return {"ok": True}


@app.get("/users/{user_id}/projects/", response_model=List[schemas.ProjectResponse], tags=["Projects"])
async def read_user_projects(user_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")

    projects = crud.get_user_projects(db, user_id=user_id, skip=skip, limit=limit)
    return projects


# Task endpoints
@app.post("/tasks/", response_model=schemas.TaskResponse, status_code=status.HTTP_201_CREATED, tags=["Tasks"])
async def create_task(task: schemas.TaskCreate, db: Session = Depends(get_db)):
    # Validate user exists
    db_user = crud.get_user(db, user_id=task.user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")

    # Validate project exists if provided
    if task.project_id is not None:
        db_project = crud.get_project(db, project_id=task.project_id)
        if db_project is None:
            raise HTTPException(status_code=404, detail="Project not found")

    # Validate category exists if provided
    if task.category_id is not None:
        db_category = crud.get_category(db, category_id=task.category_id)
        if db_category is None:
            raise HTTPException(status_code=404, detail="Category not found")

    return crud.create_task(db=db, task=task)


@app.get("/tasks/", response_model=List[schemas.TaskResponse], tags=["Tasks"])
async def read_tasks(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    tasks = crud.get_tasks(db, skip=skip, limit=limit)
    return tasks


@app.get("/tasks/{task_id}", response_model=schemas.TaskResponse, tags=["Tasks"])
async def read_task(task_id: int, db: Session = Depends(get_db)):
    db_task = crud.get_task(db, task_id=task_id)
    if db_task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    return db_task


@app.put("/tasks/{task_id}", response_model=schemas.TaskResponse, tags=["Tasks"])
async def update_task(task_id: int, task: schemas.TaskUpdate, db: Session = Depends(get_db)):
    db_task = crud.update_task(db, task_id=task_id, task=task)
    if db_task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    return db_task


@app.delete("/tasks/{task_id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Tasks"])
async def delete_task(task_id: int, db: Session = Depends(get_db)):
    success = crud.delete_task(db, task_id=task_id)
    if not success:
        raise HTTPException(status_code=404, detail="Task not found")
    return {"ok": True}


@app.get("/users/{user_id}/tasks/", response_model=List[schemas.TaskResponse], tags=["Tasks"])
async def read_user_tasks(user_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")

    tasks = crud.get_user_tasks(db, user_id=user_id, skip=skip, limit=limit)
    return tasks


@app.get("/projects/{project_id}/tasks/", response_model=List[schemas.TaskResponse], tags=["Tasks"])
async def read_project_tasks(project_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    db_project = crud.get_project(db, project_id=project_id)
    if db_project is None:
        raise HTTPException(status_code=404, detail="Project not found")

    tasks = crud.get_project_tasks(db, project_id=project_id, skip=skip, limit=limit)
    return tasks


@app.get("/categories/{category_id}/tasks/", response_model=List[schemas.TaskResponse], tags=["Tasks"])
async def read_category_tasks(category_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    db_category = crud.get_category(db, category_id=category_id)
    if db_category is None:
        raise HTTPException(status_code=404, detail="Category not found")

    tasks = crud.get_category_tasks(db, category_id=category_id, skip=skip, limit=limit)
    return tasks


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)