from sqlalchemy import Column, Integer, String, Float

from app.fastapi_app.database.session import Base


class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    price = Column(Float, nullable=False)
    sku = Column(String(100), unique=True, nullable=False)
