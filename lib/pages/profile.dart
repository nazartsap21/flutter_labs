import 'package:flutter/material.dart';
import 'package:flutter_lab/widgets/profile_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileInfoCard(
            name: 'Nazar Tsap', 
            email: 'nazar.tsap@gmail.com',
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text('Status: Active', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
