// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ButtonData _$ButtonDataFromJson(Map<String, dynamic> json) {
  return ButtonData(
    json['positionX'] as int,
    json['positionY'] as int,
    color: const ColorSerializer().fromJson(json['color'] as int),
    height: json['height'] as int,
    width: json['width'] as int,
    functions:
        (json['functions'] as List<dynamic>).map((e) => e as String).toList(),
    enabled: json['enabled'] as bool,
    childState: json['childState'] == null
        ? null
        : ButtonPanelState.fromJson(json['childState'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ButtonDataToJson(ButtonData instance) =>
    <String, dynamic>{
      'color': const ColorSerializer().toJson(instance.color),
      'height': instance.height,
      'width': instance.width,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'functions': instance.functions,
      'enabled': instance.enabled,
      'childState': instance.childState,
    };
