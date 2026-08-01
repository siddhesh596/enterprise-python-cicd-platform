import os
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:postgres@localhost:5432/enterprise_db",
)

engine = create_engine(DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


def init_db() -> None:
    from app.fastapi_app.models.user import User  # noqa: F401
    from app.fastapi_app.models.product import Product  # noqa: F401
    from app.fastapi_app.models.order import Order  # noqa: F401

    Base.metadata.create_all(bind=engine)
