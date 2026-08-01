from pydantic import BaseModel, Field


class ProductCreate(BaseModel):
    name: str = Field(..., min_length=2, max_length=200)
    price: float = Field(..., gt=0)
    sku: str = Field(..., min_length=2, max_length=100)


class ProductResponse(BaseModel):
    id: int
    name: str
    price: float
    sku: str
