import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

final gradientColors = [
  Colors.black,
  Colors.transparent,
  Colors.transparent,
  Colors.black
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance Test',
      showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(
        // child: PerformanceTestPage(
        //   gradientColors: gradientColors,
        // ),
        builder: () => PerformanceTestPage(
          gradientColors: gradientColors,
        ),
      ),
    );
  }
}

class PerformanceTestPage extends StatelessWidget {
  const PerformanceTestPage({required this.gradientColors, super.key});

  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        return Row(
          children: List.generate(
            5,
            (index) => ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: gradientColors,
                stops: const [0.0, 0.1, 0.9, 1.0],
              ).createShader(bounds),
              child: Opacity(
                opacity: 0.9,
                child: Opacity(
                  opacity: 0.9,
                  child: Opacity(
                    opacity: 0.9,
                    child: Opacity(
                      opacity: 0.9,
                      child: Opacity(
                        opacity: 0.9,
                        child: Opacity(
                          opacity: 0.9,
                          child: Opacity(
                            opacity: 0.9,
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
    // required this.child,
    required this.builder,
  });
  // final Widget child;
  final Widget Function() builder;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Stream.periodic(const Duration(milliseconds: 100)).listen((_) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: widget.child,
      body: widget.builder(),
    );
  }
}
