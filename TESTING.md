# DormChef v2.0 - Manual E2E Testing Guide

## Pre-Test Requirements
- ✅ Application running on http://localhost:8000
- ✅ PostgreSQL database with seed data initialized
- ✅ Open Firefox/Chrome to http://localhost:8000
- ✅ Open browser Developer Tools (F12) for any console errors

---

## TEST 1: Frontend Initial Load

**Steps:**
1. Open browser to http://localhost:8000
2. Page should load without errors

**Verification:**
- ✅ Page title shows "🍳 DormChef"
- ✅ Header visible with logo and two toggle buttons (🌙 🌍)
- ✅ Two tabs visible: "🍳 Generate" and "⚙️ Appliances"
- ✅ No console errors (F12 > Console)

---

## TEST 2: Theme Toggle (Dark/Light Mode)

**Steps:**
1. Click moon icon (🌙) in header
2. Page should switch to dark mode
3. Click again (should now show ☀️)
4. Page should switch back to light mode
5. Refresh page (F5)

**Verification:**
- ✅ Dark mode: background dark, text light
- ✅ Light mode: background light, text dark
- ✅ Theme persists after refresh (via localStorage)
- ✅ All UI elements readable in both modes

---

## TEST 3: Language Toggle (i18n)

**Steps:**
1. Click language button (🌍 EN) in header
2. All UI text should change to Russian
3. Button should now show (🌍 RU)
4. Click again to switch back to English
5. Refresh page (F5)

**Verification:**
- ✅ "🍳 Generate" becomes "🍳 Генератор"
- ✅ "⚙️ Appliances" becomes "⚙️ Приборы"
- ✅ Placeholder texts change (e.g., "eggs, bread..." → Russian)
- ✅ Language persists after refresh (via localStorage)
- ✅ Error messages in correct language

---

## TEST 4: Appliances Management (CRUD)

**Steps:**

### 4.1 View Built-in Appliances
1. Click "⚙️ Appliances" tab
2. Scroll to "Built-in Appliances (Default)" section

**Verification:**
- ✅ Shows at least 6 default appliances (Microwave, Toaster, Air Fryer, etc.)
- ✅ Each marked with 🔒 icon and "Default" badge
- ✅ No edit/delete buttons (read-only)

### 4.2 Create Custom Appliance
1. Scroll to "Add Custom Appliance" form
2. Enter name: "Coffee Maker"
3. Enter description: "Brew coffee for studying"
4. Click "➕ Add Appliance"

**Verification:**
- ✅ Success message: "✅ Appliance added successfully!"
- ✅ New appliance appears under "Your Custom Appliances"
- ✅ Shows with 👤 badge and date added

### 4.3 Try to Create Duplicate
1. Try to add another "Coffee Maker" with different description
2. Click "➕ Add Appliance"

**Verification:**
- ✅ Error: "❌ Appliance name already exists"

### 4.4 Edit Custom Appliance
1. Find "Coffee Maker" in custom list
2. Click "✏️ Edit" button
3. Edit modal should appear
4. Change name to "Espresso Machine"
5. Change description to "Fast espresso shots"
6. Click "Save"

**Verification:**
- ✅ Modal appears with current values pre-filled
- ✅ Changes saved successfully
- ✅ List updates in real-time

### 4.5 Delete Custom Appliance
1. Click "🗑️ Delete" on "Espresso Machine"
2. Confirmation modal should appear
3. Click "Delete"

**Verification:**
- ✅ Confirmation modal shown
- ✅ Success message: "✅ Appliance deleted successfully!"
- ✅ Appliance removed from list

---

## TEST 5: Multi-Appliance Recipe Generation

**Steps:**

### 5.1 Switch to Generator Tab
1. Click "🍳 Generate" tab
2. Should see ingredients textarea and appliances checkboxes

**Verification:**
- ✅ Can see grid of appliance checkboxes
- ✅ Default appliances show first, then custom
- ✅ Each has name and "default" or "custom" badge

### 5.2 Generate Recipe with Single Appliance
1. Enter ingredients: "eggs, butter, bread"
2. Select only "Microwave" checkbox
3. Click "Generate Recipe ✨"

**Verification:**
- ✅ Loading spinner appears
- ✅ Recipe displays after 2-5 seconds
- ✅ Recipe has title, description, steps, time, difficulty
- ✅ Steps numbered and include duration
- ✅ Shows "Microwave" in history

### 5.3 Generate Recipe with Multiple Appliances
1. Clear previous selection
2. Enter ingredients: "rice, water, salt"
3. Select "Microwave" AND "Toaster" checkboxes
4. Click "Generate Recipe ✨"

