import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/home_page.dart';
import '../services/secure_storage.dart';
import '../widgets/show_flush_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SecurityQuestion extends StatefulWidget {
  final String checkEvent;
  final String passcode;
  const SecurityQuestion({
    super.key,
    required this.passcode,
    required this.checkEvent,
  });

  @override
  State<SecurityQuestion> createState() => _SecurityQuestionState();
}

TextEditingController _answer = TextEditingController();
String checkUserEvent = '';
String oldAnswer = '';
String oldQuestion = '';
String question = '';
String answer = '';
String confirmAnswer = '';
String dropdownValue = list.first;

class _SecurityQuestionState extends State<SecurityQuestion> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    String secureAnwser = await AnswerSecureStorage.getSecurityAnswer() ?? '';
    String secureQuestion =
        await QuestionSecureStorage.getSecurityQuestion() ?? '';

    setState(() {
      answer = "";
      question = "";
      oldAnswer = secureAnwser;
      oldQuestion = secureQuestion;
      checkUserEvent = widget.checkEvent;
      print(checkUserEvent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (checkUserEvent == 'setQuestion') {
          QuestionSecureStorage.deleteSecurityQuestion();
          AnswerSecureStorage.deleteSecurityAnswer();
          _answer.clear();
          Navigator.pushReplacementNamed(context, 'set-lock');
        } else {
          _answer.clear();
          Navigator.pushReplacementNamed(context, 'set-lock');
        }
        if (checkUserEvent == 'checkQuestionToLog') {
          return false;
        }
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/passcode-img.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                buildBackButton(context),
                checkUserEvent != 'checkQuestionToLog'
                    ? buildTitle(
                        context,
                        'Please set a security quesion in case you forget your password',
                      )
                    : buildTitle(
                        context,
                        '',
                      ),
                const DropdownButtonExample(),
                const AnswerField(),
                ConfirmButton(
                  passcode: widget.passcode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildBackButton(context) {
    return checkUserEvent == 'checkQuestionToLog'
        ? Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePage(),
                      ),
                    );
                    _answer.clear();
                  },
                  height: 50,
                  minWidth: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Reset Passcode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          )
        : Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    if (oldAnswer == "") {
                      QuestionSecureStorage.deleteSecurityQuestion();
                      AnswerSecureStorage.deleteSecurityAnswer();
                      _answer.clear();
                      Navigator.pushReplacementNamed(context, 'set-lock');
                    } else {
                      _answer.clear();
                      Navigator.pushReplacementNamed(context, 'set-lock');
                    }
                  },
                  height: 50,
                  minWidth: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                checkUserEvent == "setQuestion"
                    ? const Text(
                        'Set Diary Lock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const Text(
                        'Change Security Question',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          );
  }

  buildTitle(context, title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

const List<String> list = <String>[
  'What is your favortie color?',
  'What is your favorite food?',
  'What is your favorite movie?'
];

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          dropdownDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          value: dropdownValue,
          itemHeight: kMinInteractiveDimension,
          icon: Expanded(
            child: Container(
              padding: const EdgeInsets.only(right: 12),
              alignment: Alignment.topRight,
              child: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          underline: Container(
            height: 1,
            color: Colors.black,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AnswerField extends StatefulWidget {
  const AnswerField({super.key});

  @override
  State<AnswerField> createState() => _AnswerFieldState();
}

class _AnswerFieldState extends State<AnswerField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: TextField(
        controller: _answer,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: const InputDecoration(
          hintText: 'Please input your answer',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ConfirmButton extends StatefulWidget {
  final String passcode;
  const ConfirmButton({super.key, required this.passcode});

  @override
  State<ConfirmButton> createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<ConfirmButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 42),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: MaterialButton(
        onPressed: () async {
          if (checkUserEvent == 'checkQuestionToLog') {
            if (_answer.text.isEmpty) {
              showFlushBar(context, "Please input your answer");
            } else {
              setState(() {
                answer = _answer.text;
              });
              if (answer != oldAnswer || dropdownValue != oldQuestion) {
                _answer.clear();
                showFlushBar(context, 'Wrong Question or Answer');
              } else {
                _answer.clear();

                await PinSecureStorage.deletePinNumber();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, '/');
              }
            }
          } else {
            if (_answer.text.isEmpty) {
              showFlushBar(context, "Please input your answer");
            } else {
              if (answer == '') {
                setState(() {
                  answer = _answer.text;
                  question = dropdownValue;
                });
                showFlushBar(context, 'Enter you answer again');
                _answer.clear();
              } else {
                setState(() {
                  confirmAnswer = _answer.text;
                });
                if (answer != confirmAnswer || question != dropdownValue) {
                  _answer.clear();

                  showFlushBar(context, 'Does not match');
                } else {
                  _answer.clear();
                  await QuestionSecureStorage.setSecurityQuestion(
                      dropdownValue);
                  await AnswerSecureStorage.setSecurityAnswer(answer);
                  if (widget.passcode != '') {
                    await PinSecureStorage.setPinNumber(widget.passcode);
                    await CheckUserSession.setUserSession('logged');
                  }

                  print("$dropdownValue, $answer, ${widget.passcode}");

                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, 'setting-page');
                }
              }
            }
          }
        },
        child: Text(
          'Confirm'.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
