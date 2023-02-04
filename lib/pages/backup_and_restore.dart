import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/secure_storage.dart';

class BackupAndRestore extends StatefulWidget {
  const BackupAndRestore({super.key});

  @override
  State<BackupAndRestore> createState() => _BackupAndRestoreState();
}

class _BackupAndRestoreState extends State<BackupAndRestore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('backup_page_title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'setting-page');
          },
        ),
        centerTitle: true,
      ),
      body: const BodyContent(),
    );
  }
}

class BodyContent extends StatefulWidget {
  const BodyContent({super.key});

  @override
  State<BodyContent> createState() => _BodyContentState();
}

String userEmail = '';
String userAvatar = '';

class _BodyContentState extends State<BodyContent> {
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "357589482333-sgggvbn10la0g2je2k862p93aonc0l4l.apps.googleusercontent.com",
  );

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    String getUserEmail = await CheckGoogleUserEmail.getUserEmail() ?? "";
    String getUserAvatar = await CheckGoogleUserAvatar.getUserAvatar() ?? "";

    setState(() {
      userEmail = getUserEmail;
      if (getUserAvatar != 'null') {
        userAvatar = getUserAvatar;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        googleSigInTile(
          // Tile onTap
          userAvatar == ''
              ? () {
                  googleLogin();
                }
              : () {
                  iconBtnBottomSheet();
                },
          // Icon Button OnPressed
          () {
            iconBtnBottomSheet();
          },
        ),
        userEmail != ''
            ? Column(
                children: [
                  backupAndRestoreTitle(
                    'backup_page_backup_tile_title'.tr(),
                    () {},
                  ),
                  backupAndRestoreTitle(
                    'backup_page_restore_tile_title'.tr(),
                    () {},
                  )
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Widget backupAndRestoreTitle(String title, Function() onTap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: ListTile(
        onTap: onTap,
        title: Text(title),
      ),
    );
  }

  Widget googleSigInTile(Function() onTap, Function() onPressed) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: ListTile(
          onTap: onTap,
          trailing: userEmail != ""
              ? IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.more_vert_outlined),
                  onPressed: onPressed,
                )
              : const SizedBox(),
          leading: userAvatar != ""
              ? CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    userAvatar,
                  ),
                )
              : Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
          title: userEmail == ""
              ? Text('backup_page_gg_tile_title'.tr())
              : Text('backup_page_gg_tile_subtitle'.tr()),
          subtitle: userEmail == ""
              ? googleSigInTileSubTitle('backup_page_gg_tile_title'.tr())
              : googleSigInTileSubTitle(userEmail)),
    );
  }

  Widget googleSigInTileSubTitle(title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        color: Colors.grey,
      ),
    );
  }

  iconBtnBottomSheet() {
    return showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return bottomSheetBody();
      },
    );
  }

  Widget bottomSheetBody() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.only(top: 8),
      height: height * 0.2,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(userEmail),
          SizedBox(
            width: width * 0.9,
            height: 45,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Text('backup_change_account_btn'.tr()),
              onPressed: () {
                googleChangeAccout();
              },
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: Text(
              'backup_remove_account_btn'.tr(),
            ),
            onPressed: () {
              googleSignOut();
              setState(() {
                userEmail = "";
                userAvatar = "";
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  googleChangeAccout() async {
    // await googleSignOut();
    // googleLogin();
  }

  googleLogin() async {
    try {
      var user = await GoogleSignIn().signIn();
      await CheckGoogleUserAvatar.setUserAvatar((user!.photoUrl).toString());
      await CheckGoogleUserEmail.setUserEmail(user.email);

      setState(() {
        userEmail = user.email;
        if (user.photoUrl == null) {
          userAvatar = "";
        } else {
          userAvatar = user.photoUrl!;
        }
      });
    } catch (error) {
      return null;
    }
  }

  googleSignOut() async {
    googleSignIn.signOut();
    CheckGoogleUserEmail.deleteUserEmail();
    CheckGoogleUserAvatar.deleteUserAvatar();
  }
}
