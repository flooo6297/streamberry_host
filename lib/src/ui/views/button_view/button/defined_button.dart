import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/app.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/on_click.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/ui/custom_elements/resize_button.dart';

class DefinedButton extends StatelessWidget {
  final ButtonData buttonData;
  final ButtonPanelState buttonPanelState;

  const DefinedButton(
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
                color: buttonData.color,
                border: Border.all(color: buttonData.color, width: 3.0),
              ),
              child: IconButton(
                onPressed: () {
                  context.read<ButtonPanelCubit>().selectButton(buttonData);
                  context.read<ButtonPanelCubit>().refresh();
                },
                icon: const Icon(Icons.margin),
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
