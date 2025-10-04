import 'package:nutrimedai/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    super.age,
    super.weight,
    super.height,
    super.diseases,
    super.medicalInfoCompleted,
    required this.bio,
    required this.profileImageUrl,
  });

  //  method to update user profile
  @override
  ProfileUser copyWith({
    String? uid,
    String? email,
    String? name,
    int? age,
    double? weight,
    double? height,
    List<String>? diseases,
    bool? medicalInfoCompleted,
    String? newBio,
    String? newProfileImageUrl,
  }) {
    return ProfileUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      diseases: diseases ?? this.diseases,
      medicalInfoCompleted: medicalInfoCompleted ?? this.medicalInfoCompleted,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
    );
  }

  // convert profile user -> json
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({'bio': bio, 'profileImageUrl': profileImageUrl});
    return json;
  }

  // convert json -> profile user
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      age: json['age'],
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      diseases: json['diseases'] != null
          ? List<String>.from(json['diseases'])
          : null,
      medicalInfoCompleted: json['medicalInfoCompleted'] ?? false,
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
