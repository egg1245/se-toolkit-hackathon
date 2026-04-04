FROM python:3.11-slim

WORKDIR /app

# Update package lists and install system dependencies with Yandex mirrors
RUN apt-get update -o Acquire::ForceIPv4=true && \
    apt-get install -y -o Acquire::ForceIPv4=true --no-install-recommends \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY backend/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY backend/ /app/backend/
COPY frontend/ /app/frontend/

# Set working directory to backend
WORKDIR /app/backend

# Expose port
EXPOSE 8000

# Run uvicorn
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
