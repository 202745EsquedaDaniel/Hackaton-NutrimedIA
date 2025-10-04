import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutrimedai/app.dart';
import 'package:nutrimedai/firebase_options.dart';
export 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
