// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_quantity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorQuantityModel _$ColorQuantityModelFromJson(Map<String, dynamic> json) =>
    ColorQuantityModel(
      json['colorCode'] as String,
      json['color'] as String,
      (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$ColorQuantityModelToJson(ColorQuantityModel instance) =>
    <String, dynamic>{
      'color': instance.color,
      'quantity': instance.quantity,
      'colorCode': instance.colorCode,
    };
