// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'on_click.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnClick _$OnClickFromJson(Map<String, dynamic> json) {
  return OnClick(
    json['function'] as String,
    json['action'] as String,
    params: Map<String, String>.from(json['params'] as Map),
  );
}

Map<String, dynamic> _$OnClickToJson(OnClick instance) => <String, dynamic>{
      'function': instance.function,
      'action': instance.action,
      'params': instance.params,
    };
