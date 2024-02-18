import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground_app/render_objects/custom_fill_sliver_ro_screen.dart';

import 'libraries/local_auth_button_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CustomFillSliverRoScreen(),
    );
  }
}
