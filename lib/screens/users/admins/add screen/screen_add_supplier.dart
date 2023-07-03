import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/supplier_model.dart';
import 'package:hmanage/widgets/button.dart';
import 'package:hmanage/widgets/validator.dart';

import '../../../../widgets/spacer.dart';

//Add Supplier
class AddSupplier extends StatefulWidget {
  const AddSupplier({super.key});

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  final formKey = GlobalKey<FormState>();

  final suppNameController = TextEditingController();

  final suppAddressController = TextEditingController();
  Status? selectedStatus;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(title: const Text('Add Supplier')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
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
                          controller: suppNameController,
                          style: const TextStyle(fontSize: 10),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter supplier Name',
                          ),
                          validator: validaterMandatory,
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
                          'Address',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          maxLength: 30,
                          maxLines: 4,
                          controller: suppAddressController,
                          style: const TextStyle(fontSize: 10),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter supplier address',
                          ),
                          validator: validaterMandatory,
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
                          'Status',
                          style: TextStyle(fontSize: 12),
                        ),
                        DropdownButtonFormField(
                          decoration:
                              const InputDecoration(border: InputBorder.none),
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
                              selectedStatus = e as Status;
                            });
                          },
                          validator: validateDropdown,
                        ),
                      ],
                    ),
                  ),
                ),
                divider,
                CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      addSuppliers();
                    }
                  },
                  label: 'Add Supplier',
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> addSuppliers() async {
    final supName = suppNameController.text;
    final supDesc = suppAddressController.text;
    final model = SupplierModel(supName, supDesc, selectedStatus!);
    await FirestoreUtil.addSupplier(model, context);
  }
}
