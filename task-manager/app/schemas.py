from pydantic import BaseModel, EmailStr, Field
from typing import List, Optional
from datetime import date, datetime

from .models import ProjectStatus, TaskStatus, TaskPriority


# User schemas
class UserBase(BaseModel):
    username: str
    email: EmailStr
    first_name: Optional[str] = None
    last_name: Optional[str] = None


class UserCreate(UserBase):
    password: str


class UserUpdate(BaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None


class UserResponse(UserBase):
    user_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
        from_attributes = True


# Category schemas
class CategoryBase(BaseModel):
    name: str
    description: Optional[str] = None


class CategoryCreate(CategoryBase):
    pass


class CategoryUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None


class CategoryResponse(CategoryBase):
    category_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
        from_attributes = True


# Project schemas
class ProjectBase(BaseModel):
    name: str
    description: Optional[str] = None
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    status: Optional[ProjectStatus] = ProjectStatus.NOT_STARTED


class ProjectCreate(ProjectBase):
    user_id: int


class ProjectUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    status: Optional[ProjectStatus] = None


class ProjectResponse(ProjectBase):
    project_id: int
    user_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
        from_attributes = True


# Task schemas
class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    project_id: Optional[int] = None
    category_id: Optional[int] = None
    due_date: Optional[date] = None
    priority: Optional[TaskPriority] = TaskPriority.MEDIUM
    status: Optional[TaskStatus] = TaskStatus.TO_DO


class TaskCreate(TaskBase):
    user_id: int


class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    project_id: Optional[int] = None
    category_id: Optional[int] = None
    due_date: Optional[date] = None
    priority: Optional[TaskPriority] = None
    status: Optional[TaskStatus] = None


class TaskResponse(TaskBase):
    task_id: int
    user_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
        from_attributes = True
