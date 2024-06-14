import 'package:json_annotation/json_annotation.dart';

part 'combi_model.g.dart';

@JsonSerializable()
class CombiModel {
  int? roomCurrentTemp;
  int? roomCurrentWet;
  int? roomTempSetPoint;

  CombiModel({
    this.roomCurrentTemp,
    this.roomCurrentWet,
    this.roomTempSetPoint,
  });

  @override
  CombiModel? fromJson(Map<String, dynamic> json) {}

  @override
  Map<String, dynamic>? toJson() {}

  @override
  printError(Object error, String errorFunction) {
    throw UnimplementedError();
  }
}
