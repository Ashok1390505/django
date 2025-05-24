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

CMD ["gunicorn", "webapp.wsgi:application", "--bind", "0.0.0.0:8000"]
