import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/colors_model.dart';
import 'package:hmanage/widgets/button.dart';
import 'package:hmanage/widgets/show_snack_bar.dart';
import 'package:hmanage/widgets/spacer.dart';
import 'package:hmanage/widgets/validator.dart';

class AddColors extends StatelessWidget {
  AddColors({super.key});
  final colorController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Color'),
      ),
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextFormField(
                      validator: validaterMandatory,
                      controller: colorController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 10),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: 'Enter Color',
                          label: Text(
                            'Color',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          )),
                    )),
              ),
              divider,
              CustomButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    addNewColor(context);
                  }
                },
                label: 'Add',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addNewColor(context) async {
    final color = colorController.text;
    colorController.clear();
    final model = ColorModel(color: color);
    FirestoreUtil.addColors(model, context);
    showSnackBar(context, '${model.color}  Added ');
  }
}
