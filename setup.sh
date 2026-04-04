#!/bin/bash
# DormChef Quick Setup Script for Ubuntu 24.04
# Устанавливает зависимости и готовит окружение для запуска

set -e

echo "🍳 DormChef Setup Starting..."

# Check if Python 3.11+ is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.11+"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo "✓ Python $PYTHON_VERSION found"

# Check if venv module is available, install if not
if ! python3 -m venv --help &> /dev/null; then
    echo "📦 Installing python3-venv..."
    apt-get update -qq && apt-get install -y python3-venv > /dev/null 2>&1
fi

# Create virtual environment
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
else
    echo "✓ Virtual environment already exists"
fi

# Activate virtual environment
source venv/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip setuptools wheel -q

# Install Python dependencies
echo "📥 Installing Python dependencies..."
pip install -q -r backend/requirements.txt

# Check if PostgreSQL is available
if ! command -v psql &> /dev/null; then
    echo "⚠️  PostgreSQL client not found, but it can run in Docker"
    echo "    Run: docker pull postgres:16-alpine"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Create .env file: cp .env.example .env"
echo "2. Start PostgreSQL: docker run -d --name dormchef-pg -e POSTGRES_PASSWORD=dormchef -p 5432:5432 postgres:16-alpine"
echo "3. Run backend: source venv/bin/activate && python backend/main.py"
echo "4. Visit: http://localhost:8000"
