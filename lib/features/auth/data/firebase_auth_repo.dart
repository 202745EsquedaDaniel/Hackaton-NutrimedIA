import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrimedai/features/auth/domain/entities/app_user.dart';
import 'package:nutrimedai/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // solo puse loginWithEmailPassword o otra de las otras y todo se genera solo
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      //  attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // fetch user document from firestore
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      //  create user from firestore data
      AppUser user = AppUser.fromJson(userDoc.data() as Map<String, dynamic>);

      //  return user
      return user;
    }
    // catch any errors...
    catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      //  attempt sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //  create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      //  save user to firestore
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());

      //  return user
      return user;
    }
    // catch any errors...
    catch (e) {
      throw Exception('Register failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    //  get current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;

    //  no user logged in..
    if (firebaseUser == null) {
      return null;
    }

    // fetch user document from firebase
    DocumentSnapshot userDoc = await firebaseFirestore
        .collection("users")
        .doc(firebaseUser.uid)
        .get();

    // check if user doc exists
    if (!userDoc.exists) {
      return null;
    }

    //  return user from firestore data
    return AppUser.fromJson(userDoc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> updateMedicalInfo({
    required String uid,
    required int age,
    required double weight,
    required double height,
    required List<String> diseases,
  }) async {
    try {
      await firebaseFirestore.collection('users').doc(uid).update({
        'age': age,
        'weight': weight,
        'height': height,
        'diseases': diseases,
        'medicalInfoCompleted': true,
      });
    } catch (e) {
      throw Exception('Error updating medical info: $e');
    }
  }
}
