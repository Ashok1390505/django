<<<<<<< HEAD
# --- Build Stage ---
FROM python:3.10-slim as base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy Django project
COPY webapp /app/webapp

# --- Final Stage ---
FROM python:3.10-slim

WORKDIR /app

COPY --from=base /app /app

WORKDIR /app/webapp

EXPOSE 8000

=======
# --- Builder stage ---
FROM python:3.11-slim as builder

WORKDIR /app

# Make sure requirements.txt exists in your build context
COPY requirements.txt .

# Build wheels to avoid re-downloading packages in final image
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

# --- Final stage ---
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy built wheels and requirements.txt from builder
COPY --from=builder /wheels /wheels
COPY --from=builder /app/requirements.txt .

# Install dependencies from wheels
RUN pip install --no-cache-dir --no-index --find-links=/wheels -r requirements.txt

# Copy your application code
COPY app/ .

# Run the application using Gunicorn
>>>>>>> 1f53b8b8091c0f3cb23ce2bc422d42a19dbf45dd
CMD ["gunicorn", "webapp.wsgi:application", "--bind", "0.0.0.0:8000"]
