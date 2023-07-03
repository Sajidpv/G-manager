import 'package:flutter/material.dart';

class ReusableTabBar extends StatelessWidget {
  final List<Tab> tabs;
  final TabController? controller;

  const ReusableTabBar(
      {super.key, required this.tabs, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            25.0,
          ),
        ),
        child: TabBar(
          isScrollable: true,
          controller: controller,
          indicatorPadding: const EdgeInsets.all(4),
          indicator: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(
              25.0,
            ),
            color: Colors.black,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: tabs,
        ),
      ),
    );
  }
}
