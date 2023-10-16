import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground_app/widgets/graph/graph.dart';

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Playground'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: const Graph(
                  points: [
                    Offset(2, 2),
                    Offset(3, 3),
                    Offset(4, 5),
                    Offset(8, 3),
                    Offset(9, 12),
                  ],
                  drawAxes: true,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
