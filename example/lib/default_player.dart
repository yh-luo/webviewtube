import 'package:flutter/material.dart';

import 'package:webviewtube/webviewtube.dart';

class DefaultPlayer extends StatelessWidget {
  const DefaultPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Default IFrame Player',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        WebviewtubePlayer('4AoFA19gbLo'),
      ],
    );
  }
}
