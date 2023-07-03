import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/screens/screen_production_process.dart';
import 'package:hmanage/screens/users/admins/production_view_employee_items.dart';
import 'package:hmanage/widgets/no_data_screen.dart';
import 'package:hmanage/widgets/shimmer_effect.dart';

import 'package:hmanage/widgets/tabbar.dart';

class ProductionDetails extends StatefulWidget {
  const ProductionDetails({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductionDetailsState createState() => _ProductionDetailsState();
}

class _ProductionDetailsState extends State<ProductionDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          ReusableTabBar(tabs: const [
            Tab(
              text: 'Processing',
            ),
            Tab(
              text: 'Cutting ',
            ),
            Tab(
              text: 'Tailering ',
            ),
            Tab(
              text: 'Finishing',
            ),
          ], controller: _tabController),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ProcessPage(), //process

                const ProcessItems(index: 1),
                const ProcessItems(index: 2),
                const ProcessItems(index: 3)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProcessItems extends StatelessWidget {
  const ProcessItems({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    Future<List<EmployeeModel>>? users;

    switch (index) {
      case 1:
        users = FirestoreUtil.getFilterdUsers(UserType.Cutter);
        break;
      case 2:
        users = FirestoreUtil.getFilterdUsers(UserType.Tailer);
        break;
      case 3:
        users = FirestoreUtil.getFilterdUsers(UserType.Finisher);
        break;
    }
    return FutureBuilder(
        future: users,
        builder: (context, AsyncSnapshot<List<EmployeeModel>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                final item = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromARGB(255, 255, 255, 255)),
                    child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade300,
                          child: Text(
                            item.type.name,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                        subtitle: Text(
                          item.empID,
                          style: const TextStyle(fontSize: 10),
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProdViewEmpItems(
                                      empId: item,
                                      isAdmin: true,
                                    )));
                          },
                          child: const Text('View'),
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
        });
  }
}
