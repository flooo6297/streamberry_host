import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button.dart';
import 'package:streamberry_host/src/ui/custom_elements/resize_button.dart';
import 'package:hive/hive.dart';

class DefinedButton extends StatelessWidget {
  final ButtonData buttonData;
  final ButtonPanelCubit buttonPanelCubit;

  const DefinedButton(
    this.buttonData,
    this.buttonPanelCubit, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          height: buttonPanelCubit.getState().gridTilingSize.height * buttonData.height,
          width: buttonPanelCubit.getState().gridTilingSize.width * buttonData.width,
          child: buttonData.defaultButton!.buildButton(buttonPanelCubit, buttonData),
        ),
        ..._buildResizeButtons(context),
      ],
    );
  }

  List<Widget> _buildResizeButtons(BuildContext context) {
    List<Widget> resizeButtons = [];

    //top
    resizeButtons.add(
        ResizeButton(Alignment.topCenter, buttonData, buttonPanelCubit.getState().margin));

    //left
    resizeButtons.add(ResizeButton(
        Alignment.centerLeft, buttonData, buttonPanelCubit.getState().margin));

    //bottom
    resizeButtons.add(ResizeButton(
        Alignment.bottomCenter, buttonData, buttonPanelCubit.getState().margin));

    //right
    resizeButtons.add(ResizeButton(
        Alignment.centerRight, buttonData, buttonPanelCubit.getState().margin));

    return resizeButtons;
  }
}
