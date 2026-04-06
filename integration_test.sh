#!/bin/bash
# Integration Testing Script for DormChef v2.0
# Run this on the deployed VM to verify all features work

set -e

API_BASE="http://localhost:8000"
PASS=0
FAIL=0

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "🍳 DormChef v2.0 Integration Test Suite"
echo "=========================================="
echo ""

# Helper functions
test_endpoint() {
    local name=$1
    local method=$2
    local endpoint=$3
    local data=$4
    local expected_status=$5

    echo -n "Testing: $name... "
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" "$API_BASE$endpoint")
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$API_BASE$endpoint")
    fi
    
    status_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$status_code" = "$expected_status" ]; then
        echo -e "${GREEN}✅ PASS${NC} (HTTP $status_code)"
        ((PASS++))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC} (Expected $expected_status, got $status_code)"
        echo "  Response: $body"
        ((FAIL++))
        return 1
    fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST SUITE 1: Appliances Management"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: Get all appliances
test_endpoint "Get all appliances" "GET" "/api/appliances" "" "200"

# Test 2: Create custom appliance
test_endpoint "Create custom appliance" "POST" "/api/appliances" \
    '{"name": "Test Grill", "description": "BBQ Grill"}' "200"

# Test 3: Create duplicate appliance (should fail)
test_endpoint "Reject duplicate appliance" "POST" "/api/appliances" \
    '{"name": "Test Grill", "description": "Duplicate"}' "400"

# Test 4: Get all appliances again (should include new one)
test_endpoint "Verify appliance added" "GET" "/api/appliances" "" "200"

# Test 5: Update custom appliance
test_endpoint "Update custom appliance" "PUT" "/api/appliances/7" \
    '{"name": "Updated Grill", "description": "Updated"}' "200"

# Test 6: Delete custom appliance
test_endpoint "Delete custom appliance" "DELETE" "/api/appliances/7" "" "200"

# Test 7: Try to delete default appliance (should fail)
test_endpoint "Reject delete default appliance" "DELETE" "/api/appliances/1" "" "400"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST SUITE 2: Recipe Generation (Multi-Appliance)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 8: Generate recipe with single appliance
test_endpoint "Generate recipe (1 appliance)" "POST" "/api/generate" \
    '{"ingredients": ["eggs", "bread"], "appliance_ids": [1]}' "200"

# Test 9: Generate recipe with multiple appliances
test_endpoint "Generate recipe (2 appliances)" "POST" "/api/generate" \
    '{"ingredients": ["rice", "water"], "appliance_ids": [1, 2]}' "200"

# Test 10: Generate recipe without appliances (should fail)
test_endpoint "Reject recipe without appliances" "POST" "/api/generate" \
    '{"ingredients": ["salt"], "appliance_ids": []}' "422"

# Test 11: Generate recipe without ingredients (should fail)
test_endpoint "Reject recipe without ingredients" "POST" "/api/generate" \
    '{"ingredients": [], "appliance_ids": [1]}' "422"

# Test 12: Generate recipe with invalid appliance ID (should fail)
test_endpoint "Reject invalid appliance ID" "POST" "/api/generate" \
    '{"ingredients": ["salt"], "appliance_ids": [9999]}' "400"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST SUITE 3: Recipe History"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 13: Get recipe history
test_endpoint "Get recipe history" "GET" "/api/recipes?limit=10" "" "200"

# Test 14: Get recipe history with pagination
test_endpoint "Get recipe history (paginated)" "GET" "/api/recipes?skip=0&limit=5" "" "200"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST SUITE 4: Health & Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 15: Health check
test_endpoint "Health check endpoint" "GET" "/health" "" "200"

# Test 16: API docs available
test_endpoint "OpenAPI documentation" "GET" "/docs" "" "200"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ Passed: $PASS${NC}"
echo -e "${RED}❌ Failed: $FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed! v2.0 is ready for deployment.${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Some tests failed. Please review above.${NC}"
    exit 1
fi
