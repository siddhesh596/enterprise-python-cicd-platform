# syntax=docker/dockerfile:1

############################
# Stage 1 - Build
############################
FROM python:3.12-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gcc && \
    rm -rf /var/lib/apt/lists/*

# Copy dependency file
COPY requirements.txt .

# Build Python wheels
RUN python -m pip install --upgrade pip && \
    pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt


############################
# Stage 2 - Runtime
############################
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000

WORKDIR /app

# Install curl for health checks
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd --system appgroup && \
    useradd --system --gid appgroup appuser

# Install dependencies from wheels
COPY --from=builder /wheels /wheels

RUN pip install --no-cache-dir /wheels/* && \
    rm -rf /wheels

# Copy application source
COPY . .

# Set ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 8000

# Container health check
HEALTHCHECK --interval=30s \
            --timeout=10s \
            --start-period=30s \
            --retries=3 \
CMD curl --fail http://localhost:8000/health || exit 1

# Start FastAPI
CMD ["uvicorn", "app.fastapi_app.main:app", "--host", "0.0.0.0", "--port", "8000"]