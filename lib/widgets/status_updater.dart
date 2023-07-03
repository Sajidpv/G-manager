import 'package:flutter/material.dart';
import 'package:hmanage/models/employee_model.dart';

Widget buildStatusDropdown(Status value, Function(Status?) onChanged) {
  return DropdownButton<Status>(
    value: value,
    items: Status.values.map<DropdownMenuItem<Status>>(
      (Status status) {
        return DropdownMenuItem<Status>(
          value: status,
          child: Text(
            status.toString().split('.').last,
            style: const TextStyle(fontSize: 10),
          ),
        );
      },
    ).toList(),
    onChanged: onChanged,
  );
}
