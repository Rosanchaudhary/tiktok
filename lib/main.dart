import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/controllers/auth_controller.dart';
import 'package:tiktok/views/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBCzPXNNz713b4Lbn5pk1x9myfAD1mIz-4", 
      appId: "1:493469859666:web:2466de02940ab203bf448b",
      messagingSenderId:  "493469859666",
      projectId: "tiktok-49317",
      ) 
  ).then((value) {
    Get.put(AuthController()); 
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
