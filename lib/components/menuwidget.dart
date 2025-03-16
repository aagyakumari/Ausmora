import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
      color: Colors.white,
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Horoscope'),
            onTap: () {
              Navigator.pushNamed(context, '/horoscope');
            },
          ),
          // Add other menu options here
        ],
      ),
    );
  }
}
