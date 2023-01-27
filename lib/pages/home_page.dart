import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/models/diary.dart';
import 'package:flutter_memories_dailyjournal/pages/passcode_page.dart';
import 'package:hive_flutter/adapters.dart';
import '../constants.dart';
import '../services/secure_storage.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/floating_action_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangePage extends StatefulWidget {
  static const route = '/';
  const ChangePage({super.key});

  @override
  State<ChangePage> createState() => _ChangePageState();
}

class _ChangePageState extends State<ChangePage> with WidgetsBindingObserver {
  String userSession = "noPin";
  String securePin = "";

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    init();

    super.initState();
  }

  Future init() async {
    String pin = await PinSecureStorage.getPinNumber() ?? '';
    String checkUserSession = await CheckUserSession.getUserSession() ?? '';

    setState(() {
      securePin = pin;
      userSession = checkUserSession;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) return;

    final isInActive = state == AppLifecycleState.inactive;

    // Delete user session
    if (isInActive) {
      CheckUserSession.deleteUserSession();
    }

    final isBackgroud = state == AppLifecycleState.paused;

    if (isBackgroud) {
      String pin = await PinSecureStorage.getPinNumber() ?? '';
      print('detect: ${pin} ${userSession}');

      if (pin != "") {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PasscodePage(checked: 'checkToLog'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return securePin != ''
        ? userSession != 'logged'
            ? const PasscodePage(
                checked: 'checkToLog',
              )
            : const HomePage()
        : const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.swap_vert_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box('diaries').listenable(),
            builder: (context, box, _) {
              if (box.values.isEmpty) {
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
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  Diary? currentDiary = box.getAt(index);
                  if (index == box.values.length - 1) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: diaryItem(currentDiary),
                    );
                  }
                  return diaryItem(currentDiary);
                },
              );
            },
          ),
          const FloatingButtonWidget(),
        ],
      ),
    );
  }

  Widget diaryItem(Diary? currentDiary) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: DateFormat('d ').format(currentDiary!.date).toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text:
                        DateFormat('MMM').format(currentDiary.date).toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      moodIconList[currentDiary.mood],
                      height: 32,
                    ),
                    const VerticalDivider(
                      width: 30,
                      thickness: 1.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: currentDiary.contentPlainText.isEmpty
                                ? currentDiary.imgPaths.isNotEmpty
                                    ? Container()
                                    : const Text(
                                        "You didn't write anything this day",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic),
                                      )
                                : Text(
                                    currentDiary.contentPlainText,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          if (currentDiary.imgPaths.isNotEmpty)
                            SizedBox(
                              height: 100,
                              child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 3,
                                crossAxisSpacing: 5.0,
                                children: [
                                  ...List<Widget>.generate(
                                    currentDiary.imgPaths.length <= 3
                                        ? currentDiary.imgPaths.length
                                        : 3,
                                    (int index) => currentDiary
                                                .imgPaths.length >
                                            3
                                        ? handleMultipleImg(index, currentDiary)
                                        : _imgWidget(currentDiary, index),
                                  ),
                                ],
                              ),
                            )
                          else
                            const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget handleMultipleImg(int index, Diary currentDiary) {
    if (index < 2) {
      return _imgWidget(currentDiary, index);
    } else {
      return Stack(
        children: [
          _imgWidget(currentDiary, index),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          const Center(
            child: Icon(
              Icons.more_horiz_rounded,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ],
      );
    }
  }

  Widget _imgWidget(Diary currentDiary, int index) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.file(
          File(currentDiary.imgPaths[index]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
