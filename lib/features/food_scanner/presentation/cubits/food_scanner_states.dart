import 'package:nutrimedai/features/food_scanner/domain/entities/detected_food.dart';
import 'package:nutrimedai/features/food_scanner/domain/entities/food_item.dart';

abstract class FoodScannerState {}

class FoodScannerInitial extends FoodScannerState {}

class FoodScannerLoading extends FoodScannerState {}

class FoodScannerSuccess extends FoodScannerState {
  final List<DetectedFood> detectedFoods;
  final String imagePath;

  FoodScannerSuccess({required this.detectedFoods, required this.imagePath});
}

class FoodAnalysisComplete extends FoodScannerState {
  final FoodItem foodItem;

  FoodAnalysisComplete(this.foodItem);
}

class FoodScannerSaved extends FoodScannerState {
  final FoodItem foodItem;

  FoodScannerSaved(this.foodItem);
}

class FoodScannerError extends FoodScannerState {
  final String message;

  FoodScannerError(this.message);
}

class DailyMealsLoading extends FoodScannerState {}

class DailyMealsLoaded extends FoodScannerState {
  final List<FoodItem> meals;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  DailyMealsLoaded({
    required this.meals,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });
}
