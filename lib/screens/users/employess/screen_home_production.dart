import 'package:flutter/material.dart';
import 'package:hmanage/screens/screen_production.dart';
import 'package:hmanage/sections/fab_with_menu.dart';
import 'package:hmanage/widgets/constants.dart';
import 'package:hmanage/widgets/signout.dart';

class ProductionHome extends StatefulWidget {
  const ProductionHome({super.key});

  @override
  State<ProductionHome> createState() => _ProductionHomeState();
}

class _ProductionHomeState extends State<ProductionHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Production Home',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: ListTile(
                  title: Text(
                    'Production Admin',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const AboutListTile(
              icon: Icon(
                Icons.info,
              ),
              applicationIcon: Icon(
                Icons.store,
              ),
              applicationName: 'HaashStore',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2023 Haash Technologies',
              aboutBoxChildren: [],
              child: Text('About app'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                signOut(context);
              },
            ),
          ],
        ),
      ),
      body: const ProductionDetails(),
      floatingActionButton: FabWithIcons(
        icons: icons2,
        onIconTapped: (index) {},
        tooltips: fabTooltips2,
        screen: 'production',
      ),
    );
  }
}
