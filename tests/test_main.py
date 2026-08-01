from fastapi.testclient import TestClient

from app.fastapi_app.main import app

client = TestClient(app)


def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_database_health():
    response = client.get("/database/health")
    assert response.status_code in {200, 503}
