import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';

class UndefinedButton extends StatelessWidget {
  final ButtonData buttonData;
  final ButtonData nonDefinedButtonDesign;
  final ButtonPanelState buttonPanelState;

  const UndefinedButton(
      this.buttonData,
      this.buttonPanelState,
      this.nonDefinedButtonDesign,{
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
                color: Colors.transparent,
                border: Border.all(color: nonDefinedButtonDesign.color, width: 3.0),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
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
        ],
      ),
    );
  }

}
