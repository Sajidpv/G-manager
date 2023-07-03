import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_stream.dart';
import 'package:hmanage/models/cutter_assigned_model.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/finisher_assign_model.dart';
import 'package:hmanage/models/tailer_assign_model.dart';
import 'package:hmanage/screens/splash_screen.dart';
import 'package:hmanage/screens/users/admins/finish%20screen/cutter_finish_product.dart';
import 'package:hmanage/screens/users/admins/finish%20screen/finish_product.dart';
import 'package:hmanage/screens/users/admins/finish%20screen/tailer_finish_product.dart';
import 'package:hmanage/widgets/date_parcer.dart';
import 'package:hmanage/widgets/no_data_screen.dart';
import 'package:hmanage/widgets/shimmer_effect.dart';

class ProdViewEmpItems extends StatelessWidget {
  const ProdViewEmpItems({Key? key, required this.empId, required this.isAdmin})
      : super(key: key);
  final EmployeeModel empId;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final role = empId.type.name;
    FirestoreStreams streamProvider = FirestoreStreams();
    Stream<List<CutterAssignModel>>? cutterAssItemStream =
        streamProvider.getCutterAssignmentStream(empId.empID);
    Stream<List<TailerAssignModel>>? tailerAssItemStream =
        streamProvider.getTailerAssignmentStream(empId.empID);
    Stream<List<FinisherAssignModel>>? finisherAssItemStream =
        streamProvider.getFinisherAssignmentStream(empId.empID);
    return Scaffold(
        appBar: isAdmin
            ? AppBar(
                title: Text(empId.name.toString()),
              )
            : null,
        backgroundColor: Colors.grey.shade300,
        body: role == 'Cutter' //CUTTER VIEW
            ? StreamBuilder(
                stream: cutterAssItemStream,
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = snapshot.data![index];
                        List<String> dateParts = formatDateTime(item.date);

                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color.fromARGB(255, 255, 255, 255)),
                            child: ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Text(
                                    '${dateParts[1]}\n${dateParts[0]}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                title: Text(
                                  '${item.stockID.name} - ${item.product.name}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(
                                  'Qty: ${item.quantity}/${item.assignedQuantity}'
                                      .toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                                trailing: item.quantity == 0
                                    ? const Text(
                                        'Finished',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.green),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          pageNavigator(
                                              CutterFinishItems(emp: item),
                                              context);
                                        },
                                        child: const Text('Add to Finish'),
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
            : role == 'Tailer' //TAILER VIEW
                ? StreamBuilder(
                    stream: tailerAssItemStream,
                    builder: (context,
                        AsyncSnapshot<List<TailerAssignModel>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data![index];
                            List<String> dateParts = formatDateTime(item.date);
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey.shade300,
                                      child: Text(
                                        '${dateParts[1]}\n${dateParts[0]}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    title: Text(
                                      '${item.productId.materialId.name} - ${item.productId.productId.name}(${item.color.color})',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      'Qty: ${item.quantity}/${item.assignedQuantity}'
                                          .toString(),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    trailing: item.quantity == 0
                                        ? const Text(
                                            'Finished',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.green),
                                          )
                                        : TextButton(
                                            onPressed: () {
                                              pageNavigator(
                                                  TailerFinishItem(emp: item),
                                                  context);
                                            },
                                            child: const Text('Add to Finish'),
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
                : //FINISHER
                StreamBuilder(
                    stream: finisherAssItemStream,
                    builder: (context,
                        AsyncSnapshot<List<FinisherAssignModel>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data![index];
                            List<String> dateParts = formatDateTime(item.date);

                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey.shade300,
                                      child: Text(
                                        '${dateParts[1]}\n${dateParts[0]}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    title: Text(
                                      '${item.productID.productID.materialId.name} - ${item.productID.productID.productId.name}(${item.color.color})',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      'Qty: ${item.quantity}/${item.assignedQuantity}'
                                          .toString(),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    trailing: item.quantity == 0
                                        ? const Text(
                                            'Finished',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.green),
                                          )
                                        : TextButton(
                                            onPressed: () {
                                              pageNavigator(
                                                  FinisherinishItem(emp: item),
                                                  context);
                                            },
                                            child: const Text('Add to Finish'),
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
                    }));
  }
}
