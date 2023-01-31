import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/models/diary.dart';
import 'package:hive_flutter/adapters.dart';
import '../widgets/diary_items.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/floating_action_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isReversed = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: const DrawerWidget(),
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.sort_rounded),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        const Text("Latest First"),
                        const Spacer(),
                        Visibility(
                          visible: isReversed,
                          child: const Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        const Text("Oldest First"),
                        const Spacer(),
                        Visibility(
                          visible: !isReversed,
                          child: const Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  setState(() {
                    isReversed = true;
                  });
                } else {
                  setState(() {
                    isReversed = false;
                  });
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: Hive.box('diaries').listenable(),
              builder: (context, box, _) {
                List originalData = box.values.toList();
                List showData = box.values.toList();
                showData.sort((a, b) => isReversed
                    ? b.date.compareTo(a.date)
                    : a.date.compareTo(b.date));

                if (showData.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/empty-list.png'),
                        Text(
                          "homepage_empty_content_text".tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'homepage_sub_text'.tr(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
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
            const FloatingButtonWidget(),
          ],
        ),
      ),
    );
  }
}
