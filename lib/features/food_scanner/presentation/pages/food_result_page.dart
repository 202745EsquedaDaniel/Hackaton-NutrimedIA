import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimedai/features/food_scanner/domain/entities/food_analysis.dart';
import 'package:nutrimedai/features/food_scanner/domain/entities/food_item.dart';
import 'package:nutrimedai/features/food_scanner/presentation/cubits/food_scanner_cubit.dart';
import 'package:nutrimedai/features/food_scanner/presentation/cubits/food_scanner_states.dart';

class FoodResultPage extends StatelessWidget {
  final FoodItem foodItem;

  const FoodResultPage({super.key, required this.foodItem});

  Color _getLevelColor(RecommendationLevel level) {
    switch (level) {
      case RecommendationLevel.recommended:
        return Colors.green;
      case RecommendationLevel.moderate:
        return Colors.orange;
      case RecommendationLevel.notRecommended:
        return Colors.red;
    }
  }

  String _getLevelText(RecommendationLevel level) {
    switch (level) {
      case RecommendationLevel.recommended:
        return 'Recomendado';
      case RecommendationLevel.moderate:
        return 'Moderación';
      case RecommendationLevel.notRecommended:
        return 'No Recomendado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado del Análisis'),
        centerTitle: true,
      ),
      body: BlocListener<FoodScannerCubit, FoodScannerState>(
        listener: (context, state) {
          if (state is FoodScannerSaved) {
            Navigator.popUntil(context, (route) => route.isFirst);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('¡Alimento guardado exitosamente!')),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image
              Image.network(
                foodItem.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, size: 50),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Detected foods
                    const Text(
                      'Alimentos Detectados',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...foodItem.detectedFoods.map(
                      (food) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                food.quantity,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildNutrientChip(
                                    '${food.calories.toInt()} kcal',
                                    Colors.orange,
                                  ),
                                  _buildNutrientChip(
                                    'P: ${food.protein.toInt()}g',
                                    Colors.blue,
                                  ),
                                  _buildNutrientChip(
                                    'C: ${food.carbs.toInt()}g',
                                    Colors.green,
                                  ),
                                  _buildNutrientChip(
                                    'G: ${food.fat.toInt()}g',
                                    Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Totals
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Nutricional',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Calorías: ${foodItem.totalCalories.toInt()} kcal',
                            ),
                            Text(
                              'Proteínas: ${foodItem.totalProtein.toInt()}g',
                            ),
                            Text(
                              'Carbohidratos: ${foodItem.totalCarbs.toInt()}g',
                            ),
                            Text('Grasas: ${foodItem.totalFat.toInt()}g'),
                          ],
                        ),
                      ),
                    ),

                    if (foodItem.analysis != null) ...[
                      const SizedBox(height: 20),

                      // Recommendation level
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getLevelColor(
                            foodItem.analysis!.level,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getLevelColor(foodItem.analysis!.level),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              foodItem.analysis!.level ==
                                      RecommendationLevel.recommended
                                  ? Icons.check_circle
                                  : foodItem.analysis!.level ==
                                        RecommendationLevel.moderate
                                  ? Icons.warning
                                  : Icons.cancel,
                              color: _getLevelColor(foodItem.analysis!.level),
                              size: 30,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getLevelText(foodItem.analysis!.level),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _getLevelColor(
                                        foodItem.analysis!.level,
                                      ),
                                    ),
                                  ),
                                  Text(foodItem.analysis!.summary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Warnings
                      if (foodItem.analysis!.warnings.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          title: 'Advertencias',
                          items: foodItem.analysis!.warnings,
                          icon: Icons.warning,
                          color: Colors.orange,
                        ),
                      ],

                      // Benefits
                      if (foodItem.analysis!.benefits.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          title: 'Beneficios',
                          items: foodItem.analysis!.benefits,
                          icon: Icons.favorite,
                          color: Colors.green,
                        ),
                      ],

                      // Alternatives
                      if (foodItem.analysis!.alternatives.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          title: 'Alternativas Sugeridas',
                          items: foodItem.analysis!.alternatives,
                          icon: Icons.lightbulb,
                          color: Colors.blue,
                        ),
                      ],
                    ],

                    const SizedBox(height: 30),

                    // Save button
                    ElevatedButton(
                      onPressed: () {
                        context.read<FoodScannerCubit>().saveFoodItem(foodItem);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(18),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Guardar Alimento',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientChip(String text, Color color) {
    return Chip(
      label: Text(text, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withOpacity(0.2),
      side: BorderSide.none,
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 28, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: color)),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
