import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/cutter_assigned_model.dart';
import 'package:hmanage/models/finisher_assign_model.dart';
import 'package:hmanage/models/stock_model.dart';
import 'package:hmanage/models/tailer_assign_model.dart';
import 'package:hmanage/widgets/no_data_screen.dart';
import 'package:hmanage/widgets/shimmer_effect.dart';

class ProcessPage extends StatelessWidget {
  ProcessPage({super.key});

  final List<String> tileData = [
    'Fabrics',
    'Cutting',
    'Tailering',
    'Finishing'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: .7,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: 2,
        ),
        itemCount: tileData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProcessTileView(
                          index: index,
                        ))),
            child: GridTile(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    tileData[index],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class ProcessTileView extends StatelessWidget {
  ProcessTileView({super.key, required this.index});
  final index;
  Future<List<StockModel>> stocks = FirestoreUtil.getStock([]);
  Future<List<CutterAssignModel>> cutterAssignList =
      FirestoreUtil.getAssignCutter([]);
  Future<List<TailerAssignModel>> tailerAssignList =
      FirestoreUtil.getAssignTailer([]);
  Future<List<FinisherAssignModel>> finisherAssignList =
      FirestoreUtil.getAssignFinisher([]);
  @override
  Widget build(BuildContext context) {
    String title = '';
    switch (index) {
      case 0:
        title = 'Fabric';
        break;
      case 1:
        title = 'Cutting';
        break;
      case 2:
        title = 'Tailering';
        break;
      case 3:
        title = 'Finishing';
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        backgroundColor: Colors.grey.shade300,
        body: index == 0
            ? FutureBuilder(
                future: stocks,
                builder: (context, AsyncSnapshot<List<StockModel>> snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20),
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color.fromARGB(255, 255, 255, 255)),
                            child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Text(
                                    item.itemCode,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                title: Text(
                                  'Material: ${item.name} ',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: Text(
                                  item.quantity > 1
                                      ? 'Qty: ${item.quantity.toString()}'
                                      : 'No Stock Available',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: item.quantity > 1
                                          ? Colors.green
                                          : Colors.red),
                                )),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const NoDataScreen();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const ShimmerListTile();
                  }
                })
            : index == 1
                ? FutureBuilder(
                    future: cutterAssignList,
                    builder: (context,
                        AsyncSnapshot<List<CutterAssignModel>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20),
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey.shade300,
                                      child: Text(
                                        item.batchID,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    title: Text(
                                      '${item.employID.name} - ${item.product.name}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      'Material: ${item.stockID.name} ',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    trailing: Text(
                                      'Qty: ${item.quantity.toString()}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    )),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return const NoDataScreen();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const ShimmerListTile();
                      }
                    })
                : index == 2
                    ? FutureBuilder(
                        future: tailerAssignList,
                        builder: (context,
                            AsyncSnapshot<List<TailerAssignModel>> snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 20),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.grey.shade300,
                                          child: Text(
                                            item.batchId,
                                            style: const TextStyle(fontSize: 8),
                                          ),
                                        ),
                                        title: Text(
                                          '${item.employId.name} - ${item.productId.productId.name}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        subtitle: Text(
                                          'Material: ${item.productId.materialId.name} ',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        trailing: Text(
                                          'Qty: ${item.quantity.toString()}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        )),
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isEmpty) {
                            return const NoDataScreen();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const ShimmerListTile();
                          }
                        })
                    : FutureBuilder(
                        future: finisherAssignList,
                        builder: (context,
                            AsyncSnapshot<List<FinisherAssignModel>> snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 20),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.grey.shade300,
                                          child: Text(
                                            item.batchId,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ),
                                        title: Text(
                                          '${item.employID.name} - ${item.productID.productID.productId.name}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        subtitle: Text(
                                          'Material: ${item.productID.productID.materialId.name} ',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        trailing: Text(
                                          'Qty: ${item.quantity.toString()}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        )),
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isEmpty) {
                            return const NoDataScreen();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const ShimmerListTile();
                          }
                        }));
  }
}
