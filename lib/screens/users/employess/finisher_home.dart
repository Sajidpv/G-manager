import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_stream.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/finish_model.dart';
import 'package:hmanage/screens/users/admins/production_view_employee_items.dart';
import 'package:hmanage/widgets/no_data_screen.dart';
import 'package:hmanage/widgets/shimmer_effect.dart';
import 'package:hmanage/widgets/signout.dart';

import 'package:hmanage/widgets/tabbar.dart';

class FinisherHome extends StatefulWidget {
  const FinisherHome({super.key, required this.empID});
  final EmployeeModel empID;

  @override
  // ignore: library_private_types_in_public_api
  _FinisherHomeState createState() => _FinisherHomeState();
}

class _FinisherHomeState extends State<FinisherHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 60,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: Text(
                  widget.empID.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const AboutListTile(
              icon: Icon(
                Icons.info,
              ),
              applicationIcon: Icon(
                Icons.store,
              ),
              applicationName: 'HaashStore',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2023 Haash Technologies',
              aboutBoxChildren: [],
              child: Text('About app'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                signOut(context);
              },
            ),
          ],
        ),
      ),
      body: Home(
        empID: widget.empID,
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.empID});
  final EmployeeModel empID;

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FirestoreStreams streamProvider = FirestoreStreams();
  Stream<List<FinishModel>>? productStream;

  @override
  void initState() {
    productStream = streamProvider.getFinisherFinishStream(widget.empID.empID);
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
    return Column(
      children: [
        ReusableTabBar(tabs: const [
          Tab(
            text: 'Report',
          ),
          Tab(
            text: 'Material ',
          ),
          Tab(
            text: 'Finished ',
          ),
        ], controller: _tabController),
        // tab bar view here
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const Center(child: Text('No report to show')),
              ProdViewEmpItems(
                empId: widget.empID,
                isAdmin: false,
              ),
              StreamBuilder(
                  stream: productStream,
                  builder: (context, snapshot) {
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
                                    'Qty: ${item.quantity.toString()}',
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.green)),
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
    );
  }
}
