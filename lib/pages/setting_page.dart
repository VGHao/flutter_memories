import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color(0xFFE5F5FF),
        title: const Text('Settings'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFE5F5FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Data Scurity
          const ComponentTitle(
            title: 'Data Security',
          ),
          const SettingItems(
            icon: Icons.lock_outline,
            title: 'Diary Lock',
          ),
          const SettingItems(
            icon: Icons.cloud_upload_outlined,
            title: 'Backup & Restore',
          ),

          // Notifications
          const ComponentTitle(
            title: 'Notifications',
          ),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Icon(
                    Icons.notifications,
                    size: 28,
                    color: Colors.blueAccent,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Reminder time',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '21:00',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Switch(
                      value: active,
                      onChanged: (bool value) {
                        setState(() {
                          active = value;
                        });
                      }),
                )
              ],
            ),
          ),

          // Appearance
          const ComponentTitle(
            title: 'Appearance',
          ),
          const SettingItems(
            icon: Icons.color_lens_outlined,
            title: 'Theme',
          ),

          // Other
          const ComponentTitle(
            title: 'Other',
          ),
          const SettingItems(
            icon: Icons.security,
            title: 'Privacy Policy',
          ),
          const SettingItems(
            icon: Icons.shield,
            title: 'Tems & Conditions',
          ),
          const SettingItems(
            icon: Icons.info_outline,
            title: 'About us',
          ),
        ],
      ),
    );
  }
}

class ComponentTitle extends StatelessWidget {
  final String title;

  const ComponentTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class SettingItems extends StatelessWidget {
  final IconData icon;
  final String title;

  const SettingItems({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Icon(
              icon,
              color: Colors.blueAccent,
              size: 28,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
