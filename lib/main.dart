import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plan_it/google_map_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBMwbGizSUC4HDwMSxvHmUzGmhXoO_yUOE",
      appId: "1:171832923506:android:d498bf620ec4c4a86fb9eb",
      messagingSenderId: "171832923506",
      projectId: "planit-649ff"
      )
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GoogleMapPage()
    );
  }
}
