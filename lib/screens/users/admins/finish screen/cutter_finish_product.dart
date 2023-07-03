import 'package:flutter/material.dart';

import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/color_quantity_model.dart';
import 'package:hmanage/models/colors_model.dart';

import 'package:hmanage/models/cutter_finishing_model.dart';

import 'package:hmanage/models/cutter_assigned_model.dart';

import 'package:hmanage/screens/splash_screen.dart';
import 'package:hmanage/screens/users/admins/add%20screen/add_colors.dart';
import 'package:hmanage/widgets/select_date.dart';

import 'package:hmanage/widgets/spacer.dart';
import 'package:hmanage/widgets/validator.dart';
import 'package:shimmer/shimmer.dart';

//cutter finishing
class CutterFinishItems extends StatefulWidget {
  const CutterFinishItems({super.key, required this.emp});
  final CutterAssignModel emp;

  @override
  State<CutterFinishItems> createState() => _CutterFinishItems();
}

class _CutterFinishItems extends State<CutterFinishItems> {
  final formKey = GlobalKey<FormState>();
  final formKeyColor = GlobalKey<FormState>();
  String formatedDate = 'Select Date';
  DateTime selectedDate = DateTime.now();
  final layerQuantityController = TextEditingController();
  final meterQuantityController = TextEditingController();
  final quantityController = TextEditingController();
  final balanceController = TextEditingController(text: '0');
  final damageController = TextEditingController(text: '0');
  final wasteController = TextEditingController(text: '0');
  final pieceController = TextEditingController();
  String errorMessage = '';
  ColorModel? selectedColor;
  double availableQuantity = 0;
  double initialQuantity = 0;
  double totalQuantity = 0;
  double totalPiece = 0;
  double balanceQuantity = 0;
  double totalBalance = 0;
  bool isVisible = false;
  bool isError = false;
  List<ColorQuantityModel> colorQuantity = [];
  ValueNotifier<List<ColorQuantityModel>> colorQuantityNotifier =
      ValueNotifier([]);
  Future<List<ColorModel>>? colors;
  @override
  void initState() {
    colors = FirestoreUtil.getColors([]);
    availableQuantity = widget.emp.quantity;
    initialQuantity = availableQuantity;
    super.initState();
  }

