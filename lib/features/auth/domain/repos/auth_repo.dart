/*

Auth Repository - Outlines the possible auth operations for this App.

*/

import 'package:nutrimedai/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  );
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<void> updateMedicalInfo({
    required String uid,
    required int age,
    required double weight,
    required double height,
    required List<String> diseases,
  });
}
