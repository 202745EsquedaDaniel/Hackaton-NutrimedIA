// Constantes de la aplicación NutrimedIA
library;

class AppConstants {
  // Lista de enfermedades soportadas
  static const List<String> supportedDiseases = [
    'Diabetes tipo 1',
    'Diabetes tipo 2',
    'Hipertensión',
    'Enfermedades del corazón',
    'Colesterol alto',
    'Obesidad',
    'Enfermedad renal',
    'Enfermedad hepática',
    'Celiaquía',
    'Intolerancia a la lactosa',
    'Anemia',
    'Hipotiroidismo',
    'Hipertiroidismo',
    'Gota',
    'Ninguna',
  ];

  // Rangos de valores normales (para futuras validaciones)
  static const int minAge = 1;
  static const int maxAge = 120;
  static const double minWeight = 20.0; // kg
  static const double maxWeight = 300.0; // kg
  static const double minHeight = 50.0; // cm
  static const double maxHeight = 250.0; // cm

  // Mensajes de error
  static const String errorEmptyFields = 'Por favor completa todos los campos';
  static const String errorInvalidAge = 'Edad inválida';
  static const String errorInvalidWeight = 'Peso inválido';
  static const String errorInvalidHeight = 'Altura inválida';
  static const String errorNoDiseaseSelected =
      'Por favor selecciona al menos una opción';

  // Mensajes de éxito
  static const String successMedicalInfoSaved =
      'Información médica guardada exitosamente';

  // Colecciones de Firestore
  static const String usersCollection = 'users';
  static const String foodsCollection = 'foods'; // Para futuro uso
  static const String scannedFoodsCollection =
      'scanned_foods'; // Para futuro uso
}
