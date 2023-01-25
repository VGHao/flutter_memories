import 'package:flutter/material.dart';
import '../pages/change_theme.dart';
import '../pages/setting_page.dart';
import 'drawer_items.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(),
                child: Image.asset('assets/images/drawer_header.png'),
              ),
              DrawerItems(
                icon: Icons.color_lens_outlined,
                title: "drawer_theme".tr(),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangeTheme()),
                  );
                },
              ),
              const Divider(
                height: 10.0,
                indent: 15,
                endIndent: 20,
                thickness: 1,
              ),
              DrawerItems(
                icon: Icons.lock_outlined,
                title: "drawer_diary_lock".tr(),
                onTap: () {},
              ),
              DrawerItems(
                icon: Icons.backup_outlined,
                title: "drawer_backup_restore".tr(),
                onTap: () {},
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
                thickness: 1,
              ),
              DrawerItems(
                icon: Icons.card_giftcard_outlined,
                title: "drawer_donate".tr(),
                onTap: () {},
              ),
              DrawerItems(
                icon: Icons.share_outlined,
                title: "drawer_share_app".tr(),
                onTap: () {},
              ),
              DrawerItems(
                icon: Icons.settings_outlined,
                title: "drawer_settings".tr(),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
