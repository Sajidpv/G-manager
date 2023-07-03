import 'package:flutter/material.dart';
import 'package:hmanage/models/product_model.dart';

class PurchaseDialog extends StatelessWidget {
  final List<String> dateParts;
  final String supplierName;
  final String invoice;
  final double totalAmount;
  final List<MaterialAddModel> items;

  const PurchaseDialog({
    Key? key,
    required this.dateParts,
    required this.supplierName,
    required this.invoice,
    required this.totalAmount,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Purchase Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${dateParts[1]}-${dateParts[0]}'),
            Text('Supplier: $supplierName'),
            Text('Invoice: $invoice'),
            Text('Total Amount: $totalAmount'),
            const SizedBox(height: 5),
            const Text('Items:'),
            SingleChildScrollView(
              child: SizedBox(
                width: 400,
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(
                        item.name.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        'Qty: ${item.quantity}',
                        style: const TextStyle(fontSize: 10),
                      ),
                      trailing: Text(
                        '₹: ${item.amount} / ₹: ${item.sum}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
