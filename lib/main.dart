import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'news_provider.dart';
import 'theme_provider.dart';
import 'home_screen.dart';
import 'news_reader_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'ArticleArc',
            theme:
                themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: const LinkHandler(),
          );
        },
      ),
    );
  }
}

class LinkHandler extends StatefulWidget {
  const LinkHandler({super.key});

  @override
  _LinkHandlerState createState() => _LinkHandlerState();
}

class _LinkHandlerState extends State<LinkHandler> {
  String? _sharedText; // Holds the shared URL
  late StreamSubscription _intentSub; // Subscription for shared intents

  @override
  void initState() {
    super.initState();

    // Listen for text sharing while the app is running
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (List<SharedMediaFile>? sharedFiles) {
        if (sharedFiles != null && sharedFiles.isNotEmpty) {
          _handleSharedContent(sharedFiles.first.path);
        }
      },
      onError: (err) {
        debugPrint("Error receiving shared text: $err");
      },
    );

    // Handle text sharing when the app is launched
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile>? sharedFiles) {
      if (sharedFiles != null && sharedFiles.isNotEmpty) {
        _handleSharedContent(sharedFiles.first.path);
      }
    });
  }

  @override
  void dispose() {
    _intentSub.cancel(); // Cancel the subscription to prevent memory leaks
    super.dispose();
  }

  // Handle shared content (only valid URLs)
  void _handleSharedContent(String content) {
    if (_isValidUrl(content)) {
      setState(() {
        _sharedText = content;
      });

      // Navigate to the NewsReaderScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsReaderScreen(url: content),
        ),
      );
    } else {
      debugPrint("Invalid URL shared: $content");
    }
  }

  // Validate shared URL
  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sharedText == null
          ? const HomeScreen() // Show the HomeScreen if no shared URL
          : NewsReaderScreen(
              url:
                  _sharedText!), // Show the NewsReaderScreen if a URL is shared
    );
  }
}
