import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_memories_dailyjournal/services/secure_storage.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String currentLanguage = "en_US";

  List listLanguage = [
    {
      'id': 0,
      'title': 'English',
      'isSelected': true,
      'language_name': 'en_US',
      'language': 'en',
      'country': 'US',
    },
    {
      'id': 1,
      'title': 'Việt Nam',
      'isSelected': false,
      'language_name': 'vi',
      'language': 'vi',
      'country': '',
    },
  ];
  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    String language = await SelectedLanguage.getLanguage() ?? '';

    setState(() {
      currentLanguage = language;
    });

    for (var element in listLanguage) {
      if (element["language_name"] == language) {
        element["isSelected"] = true;
      } else {
        element["isSelected"] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text('set_lock_title'.tr()),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'setting-page');
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Column(
            children: List.generate(
              listLanguage.length,
              (index) => Container(
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: const EdgeInsets.only(left: 16, right: 12),
                  dense: true,
                  side: MaterialStateBorderSide.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return BorderSide.none;
                    }
                    return BorderSide.none;
                  }),
                  title: Text(
                    listLanguage[index]["title"],
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  value: listLanguage[index]["isSelected"],
                  onChanged: (value) {
                    if (listLanguage[index]["isSelected"] == true) {
                      setState(() {
                        listLanguage[index]["isSelected"] = true;
                      });
                    } else {
                      setState(() {
                        for (var element in listLanguage) {
                          element["isSelected"] = false;
                        }
                        listLanguage[index]["isSelected"] = value;
                        context.setLocale(Locale(
                            listLanguage[index]["language"],
                            listLanguage[index]["country"]));
                        SelectedLanguage.setLanguage(context.locale.toString());
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
