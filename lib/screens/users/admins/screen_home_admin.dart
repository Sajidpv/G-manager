import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/collections.dart';
import 'package:hmanage/db_functions/firestore_stream.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/supplier_model.dart';
import 'package:hmanage/screens/users/employess/screen_home_accounts.dart';
import 'package:hmanage/screens/screen_production.dart';
import 'package:hmanage/screens/screen_home_purchase.dart';
import 'package:hmanage/screens/users/employess/screen_home_sales.dart';
import 'package:hmanage/screens/screen_home_stock.dart';
import 'package:hmanage/sections/fab_with_menu.dart';
import 'package:hmanage/screens/users/admins/add%20screen/add_material_to_stock.dart';
import 'package:hmanage/widgets/constants.dart';
import 'package:hmanage/widgets/item_delete_dialogue.dart';
import 'package:hmanage/widgets/no_data_screen.dart';
import 'package:hmanage/widgets/shimmer_effect.dart';
import 'package:hmanage/widgets/show_snack_bar.dart';
import 'package:hmanage/widgets/signout.dart';
import 'package:hmanage/widgets/status_updater.dart';
import '../../../widgets/tabbar.dart';

late BuildContext myContext;

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Widget? activeScreen;

  String? currentScreen;
  @override
  void initState() {
    currentScreen = 'home';
    myContext = context;
    activeScreen = const Home();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  switchScreen(Widget screen) {
    setState(() {
      activeScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Home',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              setState(() {
                currentScreen = 'home';
              });

              switchScreen(const Home());
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: ListTile(
                  title: Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                switchScreen(const Home());
                setState(() {
                  currentScreen = 'home';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Production'),
              onTap: () {
                setState(() {
                  currentScreen = 'production';
                });

                switchScreen(const ProductionDetails());
                Navigator.pop(context);
              },
            ),
            ListTile(
              enabled: false,
              leading: const Icon(Icons.sell),
              title: const Text('Sales'),
              onTap: () {
                setState(() {
                  currentScreen = 'sales';
                });
                switchScreen(const SalesHome());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Purchase'),
              onTap: () {
                setState(() {
                  currentScreen = 'purchase';
                });
                switchScreen(const PurchaseHome());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Stock'),
              onTap: () {
                setState(() {
                  currentScreen = 'stock';
                });
                switchScreen(const StockHome());
                Navigator.pop(context);
              },
            ),
            ListTile(
              enabled: false,
              leading: const Icon(Icons.account_balance),
              title: const Text('Accounts'),
              onTap: () {
                setState(() {
                  currentScreen = 'accounts';
                });
                switchScreen(const AccountsHome());
                Navigator.pop(context);
              },
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
              aboutBoxChildren: [
                ///Content goes here...
              ],
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
      body: activeScreen,
      floatingActionButton: currentScreen == 'home'
          ? FabWithIcons(
              icons: icons1,
              onIconTapped: (index) {},
              tooltips: fabTooltips1,
              screen: currentScreen!,
            )
          : currentScreen == 'production'
              ? FabWithIcons(
                  icons: icons2,
                  onIconTapped: (index) {},
                  tooltips: fabTooltips2,
                  screen: currentScreen!,
                )
              : currentScreen == 'stock'
                  ? FloatingActionButton(
                      tooltip: 'Add Stock',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMaterial()));
                      },
                      child: const Icon(Icons.add),
                    )
                  : FabWithIcons(
                      icons: icons3,
                      onIconTapped: (index) {},
                      tooltips: fabTooltips3,
                      screen: currentScreen!,
                    ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Stream<List<SupplierModel>>? supplierStreamer;
  bool? isUpdated;
  bool? isDeleted;
  FirestoreStreams streamProvider = FirestoreStreams();
  Stream<List<EmployeeModel>>? usersStream;

  @override
  void initState() {
    usersStream = streamProvider.getUsersStream();
    supplierStreamer = streamProvider.getSuppliersStream();
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
            text: 'Employees ',
          ),
          Tab(
            text: 'Suppliers ',
          ),
        ], controller: _tabController),
        // tab bar view here
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const Center(child: Text('No report to show')),
//View employees
              StreamBuilder<List<EmployeeModel>>(
                stream: usersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final List<EmployeeModel> employees = snapshot.data!;
                    return ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = employees[index];
                        final isAdmin = item.type == UserType.Admin;
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 20, right: 20),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey.shade300,
                                child: Text(
                                  item.empID,
                                  style: const TextStyle(fontSize: 8),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(fontSize: 12),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(item.type.name,
                                      style: const TextStyle(fontSize: 10)),
                                  const Spacer(),
                                  if (!isAdmin)
                                    buildStatusDropdown(
                                      item.status,
                                      (Status? newValue) async {
                                        if (newValue != null) {
                                          final newStatus = newValue
                                              .toString()
                                              .split('.')
                                              .last;
                                          isUpdated = await FirestoreUtil
                                              .updateEmployeeStatus(
                                            employeeCollection,
                                            item.empID,
                                            newStatus,
                                          );
                                          if (isUpdated == true) {
                                            showSnackBar(
                                              context,
                                              'Status updated for ${item.name}: $newStatus',
                                            );
                                          }
                                        }
                                      },
                                    ),
                                ],
                              ),
                              trailing: !isAdmin
                                  ? IconButton(
                                      onPressed: () =>
                                          showDeleteConfirmationDialog(
                                              context, item),
                                      icon: const Icon(Icons.delete),
                                    )
                                  : null,
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
                    return const ShimmerDropDown();
                  }
                },
              ),

              //View Suppliers

              StreamBuilder(
                  stream: supplierStreamer,
                  builder:
                      (context, AsyncSnapshot<List<SupplierModel>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 20, right: 20),
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey.shade300,
                                  child: const Text(
                                    'S',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                title: Text(item.name,
                                    style: const TextStyle(fontSize: 12)),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        item.address,
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    buildStatusDropdown(
                                      //Custome dropdown to change the status
                                      item.status,
                                      (Status? newValue) async {
                                        if (newValue != null) {
                                          final newStatus = newValue
                                              .toString()
                                              .split('.')
                                              .last;
                                          isUpdated = await FirestoreUtil
                                              .updateEmployeeStatus(
                                            supplierCollection,
                                            item.suppID,
                                            newStatus,
                                          );
                                          if (isUpdated == true) {
                                            showSnackBar(
                                              context,
                                              'Status updated for ${item.name}: $newStatus',
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () => showDeleteConfirmationDialog(
                                      context, item),
                                  icon: const Icon(Icons.delete),
                                ),
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
                      return const ShimmerDropDown();
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
