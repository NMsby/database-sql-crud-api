from sqlalchemy import Column, Integer, String, Text, Date, Enum, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
import enum

from .database import Base

# Enum classes for status and priority
class ProjectStatus(str, enum.Enum):
    NOT_STARTED = "Not Started"
    IN_PROGRESS = "In Progress"
    COMPLETED = "Completed"
    ON_HOLD = "On Hold"

class TaskStatus(str, enum.Enum):
    TO_DO = "To Do"
    IN_PROGRESS = "In Progress"
    COMPLETED = "Completed"
    DEFERRED = "Deferred"

class TaskPriority(str, enum.Enum):
    LOW = "Low"
    MEDIUM = "Medium"
    HIGH = "High"
    URGENT = "Urgent"

# Database models
class User(Base):
    __tablename__ = "users"

    user_id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    first_name = Column(String(50))
    last_name = Column(String(50))
    created_at = Column(TIMESTAMP, default=datetime.now)
    updated_at = Column(TIMESTAMP, default=datetime.now, onupdate=datetime.now)

    # Relationships
    projects = relationship("Project", back_populates="user")
    tasks = relationship("Task", back_populates="user")


class Category(Base):
    __tablename__ = "categories"

    category_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), unique=True, nullable=False)
    description = Column(Text)
    created_at = Column(TIMESTAMP, default=datetime.now)
    updated_at = Column(TIMESTAMP, default=datetime.now, onupdate=datetime.now)

    # Relationships
    tasks = relationship("Task", back_populates="category")


class Project(Base):
    __tablename__ = "projects"

    project_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    description = Column(Text)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    start_date = Column(Date)
    end_date = Column(Date)
    status = Column(Enum(ProjectStatus), default=ProjectStatus.NOT_STARTED)
    created_at = Column(TIMESTAMP, default=datetime.now)
    updated_at = Column(TIMESTAMP, default=datetime.now, onupdate=datetime.now)

    # Relationships
    user = relationship("User", back_populates="projects")
    tasks = relationship("Task", back_populates="project")


class Task(Base):
    __tablename__ = "tasks"

    task_id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    project_id = Column(Integer, ForeignKey("projects.project_id"), nullable=True)
    category_id = Column(Integer, ForeignKey("categories.category_id"), nullable=True)
    due_date = Column(Date)
    priority = Column(Enum(TaskPriority), default=TaskPriority.MEDIUM)
    status = Column(Enum(TaskStatus), default=TaskStatus.TO_DO)
    created_at = Column(TIMESTAMP, default=datetime.now)
    updated_at = Column(TIMESTAMP, default=datetime.now, onupdate=datetime.now)

    # Relationships
    user = relationship("User", back_populates="tasks")
    project = relationship("Project", back_populates="tasks")
    category = relationship("Category", back_populates="tasks")