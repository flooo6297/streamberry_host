// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ButtonData _$ButtonDataFromJson(Map<String, dynamic> json) {
  return ButtonData(
    json['positionX'] as int,
    json['positionY'] as int,
    height: json['height'] as int,
    width: json['width'] as int,
    childState: json['childState'] == null
        ? null
        : ButtonPanelState.fromJson(json['childState'] as Map<String, dynamic>),
    enabled: json['enabled'] as bool,
    borderWidth: (json['borderWidth'] as num).toDouble(),
    defaultButton: json['defaultButton'] == null
        ? null
        : DefaultButton.fromJson(json['defaultButton'] as Map<String, dynamic>),
    id: json['id'] as String?,
  );
}

Map<String, dynamic> _$ButtonDataToJson(ButtonData instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'enabled': instance.enabled,
    'borderWidth': instance.borderWidth,
    'childState': instance.childState,
    'height': instance.height,
    'width': instance.width,
    'positionX': instance.positionX,
    'positionY': instance.positionY,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('defaultButton', instance.defaultButton);
  return val;
}
