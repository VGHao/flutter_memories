import 'dart:convert';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/widgets/show_flush_bar.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

import '../constants.dart';
import '../models/diary.dart';

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
  int? selectedMood = 2;
  final ImagePicker _picker = ImagePicker();
  List<String> _imagesPathList = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
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
      title: Text('discard_confirm_title'.tr()),
      content: Text("discard_confirm_content".tr()),
      textOK: Text('discard_ok'.tr()),
      textCancel: Text('discard_cancel'.tr()),
    )) {
      deleteImgList();
      return Navigator.of(context).pop();
    }
    return;
  }

  Future<void> deleteImgList() async {
    try {
      for (String path in _imagesPathList) {
        await File(path).delete();
        _imagesPathList.remove(path);
      }
    } catch (e) {
      return;
    }
  }

  Future<void> selectImages() async {
    try {
      var pickedImages = await _picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        await copyImagesToDir(pickedImages);
      }
      print(_imagesPathList.toString());
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> copyImagesToDir(List<XFile> pickedImages) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    List<String> newPaths = [];
    for (var img in pickedImages) {
      File originalImg = File(img.path);
      // print(originalImg.path);
      File newImage = await originalImg.copy("$path/${img.name}");
      newPaths.add(newImage.path);
    }
    _imagesPathList = _imagesPathList + newPaths;
  }

  Future<void> removeImg(String path) async {
    try {
      await File(path).delete();
      _imagesPathList.remove(path);
      setState(() {});
    } catch (e) {
      return;
    }
  }

  void addDiary(Diary diary) {
    final diariesBox = Hive.box('diaries');
    diariesBox.add(diary);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await confirm(
          context,
          title: Text('discard_confirm_title'.tr()),
          content: Text("discard_confirm_content".tr()),
          textOK: Text('discard_ok'.tr()),
          textCancel: Text('discard_cancel'.tr()),
        );
        if (shouldPop) {
          deleteImgList();
        }
        return shouldPop;
      },
      child: GestureDetector(
        onTap: () => setState(() {
          _focusNode.unfocus();
          isFocus = false;
        }),
        child: Scaffold(
          // backgroundColor: const Color(0xFFE5F5FF),
          appBar: AppBar(
            elevation: 0,
            // backgroundColor: Colors.transparent,
            // foregroundColor: Colors.black,
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
                      // color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down_rounded,
                    // color: Colors.black,
                    size: 30,
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  //Save data to Database
                  if (selectedMood == null) {
                    showFlushBar(context, "Select a mood");
                  } else {
                    String contentJson =
                        jsonEncode(_controller.document.toDelta().toJson());
                    String contentPlainText =
                        _controller.document.toPlainText().trim();
                    final newDiary = Diary(
                      date: selectedDate,
                      mood: selectedMood!,
                      contentPlainText: contentPlainText,
                      contentJson: contentJson,
                      imgPaths: _imagesPathList,
                    );
                    addDiary(newDiary);
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(
                  Icons.check,
                  // color: Colors.blue,
                ),
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
                      moodSelectWidget(),
                      const SizedBox(height: 20),
                      contentWidget(),
                      const SizedBox(height: 20),
                      imageUploadWidget(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
              textToolbarWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Container moodSelectWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'mood_select_title'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(
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
                            elevation: 0,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15),
                            // backgroundColor: Colors.white,
                          ),
                          child: Image.asset(moodIconList[selectedMood!],
                              height: 32),
                        ),
                        const VerticalDivider(
                          width: 30,
                          thickness: 1.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "mood_leading_text".tr(),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2?.color,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: moodList[selectedMood!],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: "mood_trailing_text".tr())
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List<Widget>.generate(
                        5,
                        (index) => IconButton(
                          onPressed: () {
                            setState(() {
                              selectedMood = index;
                            });
                          },
                          icon: Image.asset(moodIconList[index]),
                          iconSize: 45,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget contentWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'diary_content_helper_text'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Divider(
            thickness: 1.0,
          ),
          quill.QuillEditor(
            minHeight: 100,
            controller: _controller,
            scrollController: ScrollController(),
            scrollable: true,
            focusNode: _focusNode,
            autoFocus: false,
            readOnly: false,
            placeholder: 'diary_content_placeholder'.tr(),
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
    );
  }

  Widget textToolbarWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: isFocus
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.vertical(
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
    );
  }

  Widget imageUploadWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'diary_add_photos'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            padding: const EdgeInsets.all(0.0),
            children: [
              ...List<Widget>.generate(
                _imagesPathList.length,
                (int index) => Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(_imagesPathList[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                        top: 6,
                        right: 6,
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: ElevatedButton(
                            onPressed: () {
                              removeImg(_imagesPathList[index]);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              shape: const CircleBorder(),
                              backgroundColor: Colors.black.withOpacity(0.3),
                              foregroundColor: Colors.white,
                            ),
                            child: const Icon(Icons.close, size: 12),
                          ),
                        )),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  selectImages();
                },
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
    );
  }
}
