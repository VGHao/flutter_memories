import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/diary.dart';
import '../widgets/diary_items.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  var diariesBox = Hive.box('diaries');
  // List searchResults = originalData
  //     .where((element) =>
  //         element.contentPlainText.contains(searchController.text.toString()))
  //     .toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search in diares',
          ),
          onChanged: (value) {},
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchController.text = '';
              });
            },
            icon: const Icon(Icons.clear_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '0 diary found',
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('diaries').listenable(),
              builder: (context, box, _) {
                List originalData = box.values.toList();
                List showData = originalData.where((element) {
                  print(element.toString());
                  return element.contentPlainText
                      .contains(searchController.text);
                }).toList();

                showData.sort((a, b) => b.date.compareTo(a.date));

                return ListView.builder(
                  itemCount: showData.length,
                  itemBuilder: (context, index) {
                    Diary? currentDiary = showData[index];
                    if (index == showData.length - 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: diaryItem(
                          context: context,
                          index: originalData.indexOf(currentDiary),
                          currentDiary: currentDiary,
                        ),
                      );
                    }
                    return diaryItem(
                      context: context,
                      index: originalData.indexOf(currentDiary),
                      currentDiary: currentDiary,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
