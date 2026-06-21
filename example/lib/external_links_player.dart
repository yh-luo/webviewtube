import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewtube/webviewtube.dart';

class ExternalLinksPlayer extends StatefulWidget {
  const ExternalLinksPlayer({super.key});

  @override
  State<ExternalLinksPlayer> createState() => _ExternalLinksPlayerState();
}

class _ExternalLinksPlayerState extends State<ExternalLinksPlayer> {
  late final WebviewtubeController controller;

  @override
  void initState() {
    super.initState();
    controller = WebviewtubeController(
      // Intercept top-level WebView navigations (those that would replace
      // the player page) and hand YouTube URLs off to the system browser
      // or YouTube app.
      // Return `false` to cancel the in-WebView navigation, `true` to let
      // it proceed.
      onPlayerNavigationRequest: _handleNavigation,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _handleNavigation(Uri uri) async {
    final host = uri.host;
    final isYouTube =
        host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtu.be';
    if (isYouTube) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('External links')),
      body: ListView(
        children: <Widget>[
          WebviewtubePlayer(videoId: 'iBRrnCqzTuk', controller: controller),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Top-level navigations to a YouTube URL are intercepted and '
              'opened in the default browser or the YouTube app.',
            ),
          ),
        ],
      ),
    );
  }
}
