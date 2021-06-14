// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_button.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultButton _$DefaultButtonFromJson(Map<String, dynamic> json) {
  return DefaultButton(
    color: const ColorSerializer().fromJson(json['color'] as int),
    onClicks: (json['onClicks'] as List<dynamic>)
        .map((e) => OnClick.fromJson(e as Map<String, dynamic>))
        .toList(),
    image: json['image'] as String,
    text: json['text'] as String,
    textAlignment:
        const AlignmentSerializer().fromJson(json['textAlignment'] as String),
    snapToGrid: json['snapToGrid'] as bool,
    textSize: (json['textSize'] as num).toDouble(),
    textColorValue: json['textColorValue'] as int? ?? 4294967295,
  );
}

Map<String, dynamic> _$DefaultButtonToJson(DefaultButton instance) =>
    <String, dynamic>{
      'color': const ColorSerializer().toJson(instance.color),
      'onClicks': instance.onClicks,
      'image': instance.image,
      'text': instance.text,
      'textSize': instance.textSize,
      'textAlignment':
          const AlignmentSerializer().toJson(instance.textAlignment),
      'snapToGrid': instance.snapToGrid,
      'textColorValue': instance.textColorValue,
    };
