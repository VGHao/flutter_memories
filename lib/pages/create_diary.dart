import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';

class CreateDiary extends StatefulWidget {
  const CreateDiary({super.key});

  @override
  State<CreateDiary> createState() => _CreateDiaryState();
}

class _CreateDiaryState extends State<CreateDiary> {
  final quill.QuillController _controller = quill.QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  bool isFocus = false;
  DateTime selectedDate = DateTime.now();
  DateTime now = DateTime.now();
  List<String> moodIconList = [
    'assets/images/mood_cry.png',
    'assets/images/mood_sad.png',
    'assets/images/mood_neutral.png',
    'assets/images/mood_happy.png',
    'assets/images/mood_excited.png',
  ];
  List<String> moodList = [
    'heartbroken',
    'unhappy',
    'neutral',
    'happy',
    'delighted',
  ];
  int? selectedMood = 2;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year, now.month, now.day),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _discardConfirm(BuildContext context) async {
    if (await confirm(
      context,
      title: const Text('Discard'),
      content: const Text(
          "Your changes haven't been saved. \nDo you want to discard the changes?"),
      textOK: const Text('OK'),
      textCancel: const Text('CANCEL'),
    )) {
      return Navigator.of(context).pop();
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _focusNode.unfocus();
        isFocus = false;
      }),
      child: Scaffold(
        backgroundColor: const Color(0xFFE5F5FF),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => _discardConfirm(context),
          ),
          title: TextButton(
            onPressed: () => _selectDate(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat.yMMMd().format(selectedDate),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.black,
                  size: 30,
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                //Save data to Database
              },
              icon: const Icon(Icons.check, color: Colors.blue),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'How was your day?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(
                              scale: animation,
                              alignment: Alignment.centerLeft,
                              child: child,
                            ),
                            child: selectedMood != null
                                ? IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedMood = null;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 2,
                                            shape: const CircleBorder(),
                                            padding: const EdgeInsets.all(15),
                                            backgroundColor: Colors.white,
                                          ),
                                          child: Image.asset(
                                              moodIconList[selectedMood!],
                                              height: 32),
                                        ),
                                        const VerticalDivider(
                                          width: 30,
                                          thickness: 1.0,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: "It was ",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: moodList[selectedMood!],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const TextSpan(text: " today.")
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List<Widget>.generate(
                                        5,
                                        (index) => IconButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedMood = index;
                                            });
                                          },
                                          icon:
                                              Image.asset(moodIconList[index]),
                                          iconSize: 45,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tell me about your day',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Divider(),
                          quill.QuillEditor(
                            minHeight: 100,
                            controller: _controller,
                            scrollController: ScrollController(),
                            scrollable: true,
                            focusNode: _focusNode,
                            autoFocus: false,
                            readOnly: false,
                            placeholder: 'Write something...',
                            padding: EdgeInsets.zero,
                            expands: false,
                            onTapDown: (details, p1) {
                              setState(() {
                                isFocus = true;
                              });
                              return false;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Your photos',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  Positioned(
                                      top: 6,
                                      right: 6,
                                      child: SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            elevation: 0,
                                            shape: const CircleBorder(),
                                            backgroundColor:
                                                Colors.black.withOpacity(0.3),
                                            foregroundColor: Colors.white,
                                          ),
                                          child:
                                              const Icon(Icons.close, size: 12),
                                        ),
                                      )),
                                ],
                              ),
                              InkWell(
                                onTap: () {},
                                child: DottedBorder(
                                  color: Colors.blue,
                                  dashPattern: const [10, 3],
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add_photo_alternate_rounded,
                                        color: Colors.blue,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: isFocus
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: quill.QuillToolbar.basic(
                        controller: _controller,
                        toolbarIconSize: 26,
                        toolbarIconAlignment: WrapAlignment.spaceAround,
                        showDividers: false,
                        showFontFamily: false,
                        showFontSize: false,
                        showBoldButton: true,
                        showItalicButton: true,
                        showUnderLineButton: true,
                        showStrikeThrough: true,
                        showInlineCode: false,
                        showColorButton: true,
                        showBackgroundColorButton: true,
                        showClearFormat: true,
                        showLeftAlignment: false,
                        showCenterAlignment: false,
                        showRightAlignment: false,
                        showJustifyAlignment: false,
                        showHeaderStyle: false,
                        showListNumbers: false,
                        showListBullets: false,
                        showListCheck: false,
                        showCodeBlock: false,
                        showQuote: false,
                        showIndent: false,
                        showLink: false,
                        showUndo: false,
                        showRedo: false,
                        showSearchButton: false,
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
