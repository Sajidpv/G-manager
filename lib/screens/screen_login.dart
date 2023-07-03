import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hmanage/forget_password.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/screens/splash_screen.dart';
import 'package:hmanage/widgets/show_snack_bar.dart';
import 'package:hmanage/widgets/validator.dart';

final _firebase = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isMatched = true;
  bool isAuthenticating = false;
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Container(
              height: screenHeight * 0.25,
              alignment: Alignment.center,
              child: const CircleAvatar()),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(227, 228, 228, 1),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(100))),
              alignment: Alignment.bottomCenter,
              height: screenHeight * 0.75,
              width: screenWidth,
              padding: EdgeInsets.all(screenWidth / 7),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 13, left: 20, bottom: 13),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(fontSize: 12),
                            ),
                            TextFormField(
                                controller: userController,
                                textInputAction: TextInputAction.next,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(fontSize: 10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'example@yourmail.com',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    isMatched = true;
                                  });
                                },
                                validator: validateEmail),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 13, left: 20, bottom: 13),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password',
                              style: TextStyle(fontSize: 12),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: passController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: const TextStyle(fontSize: 10),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter password',
                              ),
                              validator: validatePassword,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isMatched,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          errorText,
                          style: TextStyle(
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: !isAuthenticating
                            ? () {
                                if (formKey.currentState!.validate()) {
                                  loginCheck(context);
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 20.0),
                            backgroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ))),
                        child: !isAuthenticating
                            ? const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            : const CircularProgressIndicator()),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPassword()));
                      },
                      child: const Text(
                        'Forget Password? Reset Now',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void loginCheck(BuildContext ctx) async {
    formKey.currentState!.save();
    setState(() {
      isAuthenticating = true;
    });

    final username = userController.text;
    final password = passController.text;

    try {
      await _firebase.signInWithEmailAndPassword(
          email: username, password: password);
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: username);

      final userSnapshot = await userDoc.get();
      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data();
        String userType = userData['type'];
        EmployeeModel employe = EmployeeModel.fromJson(userData);

        Status userStatus = Status.values.firstWhere(
            (status) => status.toString() == 'Status.${userData['status']}');

        if (userStatus == Status.Inactive) {
          setState(() {
            isMatched = false;
            errorText = 'The user is Inactive';
          });
        } else if (userStatus == Status.Suspended) {
          setState(() {
            isMatched = false;
            errorText = 'The user is Suspended';
          });
        } else {
          navigateToHomeScreen(userType, employe, ctx);
        }
      } else {
        setState(() {
          isMatched = false;
          errorText = 'User maybe Deleted. Contact Your admin';
        });
      }
      setState(() {
        isAuthenticating = false;
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        showSnackBar(context, 'Email already in use');
      } else {
        setState(() {
          isAuthenticating = false;
          errorText = error.message!;
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        showSnackBar(context, error.message ?? 'Authentication Failed');
      }
    }
  }
}
