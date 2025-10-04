import 'package:nutrimedai/features/food_scanner/domain/entities/detected_food.dart';
import 'package:nutrimedai/features/food_scanner/domain/entities/food_analysis.dart';

class FoodItem {
  final String id;
  final String userId;
  final List<DetectedFood> detectedFoods;
  final String imageUrl;
  final DateTime scannedAt;
  final FoodAnalysis? analysis;
  final String mealType; // breakfast, lunch, dinner, snack

  FoodItem({
    required this.id,
    required this.userId,
    required this.detectedFoods,
    required this.imageUrl,
    required this.scannedAt,
    this.analysis,
    this.mealType = 'snack',
  });

  // Total calories from all detected foods
  double get totalCalories =>
      detectedFoods.fold(0.0, (sum, food) => sum + food.calories);

  double get totalProtein =>
      detectedFoods.fold(0.0, (sum, food) => sum + food.protein);

  double get totalCarbs =>
      detectedFoods.fold(0.0, (sum, food) => sum + food.carbs);

  double get totalFat => detectedFoods.fold(0.0, (sum, food) => sum + food.fat);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'detectedFoods': detectedFoods.map((f) => f.toJson()).toList(),
      'imageUrl': imageUrl,
      'scannedAt': scannedAt.toIso8601String(),
      'analysis': analysis?.toJson(),
      'mealType': mealType,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      userId: json['userId'],
      detectedFoods: (json['detectedFoods'] as List)
          .map((f) => DetectedFood.fromJson(f))
          .toList(),
      imageUrl: json['imageUrl'],
      scannedAt: DateTime.parse(json['scannedAt']),
      analysis: json['analysis'] != null
          ? FoodAnalysis.fromJson(json['analysis'])
          : null,
      mealType: json['mealType'] ?? 'snack',
    );
  }
}
