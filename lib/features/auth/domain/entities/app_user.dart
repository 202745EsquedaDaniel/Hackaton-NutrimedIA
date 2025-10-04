class AppUser {
  final String uid;
  final String email;
  final String name;
  final int? age;
  final double? weight; // en kg
  final double? height; // en cm
  final List<String>? diseases; // enfermedades del usuario
  final bool medicalInfoCompleted; // indica si completó el formulario médico

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.age,
    this.weight,
    this.height,
    this.diseases,
    this.medicalInfoCompleted = false,
  });

  //  convert app user -> json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'diseases': diseases,
      'medicalInfoCompleted': medicalInfoCompleted,
    };
  }

  //  convert json -> app user
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
      age: jsonUser['age'],
      weight: jsonUser['weight']?.toDouble(),
      height: jsonUser['height']?.toDouble(),
      diseases: jsonUser['diseases'] != null
          ? List<String>.from(jsonUser['diseases'])
          : null,
      medicalInfoCompleted: jsonUser['medicalInfoCompleted'] ?? false,
    );
  }

  // Método para copiar el usuario con nuevos datos
  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    int? age,
    double? weight,
    double? height,
    List<String>? diseases,
    bool? medicalInfoCompleted,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      diseases: diseases ?? this.diseases,
      medicalInfoCompleted: medicalInfoCompleted ?? this.medicalInfoCompleted,
    );
  }
}
