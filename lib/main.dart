import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resbook/models/task_data.dart';
import 'welcomescreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        home: WelcomeScreen(),
      ),
    );
  }
}
