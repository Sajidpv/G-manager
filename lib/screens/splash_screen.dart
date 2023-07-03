// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/screens/users/employess/cutter_home.dart';
import 'package:hmanage/screens/users/employess/finisher_home.dart';
import 'package:hmanage/screens/users/employess/screen_home_production.dart';
import 'package:hmanage/screens/screen_login.dart';
import 'package:hmanage/screens/users/admins/screen_home_admin.dart';
import 'package:hmanage/screens/users/employess/tailer_home.dart';
import 'package:hmanage/widgets/show_snack_bar.dart';

class Splash extends StatefulWidget {
  const Splash({
    Key? key,
  }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isSplashFinished = false;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..addListener(() {});

    controller.repeat(reverse: true);

    super.initState();

    Future.delayed(Duration(seconds: 2)).then((_) {
      setState(() {
        isSplashFinished = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: isSplashFinished
          ? StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 20, 21, 24),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  checkUserLogged(context, user.email);
                  return Container();
                } else {
                  return const LoginPage();
                }
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: controller.value,
                    semanticsLabel: 'Circular progress indicator',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 20, 21, 24),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// Widget splashScreen() {
//     return Container(

//       child: InkWell(
//         child: Stack(
//           children: <Widget>[
//             CircleAvatar(
//               backgroundColor: Colors.transparent,
//               radius: 140.0,
//               child: Hero(
//                 tag: "backgroundImageInSplash",
//                 child: Container(
//                   child: Image.asset(
//                       "assets/splash_login_registration_background_image.png"),
//                 ),
//               ),
//             ),
//             Positioned.fill(
//               top: DeviceInfo(context).height/2-72,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10.0),
//                     child: Hero(
//                       tag: "splashscreenImage",
//                       child: Container(
//                         height: 72,
//                         width: 72,
//                         padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
//                         decoration: BoxDecoration(
//                           color: MyTheme.white,
//                           borderRadius: BorderRadius.circular(8)
//                         ),
//                         child: Image.asset(
//                             "assets/splash_screen_logo.png",
//                           filterQuality: FilterQuality.low,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 5.0),
//                     child: Text(
//                       AppConfig.app_name,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14.0,
//                           color: Colors.white),
//                     ),
//                   ),
//                   Text(
//                     "V " + _packageInfo.version,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14.0,
//                         color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 51.0),
//                   child: Text(
//                     AppConfig.copyright_text,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13.0,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     /*
//             Padding(
//               padding: const EdgeInsets.only(top: 120.0),
//               child: Container(
//                   width: double.infinity,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[

//                     ],
//                   )),
//             ),*/
//           ],
//         ),
//       ),
//     );
//   }

Future<void> checkUserLogged(context, email) async {
  try {
    final userDoc = FirebaseFirestore.instance.collection('users');
    final userSnapshot = await userDoc.where('email', isEqualTo: email).get();

    if (userSnapshot.docs.isNotEmpty) {
      var userData = userSnapshot.docs.first.data();
      String userType = userData['type'];
      EmployeeModel employe = EmployeeModel.fromJson(userData);
      navigateToHomeScreen(userType, employe, context);
    } else {
      pageNavigator(LoginPage(), context);
    }
  } on FirebaseException catch (error) {
    ScaffoldMessenger.of(context).clearSnackBars();
    showSnackBar(context, error.message ?? 'Authentication Failed');
  }
}

Future<void> pageNavigator(Widget page, BuildContext context) async {
  await Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (ctx) => page,
  ));
}

void navigateToHomeScreen(role, employ, BuildContext context) async {
  const Splash();
  switch (role) {
    case 'Admin':
      pageNavigator(AdminHome(), context);
      break;
    case 'Production':
      pageNavigator(ProductionHome(), context);
      break;
    // case 'Purchaser':
    //   pageNavigator(PurchaseHome(), context);
    //   break;
    // case 'Sales':
    //   pageNavigator(SalesHome(), context);
    //   break;
    // case 'Accountant':
    //   pageNavigator(AccountsHome(), context);
    //   break;
    case 'Tailer':
      pageNavigator(
          TailerHome(
            empID: employ,
          ),
          context);
      break;
    case 'Cutter':
      pageNavigator(
          CutterHome(
            empID: employ,
          ),
          context);
      break;
    case 'Finisher':
      pageNavigator(
          FinisherHome(
            empID: employ,
          ),
          context);
      break;
    default:
      pageNavigator(LoginPage(), context);
      break;
  }
}
