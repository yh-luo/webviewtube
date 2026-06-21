import 'package:flutter/material.dart';
import 'package:webviewtube/webviewtube.dart';

import 'customized_player.dart';
import 'external_links_player.dart';
import 'playlist_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webviewtube',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const QuickStartPage(),
    );
  }
}

/// Minimal quickstart: drop a [WebviewtubePlayer] into the widget tree
/// and pass a `videoId`. No controller is required for playback.
///
/// The other pages demonstrate more advanced patterns: controller-driven
/// UI, playlists, and handing YouTube links to the system browser.
class QuickStartPage extends StatelessWidget {
  const QuickStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Webviewtube Examples')),
      body: ListView(
        children: <Widget>[
          WebviewtubePlayer(videoId: 'iBRrnCqzTuk'),
          const SizedBox(height: 16),
          _NavTile(
            label: 'Controller-driven UI',
            description:
                'Reflect title, author, and position in your own widgets',
            builder: (_) => const CustomizedPlayer(),
          ),
          _NavTile(
            label: 'Playlist',
            description:
                'Load a list of videos and navigate with next / previous',
            builder: (_) => const PlaylistPlayer(),
          ),
          _NavTile(
            label: 'External links',
            description: 'Open YouTube links in the system browser',
            builder: (_) => const ExternalLinksPlayer(),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.label,
    required this.description,
    required this.builder,
  });

  final String label;
  final String description;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () =>
          Navigator.of(context).push<void>(MaterialPageRoute(builder: builder)),
    );
  }
}
