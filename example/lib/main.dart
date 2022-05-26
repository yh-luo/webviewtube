import 'package:flutter/material.dart';

import 'customized_player.dart';
import 'default_player.dart';
import 'webviewtube_decorated_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webviewtube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebviewtubeDemo(),
    );
  }
}

class WebviewtubeDemo extends StatelessWidget {
  const WebviewtubeDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webviewtube Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: <Widget>[
          const DefaultPlayer(),
          const SizedBox(height: 70),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const WebviewtubeDecoratedPlayer()));
            },
            child: const Text(
              'Webviewtube Decorated Player',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CustomizedPlayer()));
            },
            child: const Text(
              'Customized Player',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
