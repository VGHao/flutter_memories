import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/security_question.dart';
import '../services/secure_storage.dart';
import '../widgets/show_flush_bar.dart';

class PasscodePage extends StatefulWidget {
  final String checked;

  const PasscodePage({super.key, required this.checked});

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.checked == 'checkToTurnOff') {
          Navigator.pushReplacementNamed(context, 'setting-page');
        }
        if (widget.checked == 'changePassCode') {
          Navigator.pushReplacementNamed(context, 'set-lock');
        }

        return false;
      },
      child: Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/passcode-img.png',
                ),
              ),
            ),
            child: PassCodeScreen(
              check: widget.checked,
            )),
      ),
    );
  }
}

class PassCodeScreen extends StatefulWidget {
  final dynamic createPasscode;
  final String check;
  const PassCodeScreen({super.key, this.createPasscode, required this.check});

  @override
  State<PassCodeScreen> createState() => _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  List<String> currentPin = ["", "", "", ""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  int pinIndex = 0;

  String oldPin = '';
  String firstPin = '';
  String confirmPin = '';
  String securePin = '';
  String checkSecure = '';
  String checkUserEvent = '';

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    String pin = await PinSecureStorage.getPinNumber() ?? '';

    setState(() {
      securePin = pin;
      checkUserEvent = widget.check;
      print(checkUserEvent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          checkUserEvent == 'checkToLog'
              ? const SizedBox(
                  height: 70,
                  width: 50,
                )
              : buildBackButton(),
          Expanded(
            child: Container(
              alignment: const Alignment(0, 0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildSecurityText(),
                  const SizedBox(height: 100),
                  buildPinRow(),
                ],
              ),
            ),
          ),
          buildKeyBoard(),
          checkUserEvent == 'checkToLog'
              ? buildResetBtn()
              : const SizedBox(
                  height: 60,
                ),
        ],
      ),
    );
  }

  buildResetBtn() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MaterialButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SecurityQuestion(
                passcode: '',
                checkEvent: 'checkQuestionToLog',
              ),
            ),
          );
        },
        child: const Text(
          'Reset Passcode',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  buildBackButton() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      child: MaterialButton(
        onPressed: () async {
          if (checkUserEvent == 'checkToTurnOff') {
            await Navigator.pushReplacementNamed(context, 'setting-page');
          } else {
            await Navigator.pushReplacementNamed(context, 'set-lock');
          }
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
    );
  }

  buildSecurityText() {
    return checkUserEvent == 'checkToLog' || checkUserEvent == 'checkToTurnOff'
        ? Text(
            "Enter your passcode".toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        : checkUserEvent == "noPin"
            ? firstPin == ""
                ? Text(
                    "enter your new pin".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "Confirm your pin".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
            : securePin != oldPin
                ? Text(
                    "Enter your old Pin".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : firstPin == ""
                    ? Text(
                        "Enter your new Pin".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        "Confirm your new pin".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PinNumber(
          textEditingController: pinOneController,
        ),
        PinNumber(
          textEditingController: pinTwoController,
        ),
        PinNumber(
          textEditingController: pinThreeController,
        ),
        PinNumber(
          textEditingController: pinFourController,
        ),
      ],
    );
  }

  buildKeyBoard() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...List.generate(3, (n) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(
                      3,
                      (m) {
                        return KeyboardNumber(
                          n: n * 3 + m + 1,
                          onPressed: () {
                            pinIndexSetup("${n * 3 + m + 1}");
                          },
                        );
                      },
                    ),
                  ],
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 60,
                    child: MaterialButton(
                      onPressed: null,
                      child: SizedBox(),
                    ),
                  ),
                  KeyboardNumber(
                    n: 0,
                    onPressed: () {
                      pinIndexSetup("0");
                    },
                  ),
                  // Del button
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(60),
                    ),
                    width: 60,
                    child: MaterialButton(
                      height: 60,
                      onPressed: () {
                        clearPin();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Image.asset(
                        'assets/images/del-icon.png',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  clearPinField() {
    // Clear Pin row
    setState(() {
      pinIndex = 0;
      pinOneController.clear();
      pinTwoController.clear();
      pinThreeController.clear();
      pinFourController.clear();
    });
  }

  pinIndexSetup(String text) async {
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 4) {
      pinIndex++;
    }
    setPin(pinIndex, text);
    setState(() {
      currentPin[pinIndex - 1] = text;
    });
    String strPin = "";
    for (var e in currentPin) {
      strPin += e;
    }
    createPasscode(strPin);
    changePassCode(strPin);
    checkPasscodeToLog(strPin);
    checkPassCodeToTurnOff(strPin);
  }

  createPasscode(strPin) {
    if (checkUserEvent == 'noPin') {
      if (pinIndex == 4 && firstPin == '') {
        setState(() {
          firstPin = strPin;
        });
        showFlushBar(
          context,
          'Input your Pin again',
        );
        clearPinField();
      }
      if (pinIndex == 4 && firstPin != '') {
        setState(() {
          confirmPin = strPin;
        });
        if (firstPin != confirmPin) {
          showFlushBar(
            context,
            'Pin does not match',
          );
          clearPinField();
        }
        if (firstPin == confirmPin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SecurityQuestion(
                passcode: confirmPin,
                checkEvent: 'setQuestion',
              ),
            ),
          );
        }
      }
    }
  }

  changePassCode(strPin) async {
    if (checkUserEvent == 'changePassCode') {
      if (pinIndex == 4 && checkSecure == "") {
        setState(() {
          oldPin = strPin;
        });
        if (oldPin != securePin) {
          // ignore: use_build_context_synchronously
          showFlushBar(
            context,
            'Pin does not match',
          );
          clearPinField();
        } else {
          // ignore: use_build_context_synchronously
          showFlushBar(
            context,
            'Enter your new pin',
          );
          clearPinField();
          setState(() {
            checkSecure = securePin;
          });
        }
      } else {
        if (pinIndex == 4 && firstPin == "") {
          setState(() {
            firstPin = strPin;
          });
          // ignore: use_build_context_synchronously
          showFlushBar(
            context,
            'Enter your Pin again',
          );
          clearPinField();
        }
        if (pinIndex == 4 && firstPin != '') {
          setState(() {
            confirmPin = strPin;
          });
          if (firstPin != confirmPin) {
            // ignore: use_build_context_synchronously
            showFlushBar(
              context,
              'Pin does not match',
            );
            clearPinField();
          }
          if (firstPin == confirmPin) {
            // Set Pin Number to secure storage
            await PinSecureStorage.setPinNumber(confirmPin);
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, 'setting-page');
            // ignore: use_build_context_synchronously
            showFlushBar(
              context,
              'Change successfully',
            );
          }
        }
      }
    }
  }

  checkPasscodeToLog(strPin) async {
    if (checkUserEvent == 'checkToLog') {
      if (pinIndex == 4) {
        setState(() {
          firstPin = strPin;
        });
        if (firstPin != securePin) {
          showFlushBar(
            context,
            'Wrong Pin',
          );
          clearPinField();
        } else {
          await CheckUserSession.setUserSession('logged');
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/');
        }
      }
    }
  }

  checkPassCodeToTurnOff(strPin) async {
    if (checkUserEvent == 'checkToTurnOff') {
      if (pinIndex == 4) {
        setState(() {
          firstPin = strPin;
        });
        if (firstPin != securePin) {
          showFlushBar(
            context,
            'Wrong Pin',
          );
          clearPinField();
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, 'set-lock');
        }
      }
    }
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
    }
  }

  clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 4) {
      setPin(pinIndex, "");
      setState(() {
        currentPin[pinIndex - 1] = "";
      });
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      setState(() {
        currentPin[pinIndex - 1] = "";
      });
      pinIndex--;
    }
  }
}

class PinNumber extends StatelessWidget {
  final TextEditingController textEditingController;

  const PinNumber({
    super.key,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: 50,
      child: TextField(
        controller: textEditingController,
        autofocus: false,
        enabled: true,
        readOnly: true,
        obscureText: true,
        obscuringCharacter: "*",
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: textEditingController.text.isEmpty
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[400]!,
                    width: 2,
                  ),
                )
              : InputBorder.none,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21,
          color: Colors.white,
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  const KeyboardNumber({
    super.key,
    required this.n,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[400]!,
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        height: 60,
        child: Text(
          "$n",
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
