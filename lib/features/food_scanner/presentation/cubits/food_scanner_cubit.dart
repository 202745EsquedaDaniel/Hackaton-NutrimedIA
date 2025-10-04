import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimedai/core/constants/api_constants.dart';
import 'package:nutrimedai/features/auth/domain/entities/app_user.dart';
import 'package:nutrimedai/features/food_scanner/data/services/gemini_service.dart';
import 'package:nutrimedai/features/food_scanner/domain/entities/detected_food.dart';
import 'package:nutrimedai/features/food_scanner/domain/entities/food_item.dart';
import 'package:nutrimedai/features/food_scanner/presentation/cubits/food_scanner_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FoodScannerCubit extends Cubit<FoodScannerState> {
  final GeminiService _geminiService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  FoodScannerCubit()
    : _geminiService = GeminiService(apiKey: ApiConstants.geminiApiKey),
      super(FoodScannerInitial());

  Future<void> scanFood(String imagePath, AppUser user) async {
    try {
      emit(FoodScannerLoading());

      // 1. Analyze image with Gemini AI
      final detectedFoods = await _geminiService.analyzeFoodImage(
        imagePath,
        languageCode: 'es',
      );

      if (detectedFoods.isEmpty) {
        emit(FoodScannerError('No se detectaron alimentos en la imagen'));
        return;
      }

      // 2. Get health recommendations based on user diseases
      final analysis = await _geminiService.getHealthRecommendations(
        foods: detectedFoods,
        userDiseases: user.diseases ?? [],
      );

      // 3. Upload image to Firebase Storage
      final imageUrl = await _uploadImage(imagePath, user.uid);

      // 4. Create FoodItem
      final foodItem = FoodItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        detectedFoods: detectedFoods,
        imageUrl: imageUrl,
        scannedAt: DateTime.now(),
        analysis: analysis,
        mealType: _determineMealType(),
      );

      emit(FoodAnalysisComplete(foodItem));
    } catch (e) {
      emit(FoodScannerError('Error al analizar: $e'));
    }
  }

  Future<void> saveFoodItem(FoodItem foodItem) async {
    try {
      await _firestore
          .collection('scanned_foods')
          .doc(foodItem.id)
          .set(foodItem.toJson());

      emit(FoodScannerSaved(foodItem));

      // Reload today's meals
      await loadTodayMeals(foodItem.userId);
    } catch (e) {
      emit(FoodScannerError('Error al guardar: $e'));
    }
  }

  Future<void> loadTodayMeals(String userId) async {
    try {
      emit(DailyMealsLoading());

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('scanned_foods')
          .where('userId', isEqualTo: userId)
          .where(
            'scannedAt',
            isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
          )
          .where('scannedAt', isLessThan: endOfDay.toIso8601String())
          .orderBy('scannedAt', descending: false)
          .get();

      final meals = snapshot.docs
          .map((doc) => FoodItem.fromJson(doc.data()))
          .toList();

      double totalCalories = 0;
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFat = 0;

      for (var meal in meals) {
        totalCalories += meal.totalCalories;
        totalProtein += meal.totalProtein;
        totalCarbs += meal.totalCarbs;
        totalFat += meal.totalFat;
      }

      emit(
        DailyMealsLoaded(
          meals: meals,
          totalCalories: totalCalories,
          totalProtein: totalProtein,
          totalCarbs: totalCarbs,
          totalFat: totalFat,
        ),
      );
    } catch (e) {
      emit(FoodScannerError('Error al cargar comidas: $e'));
    }
  }

  Future<String> _uploadImage(String imagePath, String userId) async {
    try {
      final file = File(imagePath);
      final fileName =
          'food_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child(fileName);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  String _determineMealType() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'breakfast';
    if (hour < 16) return 'lunch';
    if (hour < 20) return 'dinner';
    return 'snack';
  }
}
