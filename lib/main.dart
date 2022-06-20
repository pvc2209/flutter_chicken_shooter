import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();

  runApp(
    MaterialApp(
      title: "Chicken Shooter CS",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}
