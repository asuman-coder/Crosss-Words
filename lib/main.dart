import 'package:flutter/material.dart';

import 'cross_word_widget.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Scaffold(
      body: Center(
        child: Text(
          // "Error\n${details.exception}",
          "Error\n something went wrong",
          style: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  };
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(
        title: 'Crossword Game',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: const CrosswordWidget(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
