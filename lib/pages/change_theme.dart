import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/theme/theme.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme_manager.dart';

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({Key? key}) : super(key: key);

  @override
  ChangeThemeState createState() => ChangeThemeState();
}

class ChangeThemeState extends State<ChangeTheme> {
  String _selectedColor = "Light";
  final List<String> _color = ["Dark", "Light"];

  void onThemeChange(String value, ThemeNotifier themeNotifier) async {
    if (value == "Dark") {
      themeNotifier.setTheme(darkTheme);
    } else if (value == "Light") {
      themeNotifier.setTheme(lightTheme);
    }
    final pref = await SharedPreferences.getInstance();
    pref.setString("ThemeMode", value);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    themeNotifier.getTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme App"),
      ),
      // backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(),
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.blue), // For Test
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            themeChangeDialog(themeNotifier);
          },
        ),
      ),
    );
  }

  themeChangeDialog(ThemeNotifier themeNotifier) {
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                content: SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RadioGroup<String>.builder(
                        groupValue: _selectedColor,
                        onChanged: ((val) {
                          setState(() {
                            _selectedColor = val!;
                          });
                          onThemeChange(_selectedColor, themeNotifier);

                        }),
                        items: _color,
                        itemBuilder: (item) => RadioButtonBuilder(item),
                      )
                    ],
                  ),
                ),
                actions: [
                  MaterialButton(
                      child: const Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      })
                ],
              );
            }));
  }
}
