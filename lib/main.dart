import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          // Add your own Firebase project configuration from google-services.json
          apiKey: "AIzaSyCXv853Mgw84D7KKffEXrpqpMUAZ5tS5BY", // api_key
          appId:
              "1:572383202862:android:30733bd3c5ac1f664059bf", // mobilesdk_app_id
          messagingSenderId: "572383202862", // project_number
          projectId: "idn-attendence-app" // project_id
          ),
    );
    // Firebase connection success
    print("Firebase Terhubung ke:");
    print("API Key: ${Firebase.app().options.apiKey}");
    print("Project ID: ${Firebase.app().options.projectId}");
  } catch (e) {
    // Firebase connection failed
    print("Firebase gagal terhubung: $e");
  }
  // runApp(const HomeScreen());
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  // Main App
  const TestApp({super.key}); // Constructor of TestApp clas

  @override // can give information about about your missing override code
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove debug banner
      home: const HomeScreen(), // HomeScreen class
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50, // Header
            child: Placeholder(),
          ),
          Expanded(
            child: Placeholder(), // Content
          ),
          SizedBox(
            height: 50, // Footer
            child: Placeholder(),
          ),
        ],
      ),
    );
  }
}