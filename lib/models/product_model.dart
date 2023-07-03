import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmanage/models/stock_model.dart';
import 'package:hmanage/models/supplier_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'product_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class ProductMaterialModel {
  final String purID;
  final DateTime date;
  final String description;
  final SupplierModel supplier;
  final String invoice;
  final List<MaterialAddModel> items;
  final double totalAmount;

  ProductMaterialModel({
    required this.purID,
    required this.invoice,
    required this.totalAmount,
    required this.items,
    required this.date,
    required this.description,
    required this.supplier,
  });
  factory ProductMaterialModel.fromJson(Map<String, dynamic> json) =>
      _$ProductMaterialModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductMaterialModelToJson(this);
}
// /  date: (json['date'] as Timestamp).toDate(),

@JsonSerializable()
class MaterialAddModel {
  final StockModel name;
  final double quantity;
  final double amount;
  final double sum;
  var proID = uuid.v4();

  MaterialAddModel(
      {required this.name,
      required this.quantity,
      required this.amount,
      required this.sum});
  factory MaterialAddModel.fromJson(Map<String, dynamic> json) =>
      _$MaterialAddModelFromJson(json);
  Map<String, dynamic> toJson() => _$MaterialAddModelToJson(this);
}
