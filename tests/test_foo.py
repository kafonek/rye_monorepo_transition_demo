from app.main import app
from foo import hello


def test_foo():
    with app.test_client() as client:
        response = client.get("/foo")
        assert response.text == hello()
