import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/passcode_page.dart';
import '../services/secure_storage.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/floating_action_widget.dart';

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
      backgroundColor: const Color(0xFFE5F5FF),
      drawer: const DrawerWidget(),
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
                  "Click + button to start writing your first journey",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const FloatingButtonWidget(),
        ],
      ),
    );
  }
}
