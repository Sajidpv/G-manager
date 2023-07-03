// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductMaterialModel _$ProductMaterialModelFromJson(
        Map<String, dynamic> json) =>
    ProductMaterialModel(
      purID: json['purID'] as String,
      invoice: json['invoice'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => MaterialAddModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: (json['date'] as Timestamp).toDate(),
      description: json['description'] as String,
      supplier:
          SupplierModel.fromJson(json['supplier'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductMaterialModelToJson(
        ProductMaterialModel instance) =>
    <String, dynamic>{
      'purID': instance.purID,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'supplier': instance.supplier,
      'invoice': instance.invoice,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
    };

MaterialAddModel _$MaterialAddModelFromJson(Map<String, dynamic> json) =>
    MaterialAddModel(
      name: StockModel.fromJson(json['name'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      sum: (json['sum'] as num).toDouble(),
    )..proID = json['proID'] as String;

Map<String, dynamic> _$MaterialAddModelToJson(MaterialAddModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'amount': instance.amount,
      'sum': instance.sum,
      'proID': instance.proID,
    };
