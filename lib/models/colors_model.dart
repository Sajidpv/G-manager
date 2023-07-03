import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'colors_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class ColorModel {
  final String color;
  String id = uuid.v4();

  ColorModel({
    required this.color,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) =>
      _$ColorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ColorModelToJson(this);
}
