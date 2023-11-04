import 'package:edtech/user/courseDetail.dart';
import 'package:edtech/user/eduPoint.dart';
import 'package:edtech/user/home.dart';
import 'package:edtech/login/login.dart';
import 'package:edtech/login/register.dart';
import 'package:edtech/user/profile.dart';
import 'package:edtech/user/quiz.dart';
import 'package:edtech/user/result.dart';
import 'package:edtech/user/unlockedCourse.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainPageUiWidget(mykad: '010203040506'),
      
    );
  }
}
