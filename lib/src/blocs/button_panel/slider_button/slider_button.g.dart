// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider_button.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SliderButton _$SliderButtonFromJson(Map<String, dynamic> json) {
  return SliderButton(
    axis: const AxisSerializer().fromJson(json['axis'] as String),
  )
    ..backgroundColor =
        const ColorSerializer().fromJson(json['backgroundColor'] as int)
    ..foregroundColor =
        const ColorSerializer().fromJson(json['foregroundColor'] as int)
    ..onClick = OnClick.fromJson(json['onClick'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SliderButtonToJson(SliderButton instance) =>
    <String, dynamic>{
      'axis': const AxisSerializer().toJson(instance.axis),
      'backgroundColor':
          const ColorSerializer().toJson(instance.backgroundColor),
      'foregroundColor':
          const ColorSerializer().toJson(instance.foregroundColor),
      'onClick': instance.onClick,
    };
