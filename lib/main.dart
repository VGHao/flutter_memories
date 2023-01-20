import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/set_diary_lock.dart';
import 'package:flutter_memories_dailyjournal/pages/setting_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memories - Daily Jounnal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => ChangePage(),
        'setting-page': (context) => SettingPage(),
        'set-lock': (context) => SetDiaryLock(),
      },
    );
  }
}
