#!/bin/bash
# DormChef Test Script
# Проверяет что API работает корректно

set -e

API_URL="${1:-http://localhost:8000}"

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🧪 DormChef API Tests${NC}"
echo "Testing API at: $API_URL"
echo ""

# Test 1: Health check
echo -e "${YELLOW}Test 1: Health Check${NC}"
RESPONSE=$(curl -s "$API_URL/health")
if echo "$RESPONSE" | grep -q "ok"; then
    echo -e "${GREEN}✓ PASS: Health check${NC}"
else
    echo -e "${RED}✗ FAIL: Health check${NC}"
    echo "Response: $RESPONSE"
    exit 1
fi

echo ""

# Test 2: Generate recipe
echo -e "${YELLOW}Test 2: Recipe Generation${NC}"
RESPONSE=$(curl -s -X POST "$API_URL/api/generate" \
    -H "Content-Type: application/json" \
    -d '{
        "ingredients": ["eggs", "bread"],
        "appliance": "toaster"
    }')

if echo "$RESPONSE" | grep -q "title"; then
    echo -e "${GREEN}✓ PASS: Recipe generated${NC}"
    echo "Recipe: $(echo "$RESPONSE" | grep -o '"title":"[^"]*"')"
else
    echo -e "${RED}✗ FAIL: Recipe generation${NC}"
    echo "Response: $RESPONSE"
    exit 1
fi

echo ""

# Test 3: Get recipe history
echo -e "${YELLOW}Test 3: Recipe History${NC}"
RESPONSE=$(curl -s "$API_URL/api/recipes?limit=1")
if echo "$RESPONSE" | grep -q "\["; then
    echo -e "${GREEN}✓ PASS: Recipe history retrieved${NC}"
    COUNT=$(echo "$RESPONSE" | grep -o '"id"' | wc -l)
    echo "Recipes in database: $COUNT"
else
    echo -e "${RED}✗ FAIL: Recipe history${NC}"
    echo "Response: $RESPONSE"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ All tests passed!${NC}"
