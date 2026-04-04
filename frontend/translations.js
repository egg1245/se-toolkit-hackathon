// DormChef Translations (Russian & English)
const translations = {
    en: {
        // Header
        title: "🍳 DormChef",
        subtitle: "Generate personalized recipes with your ingredients and appliances",
        toggleDarkMode: "Toggle dark/light mode",
        toggleLanguage: "Switch language",
        
        // Tabs
        tabGenerate: "🍳 Generate",
        tabAppliances: "⚙️ Appliances",
        
        // Generator Section
        generateSection: "Create Your Recipe",
        ingredientsLabel: "Ingredients (comma-separated)",
        ingredientsPlaceholder: "e.g., eggs, bread, butter, cheese",
        ingredientsHint: "Enter ingredients you have available",
        appliancesLabel: "Kitchen Appliances (select at least 1)",
        generateBtn: "Generate Recipe ✨",
        applianceErrorMsg: "❌ Please select at least one appliance",
        
        // Messages
        enterIngredients: "Please enter at least one ingredient",
        selectAppliance: "Please select a kitchen appliance",
        generatingRecipe: "Generating your recipe...",
        recipeGenerated: "✅ Recipe generated successfully!",
        failedGenerate: "❌ Failed to generate recipe",
        
        // Recipe Display
        recipeTime: "Time",
        recipeDifficulty: "Difficulty",
        recipeServings: "Servings",
        ingredientsUsed: "Ingredients Used",
        instructions: "Instructions",
        step: "Step",
        tips: "💡 Tips:",
        saveRecipe: "💾 Saved",
        
        // Recipe History
        recentRecipes: "📋 Recent Recipes",
        noRecipes: "No recipes yet. Generate your first one!",
        
        // Appliances Management
        manageAppliances: "⚙️ Manage Appliances",
        addCustomAppliance: "➕ Add Custom Appliance",
        applianceName: "Appliance Name",
        applianceNamePlaceholder: "e.g., Coffee Maker, Slow Cooker",
        description: "Description (optional)",
        descriptionPlaceholder: "e.g., Brewing coffee",
        addBtn: "➕ Add Appliance",
        yourAppliances: "📋 Your Appliances",
        builtinAppliances: "Built-in Appliances (Default)",
        customAppliances: "Your Custom Appliances",
        noCustomAppliances: "No custom appliances yet.",
        defaultLabel: "Default",
        
        // CRUD Operations
        edit: "✏️ Edit",
        delete: "🗑️ Delete",
        editAppliance: "Edit Appliance",
        deleteAppliance: "Delete Appliance?",
        deleteConfirm: "This action cannot be undone.",
        save: "Save",
        cancel: "Cancel",
        appliances: "Appliances",
        
        // Success/Error Messages
        successCreate: "✅ Appliance added successfully!",
        successUpdate: "✅ Appliance updated successfully!",
        successDelete: "✅ Appliance deleted successfully!",
        errorDefault: "❌ Error: {error}",
        errorNameRequired: "❌ Please enter an appliance name",
        errorNameUnique: "❌ Appliance name already exists",
        errorLoadFailed: "❌ Failed to load appliances",
        errorNotFound: "❌ Appliance not found",
        
        // Footer
        footer: "🍳 DormChef v2.0 | Lab 9 Hackathon Project",
    },
    ru: {
        // Header
        title: "🍳 DormChef",
        subtitle: "Генерируйте персонализированные рецепты с вашими ингредиентами и приборами",
        toggleDarkMode: "Переключить ночной режим",
        toggleLanguage: "Переключить язык",
        
        // Tabs
        tabGenerate: "🍳 Генератор",
        tabAppliances: "⚙️ Приборы",
        
        // Generator Section
        generateSection: "Создайте ваш рецепт",
        ingredientsLabel: "Ингредиенты (разделенные запятыми)",
        ingredientsPlaceholder: "например: яйца, хлеб, масло, сыр",
        ingredientsHint: "Введите ингредиенты, которые у вас есть",
        appliancesLabel: "Кухонные приборы (выберите минимум 1)",
        generateBtn: "Генерировать рецепт ✨",
        applianceErrorMsg: "❌ Пожалуйста, выберите минимум один прибор",
        
        // Messages
        enterIngredients: "Пожалуйста, введите минимум один ингредиент",
        selectAppliance: "Пожалуйста, выберите кухонный прибор",
        generatingRecipe: "Генерируем ваш рецепт...",
        recipeGenerated: "✅ Рецепт успешно создан!",
        failedGenerate: "❌ Не удалось создать рецепт",
        
        // Recipe Display
        recipeTime: "Время",
        recipeDifficulty: "Сложность",
        recipeServings: "Порций",
        ingredientsUsed: "Использованные ингредиенты",
        instructions: "Инструкции",
        step: "Шаг",
        tips: "💡 Советы:",
        saveRecipe: "💾 Сохранено",
        
        // Recipe History
        recentRecipes: "📋 Недавние рецепты",
        noRecipes: "Нет рецептов. Создайте свой первый рецепт!",
        
        // Appliances Management
        manageAppliances: "⚙️ Управление приборами",
        addCustomAppliance: "➕ Добавить свой прибор",
        applianceName: "Название прибора",
        applianceNamePlaceholder: "например: Кофеварка, Мультиварка",
        description: "Описание (опционально)",
        descriptionPlaceholder: "например: Варка кофе",
        addBtn: "➕ Добавить прибор",
        yourAppliances: "📋 Ваши приборы",
        builtinAppliances: "Встроенные приборы (По умолчанию)",
        customAppliances: "Ваши пользовательские приборы",
        noCustomAppliances: "Нет пользовательских приборов.",
        defaultLabel: "По умолчанию",
        
        // CRUD Operations
        edit: "✏️ Изменить",
        delete: "🗑️ Удалить",
        editAppliance: "Изменить прибор",
        deleteAppliance: "Удалить прибор?",
        deleteConfirm: "Это действие невозможно отменить.",
        save: "Сохранить",
        cancel: "Отменить",
        appliances: "Приборы",
        
        // Success/Error Messages
        successCreate: "✅ Прибор успешно добавлен!",
        successUpdate: "✅ Прибор успешно обновлен!",
        successDelete: "✅ Прибор успешно удален!",
        errorDefault: "❌ Ошибка: {error}",
        errorNameRequired: "❌ Пожалуйста, введите название прибора",
        errorNameUnique: "❌ Это название прибора уже существует",
        errorLoadFailed: "❌ Не удалось загрузить приборы",
        errorNotFound: "❌ Прибор не найден",
        
        // Footer
        footer: "🍳 DormChef v2.0 | Проект Lab 9 Hackathon",
    }
};

// Get current language from localStorage or default to 'en'
function getCurrentLanguage() {
    return localStorage.getItem('dormchef-language') || 'en';
}

// Set language
function setLanguage(lang) {
    if (translations[lang]) {
        localStorage.setItem('dormchef-language', lang);
        return lang;
    }
    return 'en';
}

// Get translation string with optional substitution
function t(key, substitutions = {}) {
    const lang = getCurrentLanguage();
    let text = translations[lang][key] || translations['en'][key] || key;
    
    // Simple substitution support: {key} -> value
    Object.entries(substitutions).forEach(([k, v]) => {
        text = text.replace(`{${k}}`, v);
    });
    
    return text;
}
