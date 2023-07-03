import 'package:flutter/material.dart';
import 'package:hmanage/db_functions/collections.dart';
import 'package:hmanage/db_functions/firestore_util.dart';
import 'package:hmanage/models/employee_model.dart';
import 'package:hmanage/models/supplier_model.dart';
import 'package:hmanage/widgets/show_snack_bar.dart';

void showDeleteConfirmationDialog(BuildContext context, dynamic item) {
  String collectionPath;
  String idFieldName;

  if (item is SupplierModel) {
    collectionPath = supplierCollection;
    idFieldName = item.suppID;
  } else if (item is EmployeeModel) {
    collectionPath = employeeCollection;
    idFieldName = item.empID;
  } else {
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${item.name}?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final isDeleted = await FirestoreUtil.deleteDocument(
                collectionPath,
                idFieldName,
              );
              if (isDeleted == true) {
                showSnackBar(context, '${item.name} Deleted');
              }
            },
          ),
        ],
      );
    },
  );
}
