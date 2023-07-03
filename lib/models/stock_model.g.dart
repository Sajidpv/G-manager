// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockModel _$StockModelFromJson(Map<String, dynamic> json) => StockModel(
      json['hsn'] as String?,
      name: json['name'] as String,
      itemCode: json['itemCode'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$StockModelToJson(StockModel instance) =>
    <String, dynamic>{
      'itemCode': instance.itemCode,
      'name': instance.name,
      'hsn': instance.hsn,
      'quantity': instance.quantity,
    };
