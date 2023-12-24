import 'package:flutter/material.dart';
import 'package:quotes_generator/view/home_screen.dart';

void main() {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ));
  }catch(e)
  {
    print(e.toString());
  }
}


