import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/color_quantity_model.dart';
import 'package:hmanage/models/cutter_finishing_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/tailer_assign_model.dart';
import 'package:hmanage/models/tailer_finishing_model.dart';
import 'package:hmanage/widgets/button.dart';
import 'package:hmanage/widgets/select_date.dart';
import 'package:hmanage/widgets/spacer.dart';
import 'package:hmanage/widgets/validator.dart';

// tailer finishing
class TailerFinishItem extends StatefulWidget {
  const TailerFinishItem({
    super.key,
    required this.emp,
  });
  final TailerAssignModel emp;

  @override
  State<TailerFinishItem> createState() => _TailerFinishItemState();
}

class _TailerFinishItemState extends State<TailerFinishItem> {
  final formKey = GlobalKey<FormState>();
  String formatedDate = 'Select Date';
  DateTime selectedDate = DateTime.now();
  final quantController = TextEditingController();
  final damageController = TextEditingController(text: '0');
  double availableQuantiy = 0;
  double balanceQuantity = 0;
  double? quantity;
  EmployeeModel? selectedEmployee;

  CutterFinishingModel? selectedProduct;
  ColorQuantityModel? selectedColorItem;

  @override
  void initState() {
    super.initState();
    availableQuantiy = widget.emp.quantity;
  }

  @override
  void dispose() {
    damageController.dispose();
    quantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emp = widget.emp;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(emp.productId.productId.name),
      ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Employee',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  emp.employId.name,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Material',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  emp.productId.materialId.name,
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Color',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  emp.color.color,
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
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
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quantity',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                TextFormField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    controller: quantController,
                                    style: const TextStyle(fontSize: 10),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Quantity',
                                    ),
                                    onChanged: (value) {
                                      total();
                                    },
                                    validator: (value) => quandityValidator(
                                        value, availableQuantiy.toString())),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Available Quantity',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  availableQuantiy.toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
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
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Damage',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  controller: damageController,
                                  style: const TextStyle(fontSize: 10),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Damages',
                                  ),
                                  onChanged: (value) {
                                    total();
                                  },
                                  validator: (value) => damageValidator(
                                    value,
                                    quantity,
                                    availableQuantiy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  balanceQuantity.toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                divider,
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          TextButton.icon(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              formatedDate.toString(),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                            ),
                          ),
                        ],
                      )),
                ),
                divider,
                CustomButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        finishItem();
                      }
                    },
                    label: 'Add to Finish')
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void total() {
    quantity = double.tryParse(quantController.text);
    final damage = double.tryParse(damageController.text);
    if (quantity == null || damage == null) {
      return;
    }
    setState(() {
      balanceQuantity = availableQuantiy - (quantity! + damage);
    });
  }

  Future<void> finishItem() async {
    final emp = widget.emp;
    final quantity = quantController.text;
    final damage = damageController.text;

    final parsedQuantity = double.tryParse(quantity);
    if (parsedQuantity == null) {
      return;
    }
    final parseddamage = double.tryParse(damage);
    if (parseddamage == null) {
      return;
    }
    final employ = emp.employId;
    final product = emp.productId;
    final selectedcolor = emp.color;

    final model = TailerFinishingModel(
        date: selectedDate,
        employID: employ,
        productID: product,
        color: selectedcolor,
        quantity: parsedQuantity,
        batchId: emp.batchId,
        tailerAssignID: emp.tailerAssignID,
        assignedQuantity: parsedQuantity,
        damage: parseddamage);
    FirestoreUtil.finishTailer(model, context);
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await selectDate(context);

    if (pickedDate != null) {
      setState(() {
        formatedDate = formatDate(pickedDate);
        selectedDate = pickedDate;
      });
    }
  }
}