**Verification:**
- ✅ Recipe generates with both appliances considered
- ✅ Recipe content uses both appliances creatively
- ✅ Both appliances shown as pills in history

### 5.4 Validation: No Appliances Selected
1. Clear appliances selection
2. Enter ingredients: "coffee"
3. Click "Generate Recipe ✨"

**Verification:**
- ✅ Error message: "❌ Please select at least one appliance"
- ✅ Recipe does NOT generate

### 5.5 Validation: No Ingredients
1. Select any appliance
2. Clear ingredients textarea
3. Click "Generate Recipe ✨"

**Verification:**
- ✅ Error message: "❌ Please enter at least one ingredient"
- ✅ Recipe does NOT generate

---

## TEST 6: Recipe History Display

**Steps:**
1. Scroll down to "📋 Recent Recipes" section
2. Should show recipes you just generated

**Verification:**
- ✅ Shows recent recipes in cards
- ✅ Each card shows: title, appliances (as pills), time, date
- ✅ Multiple recipes if you generated multiple
- ✅ Multi-appliance recipes show all appliances

---

## TEST 7: Persistence & Data Integrity

**Steps:**
1. Generate a recipe with multiple appliances
2. Add a custom appliance
3. Select dark mode + Russian language
4. Refresh page (F5)
5. Go to Appliances tab

**Verification:**
- ✅ Dark mode still active (theme persisted)
- ✅ Language still Russian (language persisted)
- ✅ Custom appliance still exists
- ✅ Recipe history still shows generated recipes
- ✅ All data persisted to database + localStorage

---

## TEST 8: Browser Compatibility

**Steps:**
1. Test in Firefox (if available)
2. Test in Chrome/Chromium
3. Test on mobile/tablet if possible

**Verification:**
- ✅ UI responsive on mobile (checkboxes stack vertically)
- ✅ Theme toggle works on both browsers
- ✅ Language toggle works on both browsers
- ✅ Recipe generation works consistently

---

## TEST 9: Error Handling

**Steps:**

### 9.1 Network Error Simulation
1. Go to Developer Tools (F12)
2. Network tab > Throttling > Offline
3. Try to generate recipe

**Verification:**
- ✅ Shows user-friendly error message
- ✅ No JavaScript console errors
- ✅ Page remains responsive

### 9.2 Invalid Data
1. Try opening browser console and sending invalid API request
2. E.g., `fetch('/api/generate', {method: 'POST', body: 'invalid'})`

**Verification:**
- ✅ API returns appropriate 4xx error
- ✅ Error message is clear

---

## TEST 10: API Contract Verification

**Via curl in terminal:**

```bash
# Test 1: Get appliances
curl http://localhost:8000/api/appliances | jq '.[0]'
# Should show: id, name, description, is_default, created_at

# Test 2: Generate with multi-appliance
curl -X POST http://localhost:8000/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "ingredients": ["salt", "pepper"],
    "appliance_ids": [1, 2]
  }' | jq '.appliances'
# Should show array of appliance objects

# Test 3: Get history
curl http://localhost:8000/api/recipes | jq '.[0].appliances'
# Should show appliances array (not single appliance string)
```

---

## TEST RESULTS SUMMARY

| Test # | Test Name | Status | Notes |
|--------|-----------|--------|-------|
| 1 | Frontend Initial Load | ✅/❌ | |
| 2 | Theme Toggle | ✅/❌ | |
| 3 | Language Toggle | ✅/❌ | |
| 4.1 | View Built-in Appliances | ✅/❌ | |
| 4.2 | Create Custom Appliance | ✅/❌ | |
| 4.3 | Duplicate Validation | ✅/❌ | |
| 4.4 | Edit Custom Appliance | ✅/❌ | |
| 4.5 | Delete Custom Appliance | ✅/❌ | |
| 5.1 | Appliance Checkbox UI | ✅/❌ | |
| 5.2 | Single Appliance Generation | ✅/❌ | |
| 5.3 | Multi-Appliance Generation | ✅/❌ | |
| 5.4 | Validation: No Appliances | ✅/❌ | |
| 5.5 | Validation: No Ingredients | ✅/❌ | |
| 6 | Recipe History Display | ✅/❌ | |
| 7 | Persistence & Data Integrity | ✅/❌ | |
| 8 | Browser Compatibility | ✅/❌ | |
| 9.1 | Network Error Handling | ✅/❌ | |
| 9.2 | API Error Handling | ✅/❌ | |
| 10 | API Contract | ✅/❌ | |

**Total Passed: ___/19**  
**Total Failed: ___/19**  

---

## Sign-Off

**Tester Name:** _________________  
**Date:** _________________  
**Browser:** _________________  
**Notes:** _________________

✅ All tests passed - Ready for production!  
⚠️ Some tests failed - See notes above
