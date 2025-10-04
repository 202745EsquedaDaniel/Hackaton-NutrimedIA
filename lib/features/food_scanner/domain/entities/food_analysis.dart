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
