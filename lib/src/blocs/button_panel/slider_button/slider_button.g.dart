// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider_button.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SliderButton _$SliderButtonFromJson(Map<String, dynamic> json) {
  return SliderButton(
    axis: const VerticalAxisSerializer().fromJson(json['axis'] as String),
  )
    ..backgroundColor = const SliderButtonBackgroundColorSerializer()
        .fromJson(json['backgroundColor'] as int?)
    ..foregroundColor = const SliderButtonForegroundColorSerializer()
        .fromJson(json['foregroundColor'] as int?)
    ..onClick = OnClick.fromJson(json['onClick'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SliderButtonToJson(SliderButton instance) =>
    <String, dynamic>{
      'axis': const VerticalAxisSerializer().toJson(instance.axis),
      'backgroundColor': const SliderButtonBackgroundColorSerializer()
          .toJson(instance.backgroundColor),
      'foregroundColor': const SliderButtonForegroundColorSerializer()
          .toJson(instance.foregroundColor),
      'onClick': instance.onClick,
    };
