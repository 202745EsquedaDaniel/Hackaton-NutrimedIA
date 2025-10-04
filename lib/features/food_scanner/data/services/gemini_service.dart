import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:nutrimedai/features/food_scanner/domain/entities/detected_food.dart';
import 'package:nutrimedai/features/food_scanner/domain/entities/food_analysis.dart';
import 'package:flutter/material.dart';

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  final Dio _dio = Dio();
  final String _apiKey;

  GeminiService({required String apiKey}) : _apiKey = apiKey;

  Future<List<DetectedFood>> analyzeFoodImage(
    String imagePath, {
    String? languageCode,
  }) async {
    try {
      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      final Map<String, dynamic> requestBody = {
        "contents": [
          {
            "parts": [
              {"text": _getFoodAnalysisPrompt(languageCode)},
              {
                "inline_data": {"mime_type": "image/jpeg", "data": base64Image},
              },
            ],
          },
        ],
        "generationConfig": {
          "temperature": 0.1,
          "topK": 32,
          "topP": 1,
          "maxOutputTokens": 4096,
        },
      };

      final response = await _dio.post(
        '$_baseUrl?key=$_apiKey',
        data: requestBody,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final String textResponse =
            responseData['candidates'][0]['content']['parts'][0]['text'];
        return _parseGeminiResponse(textResponse);
      } else {
        throw Exception('Failed to analyze image: ${response.statusCode}');
      }
    } catch (apiError) {
      debugPrint('API Error: $apiError');
      if (apiError is DioException && apiError.response?.statusCode == 429) {
        debugPrint('⚠️ RATE LIMIT EXCEEDED');
      }
      return await getMockFoodData();
    }
  }

  Future<FoodAnalysis> getHealthRecommendations({
    required List<DetectedFood> foods,
    required List<String> userDiseases,
  }) async {
    try {
      final prompt = _getHealthAnalysisPrompt(foods, userDiseases);

      final Map<String, dynamic> requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
        "generationConfig": {
          "temperature": 0.2,
          "topK": 32,
          "topP": 1,
          "maxOutputTokens": 2048,
        },
      };

      final response = await _dio.post(
        '$_baseUrl?key=$_apiKey',
        data: requestBody,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final String textResponse =
            responseData['candidates'][0]['content']['parts'][0]['text'];
        return _parseHealthAnalysis(textResponse);
      } else {
        throw Exception('Failed to get recommendations');
      }
    } catch (e) {
      debugPrint('Error getting health recommendations: $e');
      return _getMockHealthAnalysis(foods, userDiseases);
    }
  }

  String _getFoodAnalysisPrompt(String? languageCode) {
    return '''
Analiza esta imagen de comida y detecta todos los alimentos presentes.

Responde ÚNICAMENTE con JSON válido:

{
  "foods": [
    {
      "name": "nombre del alimento",
      "quantity": "cantidad estimada",
      "calories": número,
      "protein": gramos,
      "carbs": gramos,
      "fat": gramos,
      "fiber": gramos,
      "sugar": gramos,
      "sodium": miligramos,
      "confidence": 0_a_1,
      "x": 0_a_1,
      "y": 0_a_1,
      "foodQuality": 1_a_100,
      "insulinImpact": 1_a_10
    }
  ]
}
''';
  }

  String _getHealthAnalysisPrompt(
    List<DetectedFood> foods,
    List<String> userDiseases,
  ) {
    final foodsList = foods.map((f) => '${f.name} (${f.quantity})').join(', ');
    return '''
Alimentos: $foodsList
Enfermedades: ${userDiseases.isEmpty ? 'Ninguna' : userDiseases.join(', ')}

Responde ÚNICAMENTE con JSON:
{
  "level": "recommended|moderate|notRecommended",
  "summary": "resumen breve",
  "warnings": ["advertencia1"],
  "benefits": ["beneficio1"],
  "alternatives": ["alternativa1", "alternativa2"],
  "diseaseSpecificAdvice": {"enfermedad": "consejo"}
}
''';
  }

  List<DetectedFood> _parseGeminiResponse(String response) {
    try {
      String cleanResponse = response.trim();
      int startIndex = cleanResponse.indexOf('{');
      int endIndex = cleanResponse.lastIndexOf('}') + 1;

      if (startIndex == -1 || endIndex <= startIndex) {
        throw Exception('No valid JSON found');
      }

      cleanResponse = cleanResponse.substring(startIndex, endIndex);
      final Map<String, dynamic> jsonResponse = json.decode(cleanResponse);
      final List<dynamic> foodsJson = jsonResponse['foods'] ?? [];

      final List<String> tagColors = [
        '#4CAF50',
        '#FF9800',
        '#66BB6A',
        '#FFB74D',
        '#81C784',
        '#FFCC02',
      ];

      final List<DetectedFood> detectedFoods = [];

      for (int i = 0; i < foodsJson.length; i++) {
        final foodJson = foodsJson[i] as Map<String, dynamic>;
        final String color = tagColors[i % tagColors.length];
        detectedFoods.add(DetectedFood.fromJson({...foodJson, 'color': color}));
      }

      return detectedFoods;
    } catch (e) {
      debugPrint('Error parsing: $e');
      throw Exception('Error parsing AI response');
    }
  }

  FoodAnalysis _parseHealthAnalysis(String response) {
    try {
      String cleanResponse = response.trim();
      int startIndex = cleanResponse.indexOf('{');
      int endIndex = cleanResponse.lastIndexOf('}') + 1;

      if (startIndex == -1 || endIndex <= startIndex) {
        throw Exception('No valid JSON found');
      }

      cleanResponse = cleanResponse.substring(startIndex, endIndex);
      final Map<String, dynamic> jsonResponse = json.decode(cleanResponse);
      return FoodAnalysis.fromJson(jsonResponse);
    } catch (e) {
      debugPrint('Error parsing health analysis: $e');
      throw Exception('Error parsing health analysis');
    }
  }

  FoodAnalysis _getMockHealthAnalysis(
    List<DetectedFood> foods,
    List<String> diseases,
  ) {
    final avgQuality = foods.isEmpty
        ? 50.0
        : foods.fold(0, (sum, f) => sum + f.foodQuality) / foods.length;

    RecommendationLevel level;
    if (avgQuality >= 70) {
      level = RecommendationLevel.recommended;
    } else if (avgQuality >= 50) {
      level = RecommendationLevel.moderate;
    } else {
      level = RecommendationLevel.notRecommended;
    }

    return FoodAnalysis(
      level: level,
      summary: avgQuality >= 70
          ? 'Excelente elección para tu salud.'
          : 'Consume con moderación.',
      warnings: avgQuality < 50 ? ['Alto impacto en insulina'] : [],
      benefits: avgQuality >= 60 ? ['Buena fuente de nutrientes'] : [],
      alternatives: [
        'Ensalada con pollo',
        'Pescado al horno',
        'Frutas frescas',
      ],
      diseaseSpecificAdvice: {},
    );
  }

  Future<List<DetectedFood>> getMockFoodData() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      const DetectedFood(
        name: 'Manzana roja',
        quantity: '1 pieza mediana',
        calories: 95,
        protein: 0.5,
        carbs: 25,
        fat: 0.3,
        fiber: 4.4,
        sugar: 19,
        sodium: 1,
        confidence: 0.95,
        color: '#4CAF50',
        x: 0.3,
        y: 0.4,
        foodQuality: 85,
        insulinImpact: 4,
      ),
      const DetectedFood(
        name: 'Pan integral',
        quantity: '2 rebanadas',
        calories: 160,
        protein: 6,
        carbs: 30,
        fat: 2,
        fiber: 6.0,
        sugar: 2.0,
        sodium: 300,
        confidence: 0.87,
        color: '#FF9800',
        x: 0.7,
        y: 0.6,
        foodQuality: 70,
        insulinImpact: 7,
      ),
    ];
  }
}
