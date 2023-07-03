import 'package:json_annotation/json_annotation.dart';
part 'item_add_model.g.dart';

@JsonSerializable()
class ProductAddModel {
  final String name;
  final String itemCode;

  ProductAddModel({required this.name, required this.itemCode});
  factory ProductAddModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAddModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductAddModelToJson(this);
}
