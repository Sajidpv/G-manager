import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_stream.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/finish_model.dart';
import 'package:hmanage/models/stock_model.dart';
import 'package:hmanage/widgets/no_data_screen.dart';
import 'package:hmanage/widgets/shimmer_effect.dart';
import 'package:hmanage/widgets/tabbar.dart';

class StockHome extends StatefulWidget {
  const StockHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StockHomeState createState() => _StockHomeState();
}

class _StockHomeState extends State<StockHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Stream<List<StockModel>>? stock;
  Future<List<FinishModel>>? products;
  FirestoreStreams streamProvider = FirestoreStreams();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    stock = streamProvider.getStockStream();
    products = FirestoreUtil.getFinishing([]);
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          // tab bar view here
          ReusableTabBar(
            tabs: const [
              Tab(
                text: 'Row Material',
              ),
              Tab(
                text: 'Final Products',
              ),
            ],
            controller: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                StreamBuilder(
                    stream: stock,
                    builder:
                        (context, AsyncSnapshot<List<StockModel>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data![index];
                            final hasHSN = item.hsn != '';
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
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
                                  title: Row(
                                    children: [
                                      Text(
                                        'Material: ${item.name} ',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        hasHSN ? '(${item.hsn})' : '',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                      item.quantity == 0
                                          ? 'Out of Stock'
                                          : 'Qty: ${item.quantity.toString()}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: item.quantity == 0
                                              ? Colors.red
                                              : Colors.green)),
                                ),
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
                    }),
                // StreamBuilder<List<StockModel>>(
                //   stream: Stream.fromFuture(stock!).asBroadcastStream(),
                //   builder: (context, snapshot) {
                //     print(snapshot);
                //     if (snapshot.hasData) {
                //       return ListView.builder(
                //         itemCount: snapshot.data?.length,
                //         itemBuilder: (BuildContext context, int index) {
                //           final item = snapshot.data![index];
                //           return ListTile(
                //             title: Text(
                //               'Material: ${item.name}  (HSN:${item.hsn})',
                //               style: const TextStyle(fontSize: 12),
                //             ),
                //             subtitle: Text(
                //               'Qty: ${item.quantity.toString()}',
                //               style: const TextStyle(fontSize: 10),
                //             ),
                //             trailing: IconButton(
                //               onPressed: () {},
                //               icon: const Icon(Icons.delete),
                //             ),
                //           );
                //         },
                //       );
                //     } else if (snapshot.hasError) {
                //       return Text('Error here: ${snapshot.error}');
                //     } else {
                //       return const Center(child: CircularProgressIndicator());
                //     }
                //   },
                // ),

                // second tab bar view widget

                FutureBuilder(
                    future: products,
                    builder:
                        (context, AsyncSnapshot<List<FinishModel>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
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
                                      item.batchId,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  title: Text(
                                    'Product: ${item.productID.productID.productId.name}  (${item.color.color})',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  subtitle: Text(
                                      item.quantity == 0
                                          ? 'Out of Stock'
                                          : 'Qty: ${item.quantity.toString()}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: item.quantity == 0
                                              ? Colors.red
                                              : Colors.green)),
                                ),
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
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
