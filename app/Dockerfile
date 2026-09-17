# ---------- Build stage ----------
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---------- Runtime stage ----------
FROM python:3.12-slim

LABEL maintainer="Zaid"
LABEL description="Hello API - A greeting service for Linkedin Learning"

# Non-root user for security
RUN adduser --disabled-password --no-create-home appuser

WORKDIR /app

COPY --from=builder /install /usr/local
COPY . .

USER appuser

EXPOSE 8989

# Use gunicorn for production-grade serving
CMD ["gunicorn", "--bind", "0.0.0.0:8989", "--workers", "2", "--access-logfile", "-", "main:app"]
