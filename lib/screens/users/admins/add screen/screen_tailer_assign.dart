import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/color_quantity_model.dart';
import 'package:hmanage/models/cutter_finishing_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/tailer_assign_model.dart';
import 'package:hmanage/widgets/button.dart';
import 'package:hmanage/widgets/spacer.dart';
import 'package:hmanage/widgets/validator.dart';
import 'package:shimmer/shimmer.dart';

//Asssign product to tailer
class AssignToTailer extends StatefulWidget {
  const AssignToTailer({
    super.key,
  });

  @override
  State<AssignToTailer> createState() => _AssignToTailerState();
}

class _AssignToTailerState extends State<AssignToTailer> {
  final formKey = GlobalKey<FormState>();

  final quantController = TextEditingController();
  String availableQuantiy = 'Select a Color';
  double? quantityBalance;
  String balance = 'Select Material';
  String batch = 'Select a Material';
  EmployeeModel? selectedEmployee;
  Future<List<EmployeeModel>>? tailers;
  Future<List<CutterFinishingModel>>? products;
  CutterFinishingModel? selectedProduct;
  ColorQuantityModel? selectedColorItem;
  String material = 'Select a Product';

  @override
  void initState() {
    tailers = FirestoreUtil.getFilterdUsers(UserType.Tailer);
    products = FirestoreUtil.getFinishCutter([]);
    super.initState();
  }

  @override
  void dispose() {
    quantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Assign To Tailer'),
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
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Employee',
                                style: TextStyle(fontSize: 12),
                              ),
                              FutureBuilder<List<EmployeeModel>>(
                                future: tailers,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      final List<EmployeeModel> cutterList =
                                          snapshot.data!;
                                      return DropdownButtonFormField<
                                          EmployeeModel>(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: const Text(
                                          'Select Employee',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        value: selectedEmployee,
                                        items: cutterList.map((emp) {
                                          return DropdownMenuItem<
                                              EmployeeModel>(
                                            value: emp,
                                            child: Text(
                                              emp.name,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (emp) {
                                          setState(() {
                                            selectedEmployee = emp;
                                          });
                                        },
                                        validator: validateDropdown,
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                  }

                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  );
                                },
                              )
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
                                'Product',
                                style: TextStyle(fontSize: 12),
                              ),
                              FutureBuilder<List<CutterFinishingModel>>(
                                future: products,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      final List<CutterFinishingModel>
                                          productList = snapshot.data!;
                                      return DropdownButtonFormField<
                                          CutterFinishingModel>(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: const Text(
                                          'Select Product',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        value: selectedProduct,
                                        items: productList.map((item) {
                                          return DropdownMenuItem<
                                              CutterFinishingModel>(
                                            value: item,
                                            child: Text(
                                              item.productId.name,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (item) {
                                          setState(() {
                                            selectedProduct = item;
                                            selectedColorItem = null;
                                            availableQuantiy = 'Select Color';
                                            balance = 'Select Color';
                                            batch = selectedProduct!.batchID;
                                            material = selectedProduct!
                                                .materialId.name;
                                          });
                                        },
                                        validator: validateDropdown,
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                  }

                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  );
                                },
                              )
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
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Colors',
                                style: TextStyle(fontSize: 12),
                              ),
                              DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                hint: const Text(
                                  'Select Color',
                                  style: TextStyle(fontSize: 10),
                                ),
                                value: selectedColorItem,
                                items: selectedProduct?.quantity.map((e) {
                                  return DropdownMenuItem<ColorQuantityModel>(
                                    value: e,
                                    child: Text(
                                      e.color,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (e) {
                                  setState(() {
                                    selectedColorItem = e;
                                    balance = 'Enter Quantity';
                                    availableQuantiy =
                                        selectedColorItem!.quantity.toString();
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Material',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                material,
                                style: const TextStyle(fontSize: 10),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Batch',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                batch,
                                style: const TextStyle(fontSize: 10),
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
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
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
                                    finalBalance();
                                  },
                                  validator: (value) => quandityValidator(
                                      value, availableQuantiy),
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
                                  'Available Quantity',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  availableQuantiy,
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
                                  'Balance',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  balance,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
                divider,
                CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      assignItem();
                    }
                  },
                  label: 'Assign to Tailer',
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void finalBalance() {
    final availableQuantity = double.tryParse(availableQuantiy);
    final quantity = double.tryParse(quantController.text);
    if (availableQuantity == null || quantity == null) {
      return;
    }
    final bal = availableQuantity - quantity;
    setState(() {
      balance = bal.toString();
    });
  }

  Future<void> assignItem() async {
    final quantity = quantController.text;

    final parsedQuantity = double.tryParse(quantity);

    if (parsedQuantity == null) {
      return;
    }
    final parsedAvailableQuantity = double.tryParse(availableQuantiy);

    if (parsedAvailableQuantity == null) {
      return;
    }

    final model = TailerAssignModel(
        date: DateTime.now(),
        employId: selectedEmployee!,
        productId: selectedProduct!,
        color: selectedColorItem!,
        quantity: parsedQuantity,
        batchId: batch,
        assignedQuantity: parsedQuantity);
    FirestoreUtil.assignTailer(model, context);
    Navigator.pop(context);
  }
}
