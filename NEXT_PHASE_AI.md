# 🤖 Próxima Fase: Integración de IA para Análisis de Alimentos

## 📦 Dependencias Adicionales Necesarias

Agregar a `pubspec.yaml`:

```yaml
dependencies:
  # Para captura de imágenes
  image_picker: ^1.0.7
  
  # Para Google ML Kit (reconocimiento de imágenes)
  google_ml_kit: ^0.16.3
  
  # Para compresión de imágenes
  image: ^4.1.7
  
  # Para integración con Gemini AI (recomendado)
  google_generative_ai: ^0.2.2
  
  # O alternativa: OpenAI
  # chat_gpt_sdk: ^2.2.5
```

## 🎯 Estructura Propuesta para Módulo de Alimentos

```
lib/
  features/
    food_scanner/
      domain/
        entities/
          food_item.dart           # Modelo de alimento
          nutrition_info.dart      # Información nutricional
          food_analysis.dart       # Análisis de IA
      data/
        repositories/
          food_repository.dart
          ai_analysis_repository.dart
      presentation/
        pages/
          camera_page.dart         # Captura de foto
          food_analysis_page.dart  # Resultados del análisis
        cubits/
          food_scanner_cubit.dart
```

## 📝 Modelo de Datos Sugerido

### food_item.dart
```dart
class FoodItem {
  final String id;
  final String userId;
  final String name;
  final String imageUrl;
  final NutritionInfo nutritionInfo;
  final DateTime scannedAt;
  final FoodAnalysis analysis;

  FoodItem({
    required this.id,
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.nutritionInfo,
    required this.scannedAt,
    required this.analysis,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl,
      'nutritionInfo': nutritionInfo.toJson(),
      'scannedAt': scannedAt.toIso8601String(),
      'analysis': analysis.toJson(),
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      nutritionInfo: NutritionInfo.fromJson(json['nutritionInfo']),
      scannedAt: DateTime.parse(json['scannedAt']),
      analysis: FoodAnalysis.fromJson(json['analysis']),
    );
  }
}
```

### nutrition_info.dart
```dart
class NutritionInfo {
  final double calories;
  final double carbohydrates; // gramos
  final double proteins; // gramos
  final double fats; // gramos
  final double sugar; // gramos
  final double sodium; // mg
  final double fiber; // gramos
  final double cholesterol; // mg

  NutritionInfo({
    required this.calories,
    required this.carbohydrates,
    required this.proteins,
    required this.fats,
    required this.sugar,
    required this.sodium,
    required this.fiber,
    required this.cholesterol,
  });

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'carbohydrates': carbohydrates,
      'proteins': proteins,
      'fats': fats,
      'sugar': sugar,
      'sodium': sodium,
      'fiber': fiber,
      'cholesterol': cholesterol,
    };
  }

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      calories: json['calories']?.toDouble() ?? 0.0,
      carbohydrates: json['carbohydrates']?.toDouble() ?? 0.0,
      proteins: json['proteins']?.toDouble() ?? 0.0,
      fats: json['fats']?.toDouble() ?? 0.0,
      sugar: json['sugar']?.toDouble() ?? 0.0,
      sodium: json['sodium']?.toDouble() ?? 0.0,
      fiber: json['fiber']?.toDouble() ?? 0.0,
      cholesterol: json['cholesterol']?.toDouble() ?? 0.0,
    );
  }
}
```

### food_analysis.dart
```dart
enum RecommendationLevel {
  recommended, // Verde - Recomendado
  moderate, // Amarillo - Con moderación
  notRecommended, // Rojo - No recomendado
}

class FoodAnalysis {
  final RecommendationLevel level;
  final String summary;
  final List<String> warnings; // Advertencias específicas
  final List<String> benefits; // Beneficios
  final List<String> alternatives; // Alternativas sugeridas
  final Map<String, String> diseaseSpecificAdvice; // Consejo por enfermedad

  FoodAnalysis({
    required this.level,
    required this.summary,
    required this.warnings,
    required this.benefits,
    required this.alternatives,
    required this.diseaseSpecificAdvice,
  });

  Map<String, dynamic> toJson() {
    return {
      'level': level.name,
      'summary': summary,
      'warnings': warnings,
      'benefits': benefits,
      'alternatives': alternatives,
      'diseaseSpecificAdvice': diseaseSpecificAdvice,
    };
  }

  factory FoodAnalysis.fromJson(Map<String, dynamic> json) {
    return FoodAnalysis(
      level: RecommendationLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => RecommendationLevel.moderate,
      ),
      summary: json['summary'] ?? '',
      warnings: List<String>.from(json['warnings'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      alternatives: List<String>.from(json['alternatives'] ?? []),
      diseaseSpecificAdvice: Map<String, String>.from(
        json['diseaseSpecificAdvice'] ?? {},
      ),
    );
  }
}
```

## 🧠 Ejemplo de Prompt para Gemini AI

