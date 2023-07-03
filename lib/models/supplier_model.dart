import 'package:hmanage/models/employee_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'supplier_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class SupplierModel {
  final String name;
  final String address;
  final Status status;
  var suppID = uuid.v4();

  SupplierModel(this.name, this.address, this.status);

  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierModelToJson(this);
}
