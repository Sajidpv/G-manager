import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/product_model.dart';
import 'package:hmanage/widgets/date_parcer.dart';
import 'package:hmanage/widgets/purchase_details_show_dialog.dart';

import 'package:hmanage/widgets/tabbar.dart';

class PurchaseHome extends StatefulWidget {
  const PurchaseHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseHomeState createState() => _PurchaseHomeState();
}

class _PurchaseHomeState extends State<PurchaseHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<List<ProductMaterialModel>>? purchases;

  @override
  void initState() {
    purchases = FirestoreUtil.getPurchase([]);
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // tab bar view here
            ReusableTabBar(
              tabs: const [
                Tab(
                  text: 'Purchase Order',
                ),
                Tab(
                  text: 'Purchase',
                ),
                Tab(
                  text: 'Debit Note/Purchase Return',
                ),
              ],
              controller: _tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  const Center(
                    child: Text('No record to show'),
                  ),
                  FutureBuilder(
                      future: purchases,
                      builder: (context,
                          AsyncSnapshot<List<ProductMaterialModel>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = snapshot.data![index];
                              List<String> dateParts =
                                  formatDateTime(item.date);
                              return snapshot.data == null
                                  ? const Center(
                                      child: Text('No record to show'),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 20, right: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return PurchaseDialog(
                                                dateParts: dateParts,
                                                supplierName:
                                                    item.supplier.name,
                                                invoice: item.invoice,
                                                items: item.items,
                                                totalAmount: item.totalAmount,
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              child: Text(
                                                '${dateParts[1]}\n${dateParts[0]}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ),
                                            title: Text(
                                              item.supplier.name,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            subtitle: Text(
                                              item.invoice,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                            trailing: Text(
                                              'Amout: ${item.totalAmount}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            // Access supplier's name field
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),

                  // second tab bar view widget
                  const Center(
                    child: Text('No record to show'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
