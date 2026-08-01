import os
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError

from app.fastapi_app.database.session import SessionLocal, init_db
from app.fastapi_app.api.users import router as users_router
from app.fastapi_app.api.products import router as products_router
from app.fastapi_app.api.orders import router as orders_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield


app = FastAPI(
    title="Enterprise Python CI/CD Platform API",
    version="1.0.0",
    description="Production-ready FastAPI CRUD API for enterprise deployments",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(users_router, prefix="/api/v1", tags=["users"])
app.include_router(products_router, prefix="/api/v1", tags=["products"])
app.include_router(orders_router, prefix="/api/v1", tags=["orders"])


@app.get("/health")
async def health_check():
    return {"status": "ok", "service": "enterprise-python-cicd-platform"}


@app.get("/database/health")
async def database_health():
    db = SessionLocal()
    try:
        db.execute(text("SELECT 1"))
        return {"status": "ok", "database": "reachable"}
    except SQLAlchemyError as exc:
        raise HTTPException(status_code=503, detail=str(exc)) from exc
    finally:
        db.close()


@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    return response
