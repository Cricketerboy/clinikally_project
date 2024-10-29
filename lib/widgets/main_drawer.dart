import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Widget buildList(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(
        title,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            padding: EdgeInsets.only(top: 20, left: 20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).colorScheme.primary,
            child: const Text(
              'Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          buildList(
            'Profile',
            CupertinoIcons.person,
            () {},
          ),
          buildList(
            'Cart',
            CupertinoIcons.person,
            () {},
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Made with ❤️ in India',
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
