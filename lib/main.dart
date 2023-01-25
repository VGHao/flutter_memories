import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/set_diary_lock.dart';
import 'package:flutter_memories_dailyjournal/pages/setting_page.dart';
import 'package:hive/hive.dart';
import 'models/diary.dart';
import 'pages/home_page.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(DiaryAdapter());
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
        '/': (context) => FutureBuilder(
              future: Hive.openBox('diaries'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const ChangePage();
                  }
                } else {
                  return const Scaffold();
                }
              },
            ),
        'setting-page': (context) => const SettingPage(),
        'set-lock': (context) => const SetDiaryLock(),
      },
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
