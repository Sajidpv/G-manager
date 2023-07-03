import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/widgets/validator.dart';

import '../../../../widgets/spacer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passController = TextEditingController();
  final idController = TextEditingController(text: 'EMP');
  UserType? selectedUserType;
  UserType? selectedEmployeeModel;
  Status? selectedStatus;
  String password = '';
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    mailController.dispose();
    passController.dispose();
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Padding(
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
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Employ ID',
                                style: TextStyle(fontSize: 12),
                              ),
                              TextFormField(
                                controller: idController,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(fontSize: 10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Employee id',
                                ),
                                validator: validaterEmpID,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(fontSize: 12),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: nameController,
                                style: const TextStyle(fontSize: 10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter employee name',
                                ),
                                validator: validaterMandatory,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                divider,
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: mailController,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 10),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'example@yourmail.com',
                            ),
                            validator: validateEmail),
                      ],
                    ),
                  ),
                ),
                divider,
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'User Type',
                                style: TextStyle(fontSize: 12),
                              ),
                              DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                hint: const Text(
                                  'Select Category',
                                  style: TextStyle(fontSize: 10),
                                ),
                                value: selectedUserType,
                                items: UserType.values.map((e) {
                                  return DropdownMenuItem<UserType>(
                                    value: e,
                                    child: Text(
                                      e.name.toString(),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (e) {
                                  setState(() {
                                    selectedUserType = e;
                                  });
                                },
                                validator: validateDropdown,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status',
                                style: TextStyle(fontSize: 12),
                              ),
                              DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                hint: const Text(
                                  'Select Status',
                                  style: TextStyle(fontSize: 10),
                                ),
                                value: selectedStatus,
                                items: Status.values.map((e) {
                                  return DropdownMenuItem<Status>(
                                    value: e,
                                    child: Text(
                                      e.name.toString(),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (e) {
                                  setState(() {
                                    selectedStatus = e;
                                  });
                                },
                                validator: validateDropdown,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                divider,
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Password',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            password = value;
                          },
                          controller: passController,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: const TextStyle(fontSize: 10),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '*********',
                          ),
                          validator: validatePassword,
                        ),
                      ],
                    ),
                  ),
                ),
                divider,
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Confirm Password',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: const TextStyle(fontSize: 10),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '**********',
                          ),
                          validator: (value) =>
                              validateConfirmPassword(value, password),
                        ),
                      ],
                    ),
                  ),
                ),
                divider,
                ElevatedButton(
                  onPressed: !isLoading
                      ? () {
                          if (formKey.currentState!.validate()) {
                            addEmployee();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ))),
                  child: !isLoading
                      ? const Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      : const CircularProgressIndicator(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addEmployee() async {
    formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    final empName = nameController.text;
    final empMail = mailController.text;
    final empPass = passController.text;
    final id = idController.text;
    if (selectedUserType == null) {
      return;
    }
    if (selectedStatus == null) {
      return;
    }
    final model = EmployeeModel(
        name: empName,
        email: empMail,
        type: selectedUserType!,
        status: selectedStatus!,
        password: empPass,
        empID: id);
    FirestoreUtil.addEmployee(model, context);

    setState(() {
      isLoading = false;
    });
  }
}