  @override
  void dispose() {
    wasteController.dispose();
    balanceController.dispose();
    damageController.dispose();

    quantityController.dispose();
    layerQuantityController.dispose();
    meterQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    colorQuantityNotifier.value.addAll(colorQuantity.toList());
    final String title = widget.emp.product.name;
    final String material = widget.emp.stockID.name;
    final String eName = widget.emp.employID.name;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () {
                pageNavigator(AddColors(), context);
              },
              icon: const Icon(Icons.add))
        ],
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
                                  eName,
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
                                  material,
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
                                  'Assigned Fabric',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  availableQuantity.toString(),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Layer Count',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  controller: layerQuantityController,
                                  style: const TextStyle(fontSize: 10),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Layer',
                                  ),
                                  onChanged: (value) {
                                    total();
                                    totalPiec();
                                  },
                                  validator: (value) => layerQuantityValidator(
                                      value, totalQuantity, availableQuantity),
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
                                  'Meter/Layer',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  controller: meterQuantityController,
                                  style: const TextStyle(fontSize: 10),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Meter',
                                  ),
                                  onChanged: (value) {
                                    total();
                                  },
                                  validator: (value) => layerQuantityValidator(
                                      value, totalQuantity, availableQuantity),
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
                                  'Piece/Layer',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                TextFormField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    controller: pieceController,
                                    style: const TextStyle(fontSize: 10),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Piece',
                                    ),
                                    onChanged: (value) {
                                      total();
                                      totalPiec();
                                    },
                                    validator: validaterMandatory),
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
                                  'Used Fabric',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  totalQuantity.toString(),
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
                                  'Total Balance',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  totalBalance.toString(),
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
                                  'Total Piece',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  totalPiece.toString(),
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
                      child: Form(
                        key: formKeyColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Color',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  FutureBuilder<List<ColorModel>>(
                                    future: colors,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData) {
                                          final List<ColorModel> colorList =
                                              snapshot.data!;
                                          return DropdownButtonFormField<
                                              ColorModel>(
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            hint: const Text(
                                              'Select Color',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            value: selectedColor,
                                            items: colorList.map((color) {
                                              return DropdownMenuItem<
                                                  ColorModel>(
                                                value: color,
                                                child: Text(
                                                  color.color,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (stockItem) {
                                              setState(() {
                                                selectedColor = stockItem;
                                              });
                                            },
                                            validator: validateDropdown,
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
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
                              width: 25,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Piece',
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    controller: quantityController,
                                    style: const TextStyle(fontSize: 10),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter quantity',
                                    ),
                                    validator: (value) =>
                                        validatorColorQuantity(
                                            value, totalPiece),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: TextButton.icon(
                                onPressed: () {
                                  if (formKeyColor.currentState!.validate()) {
                                    addQuantity();
                                    isVisible = true;
                                  }
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add '),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                divider,
                Visibility(
                  visible: isVisible,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromARGB(255, 255, 255, 255)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Entered Quantity',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: colorQuantity.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shadowColor: Colors.grey.shade400,
                                elevation: 20,
                                color: Colors.grey.shade100,
                                child: ListTile(
                                  title: Text(
                                    colorQuantity[index].color.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  subtitle: Text(
                                    colorQuantity[index].quantity.toString(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        colorQuantity.removeAt(index);
                                      },
                                      icon: const Icon(Icons.close)),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  controller: balanceController,
                                  style: const TextStyle(fontSize: 10),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Balance',
                                  ),
                                  onChanged: (value) {
                                    totalBal();
                                    total();
                                  },
                                  validator: (value) =>
                                      balanceQuantityValidator(
                                          value,
                                          totalQuantity,
                                          availableQuantity,
                                          totalBalance),
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
                                    hintText: 'Enter Damage',
                                  ),
                                  onChanged: (value) {
                                    totalBal();
                                    total();
                                  },
                                  validator: (value) =>
                                      balanceQuantityValidator(
                                          value,
                                          totalQuantity,
                                          availableQuantity,
                                          totalBalance),
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
                                  'Wastage',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  controller: wasteController,
                                  style: const TextStyle(fontSize: 10),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter wastage',
                                  ),
                                  onChanged: (value) {
                                    totalBal();
                                    total();
                                  },
                                  validator: (value) =>
                                      balanceQuantityValidator(
                                          value,
                                          totalQuantity,
                                          availableQuantity,
                                          totalBalance),
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
                Visibility(
                  visible: isError,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ),
                divider,
                ElevatedButton(
                    onPressed: () {
                      if (totalPiece > 0) {
                        setState(() {
                          isError = true;
                          errorMessage = 'You should add all piece to submit';
                        });
                        if ((totalBalance + totalQuantity) >
                            availableQuantity) {
                          setState(() {
                            isError = true;
                            errorMessage =
                                'Used Fabric should not exceed Assigned Fabrics';
                          });
                        }
                      } else if (formKey.currentState!.validate()) {
                        addToFinish();
                      }
                    },
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
                    child: const Text(
                      ' Add to Finish',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void addQuantity() {
    final quantity = double.tryParse(quantityController.text);
    setState(() {
      colorQuantity.add(ColorQuantityModel(
          selectedColor!.id, selectedColor!.color, quantity!));
      totalPiece -= quantity;
      quantityController.clear();
      selectedColor = null;
    });
  }

  void total() {
    final meterQuantity = double.tryParse(meterQuantityController.text);
    final layerQuantity = double.tryParse(layerQuantityController.text);
    if (meterQuantity != null && layerQuantity != null) {
      setState(() {
        totalQuantity = (layerQuantity * meterQuantity) + totalBalance;
        colorQuantity.clear();
        isVisible = false;
      });
    }
  }

  void totalPiec() {
    final pieceCount = double.tryParse(pieceController.text);
    final layerQuantity = double.tryParse(layerQuantityController.text);
    if (pieceCount != null && layerQuantity != null) {
      setState(() {
        totalPiece = pieceCount * layerQuantity;
      });
    }
  }

  void totalBal() {
    final balanceQuantity = double.tryParse(balanceController.text);
    final wasteQuantity = double.tryParse(wasteController.text);
    final damageQuantity = double.tryParse(damageController.text);

    setState(() {
      totalBalance = balanceQuantity! + wasteQuantity! + damageQuantity!;
    });
  }

  Future<void> addToFinish() async {
    final emp = widget.emp;
    final pieceCount = double.tryParse(pieceController.text);
    final meterQuantity = double.tryParse(meterQuantityController.text);
    final layerQuantity = double.tryParse(layerQuantityController.text);
    final balanceQuantity = double.tryParse(balanceController.text);
    final wasteQuantity = double.tryParse(wasteController.text);
    final damageQuantity = double.tryParse(damageController.text);

    final empId = emp.employID;
    final proId = emp.product;
    final stockId = emp.stockID;

    if (colorQuantity.isEmpty) {
      isError = true;
      errorMessage = 'Error Occured! Try again';
      return;
    }

    final model = CutterFinishingModel(
        balanceQuantity!, wasteQuantity!, damageQuantity!,
        date: selectedDate,
        employId: empId,
        productId: proId,
        materialId: stockId,
        layerCount: layerQuantity!,
        meterLayer: meterQuantity!,
        pieceLayer: pieceCount!,
        quantity: colorQuantity,
        batchID: emp.batchID,
        usedFabrics: totalQuantity,
        proAssignID: emp.proAssignID);
    FirestoreUtil.finishCutter(model, context);
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
