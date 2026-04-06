FROM python:3.11-slim

WORKDIR /app

# Skip apt-get update - use prebuilt base image
# Copy requirements first for better caching
COPY backend/requirements.txt .

# Install Python dependencies only (python:3.11-slim already has essentials)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY backend/ /app/backend/
COPY frontend/ /app/frontend/

# Set working directory to app root (for proper imports)
WORKDIR /app

# Set PYTHONPATH and environment variables
ENV PYTHONPATH=/app \
    PYTHONUNBUFFERED=1 \
    UVICORN_RELOAD=false

# Create startup script
RUN echo '#!/bin/bash\nset -e\ncd /app\nexec python -c "from backend.main import app; import uvicorn; uvicorn.run(app, host=\"0.0.0.0\", port=8000, reload=False)"' > /startup.sh && chmod +x /startup.sh

# Expose port
EXPOSE 8000

# Run startup script
CMD ["/startup.sh"]
