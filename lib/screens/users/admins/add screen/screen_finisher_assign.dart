import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/color_quantity_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/finisher_assign_model.dart';
import 'package:hmanage/models/tailer_finishing_model.dart';
import 'package:hmanage/widgets/button.dart';
import 'package:hmanage/widgets/spacer.dart';
import 'package:hmanage/widgets/validator.dart';
import 'package:shimmer/shimmer.dart';

//Asssign product to Finisher
class AssignToFinisher extends StatefulWidget {
  const AssignToFinisher({
    super.key,
  });

  @override
  State<AssignToFinisher> createState() => _AssignToFinisherState();
}

class _AssignToFinisherState extends State<AssignToFinisher> {
  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  final quantController = TextEditingController();
  String availableQuantiy = 'Select a Product';
  String balance = 'Enter Quantity';
  double? quantityBalance;
  ColorQuantityModel? selectedColorItem;
  EmployeeModel? selectedEmployee;
  Future<List<EmployeeModel>>? finishers;
  Future<List<TailerFinishingModel>>? products;
  TailerFinishingModel? selectedProduct;
  String batch = 'Select a Product';

  @override
  void initState() {
    super.initState();
    finishers = FirestoreUtil.getFilterdUsers(UserType.Finisher);
    products = FirestoreUtil.getFinishTailer([]);
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
        title: const Text('Assign To Finisher'),
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
                                future: finishers,
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
                                'Material',
                                style: TextStyle(fontSize: 12),
                              ),
                              FutureBuilder<List<TailerFinishingModel>>(
                                future: products,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      final List<TailerFinishingModel>
                                          productList = snapshot.data!;
                                      return DropdownButtonFormField<
                                          TailerFinishingModel>(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: const Text(
                                          'Select Material',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        value: selectedProduct,
                                        items: productList.map((item) {
                                          return DropdownMenuItem<
                                              TailerFinishingModel>(
                                            value: item,
                                            child: Text(
                                              item.productID.materialId.name,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (item) {
                                          setState(() {
                                            selectedProduct = item;
                                            selectedColorItem = item!.color;
                                            availableQuantiy =
                                                item.quantity.toString();
                                            batch = selectedProduct!.batchId;
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Item Color',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  selectedColorItem != null
                                      ? selectedColorItem!.color.toString()
                                      : 'Select Product',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            )),
                        Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Product',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  selectedProduct != null
                                      ? selectedProduct!
                                          .productID.productId.name
                                      : 'Select a Material',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            )),
                        Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Item Batch',
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
                            ))
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
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
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
                                  style: const TextStyle(fontSize: 12),
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
                      Navigator.pop(context);
                    }
                  },
                  label: 'Assign to Finisher',
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
    final parsedQuantity = double.tryParse(quantController.text);

    if (parsedQuantity == null) {
      return;
    }
    final parsedAvailableQuantity = double.tryParse(availableQuantiy);

    if (parsedAvailableQuantity == null) {
      return;
    }

    final model = FinisherAssignModel(
        date: selectedDate,
        batchId: batch,
        employID: selectedEmployee!,
        productID: selectedProduct!,
        color: selectedColorItem!,
        quantity: parsedQuantity,
        assignedQuantity: parsedQuantity);
    FirestoreUtil.assignFinisher(model, context);
  }
}
