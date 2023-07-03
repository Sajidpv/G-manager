import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hmanage/widgets/button.dart';
import 'package:hmanage/widgets/show_snack_bar.dart';

import 'package:hmanage/widgets/validator.dart';

final _firebase = FirebaseAuth.instance;

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});
  final mailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade200,
        elevation: .2,
      ),
      backgroundColor: Colors.amber.shade200,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextFormField(
                      validator: validateEmail,
                      controller: mailController,
                      style: const TextStyle(fontSize: 10),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: 'Enter Email',
                          label: Text(
                            'Email',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          )),
                    )),
              ),
              const SizedBox(
                height: 40,
              ),
              CustomButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    try {
                      _firebase.sendPasswordResetEmail(
                          email: mailController.text.trim());
                      ScaffoldMessenger.of(context).clearSnackBars();
                      showSnackBar(context,
                          'Password Reset mail sent to ${mailController.text}');
                      Navigator.pop(context);
                    } on FirebaseAuthException catch (error) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      showSnackBar(
                          context, error.message ?? 'Authentication Failed');
                    }
                  }
                },
                label: 'Sent',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
