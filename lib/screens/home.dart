import 'package:flutter/material.dart';

import 'users/admins/screen_home_admin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? activeScreen;
  @override
  void initState() {
    activeScreen = const AdminHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: activeScreen);
  }
}
