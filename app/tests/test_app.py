"""Tests for the Hello API service."""

import pytest
from main import app


@pytest.fixture
def client():
    """Create a test client for the Flask app."""
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_hello_returns_greeting(client):
    """GET /hello/<name> should return a JSON greeting."""
    response = client.get("/hello/Zaid")
    assert response.status_code == 200
    data = response.get_json()
    assert data == {"message": "Hello Zaid from Linkedin Learning"}


def test_hello_with_different_name(client):
    """GET /hello/<name> works with any name."""
    response = client.get("/hello/World")
    assert response.status_code == 200
    data = response.get_json()
    assert data == {"message": "Hello World from Linkedin Learning"}


def test_hello_content_type(client):
    """Response should be application/json."""
    response = client.get("/hello/Test")
    assert response.content_type == "application/json"


def test_health_check(client):
    """GET /health should return healthy status."""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.get_json()
    assert data == {"status": "healthy"}
