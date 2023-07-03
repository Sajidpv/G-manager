import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTime?> selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    firstDate: DateTime.now().subtract(const Duration(days: 30)),
    lastDate: DateTime.now(),
    initialDate: DateTime.now(),
  );

  return pickedDate;
}

String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
