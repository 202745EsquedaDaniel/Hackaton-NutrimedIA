class DetectedFood {
  final String name;
  final String quantity;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final double confidence;
  final String color;
  final double x;
  final double y;
  final int foodQuality; // 1-100
  final int insulinImpact; // 1-10

  const DetectedFood({
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.confidence,
    required this.color,
    required this.x,
    required this.y,
    required this.foodQuality,
    required this.insulinImpact,
  });

  factory DetectedFood.fromJson(Map<String, dynamic> json) {
    return DetectedFood(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      fiber: (json['fiber'] ?? 0).toDouble(),
      sugar: (json['sugar'] ?? 0).toDouble(),
      sodium: (json['sodium'] ?? 0).toDouble(),
      confidence: (json['confidence'] ?? 0).toDouble(),
      color: json['color'] ?? '#4CAF50',
      x: (json['x'] ?? 0.5).toDouble(),
      y: (json['y'] ?? 0.5).toDouble(),
      foodQuality: (json['foodQuality'] ?? 50).toInt(),
      insulinImpact: (json['insulinImpact'] ?? 5).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'confidence': confidence,
      'color': color,
      'x': x,
      'y': y,
      'foodQuality': foodQuality,
      'insulinImpact': insulinImpact,
    };
  }
}
