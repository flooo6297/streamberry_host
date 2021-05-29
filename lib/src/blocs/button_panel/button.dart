import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/actions/open_folder_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/ui/custom_elements/resize_button.dart';

class Button extends StatelessWidget {
  final ButtonData buttonData;
  final ButtonPanelState buttonPanelState;

  const Button(
    this.buttonData,
    this.buttonPanelState, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: buttonPanelState.gridTilingSize.height * buttonData.positionY,
      left: buttonPanelState.gridTilingSize.width * buttonData.positionX,
      height: buttonPanelState.gridTilingSize.height * buttonData.height,
      width: buttonPanelState.gridTilingSize.width * buttonData.width,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            height: buttonPanelState.gridTilingSize.height * buttonData.height,
            width: buttonPanelState.gridTilingSize.width * buttonData.width,
            child: Container(
              margin: buttonPanelState.margin,
              decoration: BoxDecoration(
                color: buttonData.canBeOverwritten
                    ? Colors.transparent
                    : buttonData.color,
                border: Border.all(color: buttonData.color, width: 3.0),
              ),
              child: Visibility(
                visible: !buttonData.canBeOverwritten,
                child: IconButton(
                  onPressed: () {
                    buttonData.functions.add('folderFunctions:openAction');
                    buttonData.childState = ButtonPanelCubit.init(
                            context.read<ButtonPanelCubit>().state.xSize,
                            context.read<ButtonPanelCubit>().state.ySize)
                        .state;
                    context.read<ButtonPanelCubit>().selectButton(buttonData);
                  },
                  icon: const Icon(Icons.margin),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Visibility(
              visible: buttonData.canBeOverwritten,
              child: Container(
                height: 30,
                width: 30,
                margin: buttonPanelState.margin,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withAlpha(128),
                ),
                child: IconButton(
                  color: Colors.white,
                  icon: const Icon(
                    Icons.add,
                    size: 14.0,
                  ),
                  onPressed: () {
                    buttonData.enabled = true;
                    context.read<ButtonPanelCubit>().selectButton(buttonData);
                  },
                ),
              ),
            ),
          ),
          ..._buildResizeButtons(context),
        ],
      ),
    );
  }

  List<Widget> _buildResizeButtons(BuildContext context) {
    List<Widget> resizeButtons = [];

    //top
    resizeButtons.add(ResizeButton(Alignment.topCenter, buttonData, buttonPanelState.margin));

    //left
    resizeButtons.add(ResizeButton(Alignment.centerLeft, buttonData, buttonPanelState.margin));

    //bottom
    resizeButtons.add(ResizeButton(Alignment.bottomCenter, buttonData, buttonPanelState.margin));

    //right
    resizeButtons.add(ResizeButton(Alignment.centerRight, buttonData, buttonPanelState.margin));

    return resizeButtons;
  }
}
