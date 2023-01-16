import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/passcode_page.dart';
import 'package:flutter_memories_dailyjournal/pages/security_question.dart';
import '../services/secure_storage.dart';

class SetDiaryLock extends StatefulWidget {
  static const route = 'set-lock';
  const SetDiaryLock({super.key});

  @override
  State<SetDiaryLock> createState() => _SetDiaryLockState();
}

String pin = "";
bool active = false;

class _SetDiaryLockState extends State<SetDiaryLock> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    String getPin = await PinSecureStorage.getPinNumber() ?? "";
    setState(() {
      pin = getPin;
    });
    if (pin != "") {
      setState(() {
        active = true;
      });
    } else {
      setState(() {
        active = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color(0xFFE5F5FF),
        title: const Text('Set Diary Lock'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'setting-page');
          },
        ),
      ),
      backgroundColor: const Color(0xFFE5F5FF),
      body: Column(
        children: [
          SetLockTile(
            onChanged: (bool value) async {
              setState(
                () {
                  active = value;
                },
              );
              if (active == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasscodePage(checked: 'noPin'),
                  ),
                );
              } else {
                await PinSecureStorage.deletePinNumber();
                await QuestionSecureStorage.deleteSecurityQuestion();
                await AnswerSecureStorage.deleteSecurityAnswer();
                await CheckUserSession.deleteUserSession();
              }
            },
          ),
          active == true
              ? Column(
                  children: [
                    SetLockItems(
                      title: 'Set Passcode',
                      subTitle: 'Set or change your passcode',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PasscodePage(checked: 'changePassCode'),
                          ),
                        );
                      },
                    ),
                    SetLockItems(
                      title: 'Set Security Question',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SecurityQuestion(
                              passcode: '',
                              checkEvent: 'changeQuestion',
                            ),
                          ),
                        );
                      },
                      subTitle:
                          'It will be used in case you forget your passcode',
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class SetLockItems extends StatefulWidget {
  final String title;
  final String subTitle;

  final Function() onTap;
  const SetLockItems({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  @override
  State<SetLockItems> createState() => _SetLockItemsState();
}

class _SetLockItemsState extends State<SetLockItems> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          title: Text(widget.title),
          subtitle: Text(widget.subTitle),
        ),
      ),
    );
  }
}

class SetLockTile extends StatefulWidget {
  final Function(bool) onChanged;
  const SetLockTile({super.key, required this.onChanged});

  @override
  State<SetLockTile> createState() => _SetLockTileState();
}

class _SetLockTileState extends State<SetLockTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        title: const Text('Enable Diary Lock'),
        subtitle: const Text('Enable passcode to protect your diary'),
        trailing: Switch(
          value: active,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
