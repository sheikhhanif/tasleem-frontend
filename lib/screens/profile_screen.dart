import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // You can pass user data if needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        // Build out the profile UI
        child: Text('User Profile'),
      ),
    );
  }
}
