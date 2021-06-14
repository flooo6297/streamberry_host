// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_panel_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ButtonPanelState _$ButtonPanelStateFromJson(Map<String, dynamic> json) {
  return ButtonPanelState(
    json['xSize'] as int,
    json['ySize'] as int,
    const SizeSerializer().fromJson(json['gridTilingSize'] as String),
    const ColorSerializer().fromJson(json['backgroundColor'] as int),
    const EdgeInsetsSerializer()
        .fromJson(json['margin'] as Map<String, dynamic>),
    json['name'] as String,
    (json['borderRadius'] as num).toDouble(),
  )
    ..panelList = (json['panelList'] as List<dynamic>)
        .map((e) => ButtonData.fromJson(e as Map<String, dynamic>))
        .toList()
    ..nonDefinedButtonDesign = ButtonData.fromJson(
        json['nonDefinedButtonDesign'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ButtonPanelStateToJson(ButtonPanelState instance) =>
    <String, dynamic>{
      'panelList': instance.panelList,
      'name': instance.name,
      'nonDefinedButtonDesign': instance.nonDefinedButtonDesign,
      'gridTilingSize': const SizeSerializer().toJson(instance.gridTilingSize),
      'backgroundColor':
          const ColorSerializer().toJson(instance.backgroundColor),
      'margin': const EdgeInsetsSerializer().toJson(instance.margin),
      'borderRadius': instance.borderRadius,
      'xSize': instance.xSize,
      'ySize': instance.ySize,
    };
