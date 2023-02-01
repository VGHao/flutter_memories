import 'package:flutter/material.dart';

class BackupAndRestore extends StatelessWidget {
  const BackupAndRestore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Backup & Restore'),
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

class BodyContent extends StatelessWidget {
  const BodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GoogleSignInTile(),
        BackupAndRestoreTile(
          title: 'Backup Data',
          onTap: () {},
        ),
        BackupAndRestoreTile(
          title: 'Data Recovery',
          onTap: () {},
        ),
      ],
    );
  }
}

class GoogleSignInTile extends StatelessWidget {
  const GoogleSignInTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: ListTile(
        onTap: () {},
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.blue,
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: const Text('Backup Account'),
        subtitle: const Text(
          'Choose a Google Drive account',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class BackupAndRestoreTile extends StatelessWidget {
  final String title;
  final Function() onTap;
  const BackupAndRestoreTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: ListTile(
        onTap: onTap,
        title: Text(title),
      ),
    );
  }
}
