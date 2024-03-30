import 'package:flutter/material.dart';

import 'views/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Real-Time Audio 2 Text",
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
