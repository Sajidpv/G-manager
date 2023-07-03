import 'package:json_annotation/json_annotation.dart';
part 'color_quantity_model.g.dart';

@JsonSerializable()
class ColorQuantityModel {
  final String color;
  double quantity;
  String colorCode;

  ColorQuantityModel(this.colorCode, this.color, this.quantity);
  factory ColorQuantityModel.fromJson(Map<String, dynamic> json) =>
      _$ColorQuantityModelFromJson(json);
  Map<String, dynamic> toJson() => _$ColorQuantityModelToJson(this);
}
