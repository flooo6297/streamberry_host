import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

class SizeSerializer implements JsonConverter<Size, String?> {

  final Size defaultValue = const Size(125, 125);

  const SizeSerializer();

  @override
  Size fromJson(String? json) => json==null?defaultValue:Size(double.parse(json.split(':')[0]), double.parse(json.split(':')[1]));

  @override
  String toJson(Size size) => '${size.width}:${size.height}';

}