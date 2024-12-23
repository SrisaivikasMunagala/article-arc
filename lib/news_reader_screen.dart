import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'news_reader_service.dart';

class NewsReaderScreen extends StatefulWidget {
  final String url;

  const NewsReaderScreen({super.key, required this.url});

  @override
  _NewsReaderScreenState createState() => _NewsReaderScreenState();
}

class _NewsReaderScreenState extends State<NewsReaderScreen> {
  final NewsReaderService _newsReaderService = NewsReaderService();
  late Future<Map<String, dynamic>> _articleContent;

  // Reader style options
  final List<Map<String, dynamic>> _readerStyles = [
    {
      'name': 'White',
      'backgroundColor': Colors.white,
      'textColor': Colors.black,
    },
    {
      'name': 'Beige',
      'backgroundColor': const Color.fromARGB(255, 230, 217, 205),
      'textColor': Colors.black,
    },
    {
      'name': 'Dark',
      'backgroundColor': Colors.black,
      'textColor': Colors.white,
    },
  ];

  // Default selected style
  Map<String, dynamic> _selectedStyle = {
    'backgroundColor': Colors.white,
    'textColor': Colors.black,
  };

  // Font size
  double _fontSize = 16;

  @override
  void initState() {
    super.initState();
    _articleContent = _newsReaderService.fetchArticleContent(widget.url);
  }

  void _changeStyle(Map<String, dynamic> style) {
    setState(() {
      _selectedStyle = style;
    });
  }

  void _changeFontSize(double delta) {
    setState(() {
      _fontSize = (_fontSize + delta).clamp(12.0, 30.0); // Min: 12, Max: 30
    });
  }

  void _showCustomizationSheet() {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Customize Reader',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _readerStyles.map((style) {
                  return GestureDetector(
                    onTap: () {
                      _changeStyle(style);
                      Navigator.pop(context); // Close bottom sheet
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: style['backgroundColor'],
                        border: Border.all(
                          color: _selectedStyle == style
                              ? Colors.blue
                              : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _changeFontSize(-2),
                    child: const Text('A-'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeFontSize(2),
                    child: const Text('A+'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _articleContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
                backgroundColor: _selectedStyle['backgroundColor'],
                iconTheme: IconThemeData(color: _selectedStyle['textColor']),
              ),
              body: Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: GoogleFonts.notoSans(
                    color: _selectedStyle['textColor'],
                  ),
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('No Content'),
                backgroundColor: _selectedStyle['backgroundColor'],
                iconTheme: IconThemeData(color: _selectedStyle['textColor']),
              ),
              body: Center(
                child: Text(
                  'No content available',
                  style: GoogleFonts.notoSans(
                    color: _selectedStyle['textColor'],
                  ),
                ),
              ),
            );
          }

          final article = snapshot.data!;
          final source =
              article['domain'] ?? 'Unknown Source'; // Get the source name

          return Scaffold(
            appBar: AppBar(
              title: Text(
                source,
                style: GoogleFonts.notoSans(
                  color: _selectedStyle['textColor'],
                ),
              ),
              backgroundColor: _selectedStyle['backgroundColor'],
              iconTheme: IconThemeData(color: _selectedStyle['textColor']),
              elevation: 0,
              actions: [
                IconButton(
                  icon:
                      Icon(Icons.settings, color: _selectedStyle['textColor']),
                  onPressed: _showCustomizationSheet,
                ),
              ],
            ),
            backgroundColor: _selectedStyle['backgroundColor'],
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article['imageUrl'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        article['imageUrl'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    article['title'] ?? 'No title available',
                    style: GoogleFonts.notoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _selectedStyle['textColor'],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article['content'] ?? 'Content not available',
                    style: GoogleFonts.notoSans(
                      fontSize: _fontSize,
                      color: _selectedStyle['textColor'],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
