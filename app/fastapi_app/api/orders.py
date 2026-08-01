from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session

from app.fastapi_app.database.session import SessionLocal
from app.fastapi_app.models.order import Order
from app.fastapi_app.schemas.order import OrderCreate, OrderResponse

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/orders", response_model=list[OrderResponse])
def list_orders(db: Session = Depends(get_db)):
    return db.query(Order).all()


@router.post("/orders", response_model=OrderResponse, status_code=201)
def create_order(payload: OrderCreate, db: Session = Depends(get_db)):
    order = Order(
        user_id=payload.user_id,
        product_id=payload.product_id,
        quantity=payload.quantity,
        total=payload.total,
    )
    db.add(order)
    db.commit()
    db.refresh(order)
    return order


@router.get("/orders/{order_id}", response_model=OrderResponse)
def get_order(order_id: int, db: Session = Depends(get_db)):
    order = db.query(Order).filter(Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return order
