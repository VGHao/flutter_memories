import 'package:flutter/material.dart';

import '../widgets/drawer_items.dart';

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
      backgroundColor: const Color(0xFFE5F5FF),
      drawer: SafeArea(
        child: Drawer(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Image.asset('assets/images/drawer_header.png'),
                ),
                DrawerItems(
                  icon: Icons.color_lens_outlined,
                  title: "Theme",
                  onTap: () {},
                ),
                const Divider(
                  height: 10.0,
                  indent: 15,
                  endIndent: 20,
                  thickness: 1,
                ),
                DrawerItems(
                  icon: Icons.lock_outlined,
                  title: "Diary Lock",
                  onTap: () {},
                ),
                DrawerItems(
                  icon: Icons.backup_outlined,
                  title: "Backup & Restore",
                  onTap: () {},
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 1,
                ),
                DrawerItems(
                  icon: Icons.card_giftcard_outlined,
                  title: "Donate",
                  onTap: () {},
                ),
                DrawerItems(
                  icon: Icons.share_outlined,
                  title: "Share App",
                  onTap: () {},
                ),
                DrawerItems(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/empty-list.png'),
                const Text(
                  "There is nothing here",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  "Click '+' button to start writing your first journey",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor:
                        Colors.black.withOpacity(0.3), // <-- Button color
                    foregroundColor: Colors.white, // <-- Splash color
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.blue, // <-- Button color
                    foregroundColor: Colors.white, // <-- Splash color
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.black.withOpacity(0.3),
                    foregroundColor: Colors.white, // <-- Splash color
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
