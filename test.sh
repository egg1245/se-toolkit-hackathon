#!/bin/bash
# DormChef Test Script
# Проверяет что API работает корректно - без задержек

API_URL="${1:-http://localhost:8000}"
TIMEOUT="${2:-30}"

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🧪 DormChef API Tests${NC}"
echo "API URL: $API_URL"
echo ""

# Test 1: Health check
echo -e "${YELLOW}[1/3] Health Check...${NC}"
if RESPONSE=$(curl -s -m "$TIMEOUT" "$API_URL/health" 2>/dev/null); then
    if echo "$RESPONSE" | grep -q "ok"; then
        echo -e "${GREEN}✓ PASS${NC}"
    else
        echo -e "${RED}✗ FAIL: Invalid response${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ FAIL: Cannot connect${NC}"
    exit 1
fi

# Test 2: Generate recipe
echo -e "${YELLOW}[2/3] Recipe Generation...${NC}"
if RESPONSE=$(curl -s -m "$TIMEOUT" -X POST "$API_URL/api/generate" \
    -H "Content-Type: application/json" \
    -d '{"ingredients":["eggs"],"appliance":"microwave"}' 2>/dev/null); then
    if echo "$RESPONSE" | grep -q '"title"'; then
        TITLE=$(echo "$RESPONSE" | grep -o '"title":"[^"]*"' | cut -d'"' -f4)
        echo -e "${GREEN}✓ PASS - Title: $TITLE${NC}"
    else
        echo -e "${RED}✗ FAIL: No recipe title${NC}"
        echo "$RESPONSE" | head -1
        exit 1
    fi
else
    echo -e "${RED}✗ FAIL: Timeout or connection error${NC}"
    exit 1
fi

# Test 3: Get recipe history
echo -e "${YELLOW}[3/3] Recipe History...${NC}"
if RESPONSE=$(curl -s -m "$TIMEOUT" "$API_URL/api/recipes?limit=1" 2>/dev/null); then
    if echo "$RESPONSE" | grep -q '\['; then
        COUNT=$(echo "$RESPONSE" | grep -o '"id"' | wc -l)
        echo -e "${GREEN}✓ PASS - Recipes: $COUNT${NC}"
    else
        echo -e "${RED}✗ FAIL: Invalid response${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ FAIL: Cannot fetch history${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ All tests passed!${NC}"
exit 0