```dart
String generateAnalysisPrompt(String foodName, List<String> userDiseases, NutritionInfo nutrition) {
  return '''
Analiza el siguiente alimento para un paciente con las siguientes condiciones médicas:

Alimento: $foodName

Información Nutricional:
- Calorías: ${nutrition.calories} kcal
- Carbohidratos: ${nutrition.carbohydrates}g
- Proteínas: ${nutrition.proteins}g
- Grasas: ${nutrition.fats}g
- Azúcares: ${nutrition.sugar}g
- Sodio: ${nutrition.sodium}mg
- Fibra: ${nutrition.fiber}g
- Colesterol: ${nutrition.cholesterol}mg

Condiciones médicas del paciente:
${userDiseases.join(', ')}

Por favor proporciona:
1. Un resumen breve (2-3 líneas) sobre si este alimento es recomendado, moderado o no recomendado
2. Lista de advertencias específicas para sus condiciones médicas
3. Lista de beneficios (si los hay)
4. 3-5 alternativas más saludables
5. Consejo específico para cada condición médica

Formato de respuesta en JSON:
{
  "level": "recommended|moderate|notRecommended",
  "summary": "texto del resumen",
  "warnings": ["advertencia 1", "advertencia 2"],
  "benefits": ["beneficio 1", "beneficio 2"],
  "alternatives": ["alternativa 1", "alternativa 2", "alternativa 3"],
  "diseaseSpecificAdvice": {
    "Diabetes tipo 2": "consejo específico",
    "Hipertensión": "consejo específico"
  }
}
''';
}
```

## 📸 Ejemplo de Flujo de Captura y Análisis

```dart
// En food_scanner_cubit.dart

Future<void> scanFood(XFile imageFile) async {
  try {
    emit(FoodScannerLoading());
    
    // 1. Subir imagen a Firebase Storage
    final imageUrl = await _storageRepo.uploadFoodImage(imageFile);
    
    // 2. Reconocer alimento con ML Kit o Gemini Vision
    final foodName = await _aiRepo.recognizeFood(imageFile);
    
    // 3. Obtener información nutricional (API o base de datos)
    final nutritionInfo = await _foodRepo.getNutritionInfo(foodName);
    
    // 4. Obtener perfil médico del usuario
    final userProfile = await _authRepo.getCurrentUser();
    
    // 5. Generar análisis con IA
    final analysis = await _aiRepo.analyzeFood(
      foodName: foodName,
      nutrition: nutritionInfo,
      diseases: userProfile.diseases ?? [],
    );
    
    // 6. Crear objeto FoodItem
    final foodItem = FoodItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userProfile.uid,
      name: foodName,
      imageUrl: imageUrl,
      nutritionInfo: nutritionInfo,
      scannedAt: DateTime.now(),
      analysis: analysis,
    );
    
    // 7. Guardar en Firestore
    await _foodRepo.saveFoodItem(foodItem);
    
    // 8. Emitir estado de éxito
    emit(FoodScannerSuccess(foodItem));
    
  } catch (e) {
    emit(FoodScannerError(e.toString()));
  }
}
```

## 🎨 UI Sugerida para Resultados

```dart
// En food_analysis_page.dart

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Análisis de Alimento')),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Imagen del alimento
          Image.network(foodItem.imageUrl),
          
          // Nombre del alimento
          Text(foodItem.name, style: TextStyle(fontSize: 24, bold)),
          
          // Nivel de recomendación (con color)
          RecommendationBadge(level: foodItem.analysis.level),
          
          // Resumen
          Card(child: Text(foodItem.analysis.summary)),
          
          // Información nutricional
          NutritionCard(nutrition: foodItem.nutritionInfo),
          
          // Advertencias
          if (foodItem.analysis.warnings.isNotEmpty)
            WarningsSection(warnings: foodItem.analysis.warnings),
          
          // Beneficios
          if (foodItem.analysis.benefits.isNotEmpty)
            BenefitsSection(benefits: foodItem.analysis.benefits),
          
          // Alternativas
          AlternativesSection(alternatives: foodItem.analysis.alternatives),
          
          // Consejo específico por enfermedad
          DiseaseAdviceSection(advice: foodItem.analysis.diseaseSpecificAdvice),
        ],
      ),
    ),
  );
}
```

## 🔑 Variables de Entorno

Crear archivo `.env` (no subir a git):
```
GEMINI_API_KEY=tu_api_key_aqui
# O
OPENAI_API_KEY=tu_api_key_aqui
```

## 📊 Estructura de Firebase Firestore

```
/users/{userId}
  - [datos del usuario actual]

/scanned_foods/{foodId}
  - userId: string
  - name: string
  - imageUrl: string
  - nutritionInfo: object
  - analysis: object
  - scannedAt: timestamp

/foods_database/{foodName}  (opcional - caché de alimentos conocidos)
  - name: string
  - nutritionInfo: object
  - lastUpdated: timestamp
```

## ✅ Checklist de Implementación Siguiente Fase

- [ ] Instalar dependencias de imagen e IA
- [ ] Crear modelos de datos (FoodItem, NutritionInfo, FoodAnalysis)
- [ ] Implementar captura de cámara
- [ ] Integrar Gemini AI o Google Vision API
- [ ] Crear lógica de análisis nutricional
- [ ] Diseñar UI de resultados
- [ ] Implementar guardado en Firestore
- [ ] Crear historial de alimentos escaneados
- [ ] Agregar estadísticas y dashboard

## 🎯 APIs Recomendadas

1. **Google Gemini AI** (Recomendado)
   - Análisis de imágenes
   - Generación de recomendaciones
   - https://ai.google.dev/

2. **Nutritionix API**
   - Base de datos nutricional
   - https://www.nutritionix.com/business/api

3. **USDA FoodData Central**
   - Gratis
   - https://fdc.nal.usda.gov/api-guide.html
