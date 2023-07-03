import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'stock_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class StockModel {
  final String itemCode;
  final String name;
  String? hsn;
  double quantity;

  StockModel(this.hsn,
      {required this.name, required this.itemCode, required this.quantity});

  factory StockModel.fromJson(Map<String, dynamic> json) =>
      _$StockModelFromJson(json);
  Map<String, dynamic> toJson() => _$StockModelToJson(this);
}
