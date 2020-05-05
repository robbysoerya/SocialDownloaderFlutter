import 'package:flutter/material.dart';
import 'package:social_downloader/ui/screens/downloader_screen.dart';
import 'package:social_downloader/ui/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: DownloaderScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        DownloaderScreen.id: (context) => DownloaderScreen()
      },
    );
  }
}
