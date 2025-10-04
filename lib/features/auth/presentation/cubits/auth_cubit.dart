/*

Auth Cubit: Statte Management

 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimedai/features/auth/domain/entities/app_user.dart';
import 'package:nutrimedai/features/auth/domain/repos/auth_repo.dart';
import 'package:nutrimedai/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  //  check if user is already authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  //  get current user
  AppUser? get currentUser => _currentUser;

  //  login with email + pw
  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, pw);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  //  register with email + pw
  Future<void> register(String name, String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassword(name, email, pw);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  //  logout
  Future<void> logout() async {
    authRepo.logout();
    emit(Unauthenticated());
  }

  //  update medical info
  Future<void> updateMedicalInfo({
    required int age,
    required double weight,
    required double height,
    required List<String> diseases,
  }) async {
    try {
      if (_currentUser == null) {
        emit(AuthError("No user logged in"));
        return;
      }

      emit(AuthLoading());

      // Update medical info in database
      await authRepo.updateMedicalInfo(
        uid: _currentUser!.uid,
        age: age,
        weight: weight,
        height: height,
        diseases: diseases,
      );

      // Update current user with new medical info
      _currentUser = _currentUser!.copyWith(
        age: age,
        weight: weight,
        height: height,
        diseases: diseases,
        medicalInfoCompleted: true,
      );

      emit(Authenticated(_currentUser!));
    } catch (e) {
      emit(AuthError(e.toString()));
      if (_currentUser != null) {
        emit(Authenticated(_currentUser!));
      } else {
        emit(Unauthenticated());
      }
    }
  }
}
