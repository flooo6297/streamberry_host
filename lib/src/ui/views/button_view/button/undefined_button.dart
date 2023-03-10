import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_type.dart';
import 'package:streamberry_host/src/blocs/button_panel/data_update_templates/data_update_template.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button.dart';
import 'package:streamberry_host/src/blocs/button_panel/slider_button/slider_button.dart';

class UndefinedButton extends StatelessWidget {
  final ButtonData buttonData;
  final ButtonPanelCubit buttonPanelCubit;

  const UndefinedButton(
    this.buttonData,
    this.buttonPanelCubit, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonData nonDefinedButtonData =
        buttonPanelCubit.getState().nonDefinedButtonDesign;

    double borderRadius = 0.0;

    if (buttonPanelCubit.getState().gridTilingSize.width >
        buttonPanelCubit.getState().gridTilingSize.height) {
      borderRadius = (buttonPanelCubit.getState().gridTilingSize.height -
              buttonPanelCubit.getState().margin.vertical) *
          buttonPanelCubit.getState().borderRadius;
    } else {
      borderRadius = (buttonPanelCubit.getState().gridTilingSize.width -
              buttonPanelCubit.getState().margin.horizontal) *
          buttonPanelCubit.getState().borderRadius;
    }

    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          height: buttonPanelCubit.getState().gridTilingSize.height *
              buttonData.height,
          width: buttonPanelCubit.getState().gridTilingSize.width *
              buttonData.width,
          child: Container(
            margin: buttonPanelCubit.getState().margin,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color:
                      (nonDefinedButtonData.buttonType as DefaultButton).color,
                  width: nonDefinedButtonData.borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 30,
            width: 30,
            margin: buttonPanelCubit.getState().margin,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withAlpha(128),
            ),
            child: PopupMenuButton<ButtonType>(
              onSelected: (buttonType) {
                buttonData.enabled = true;
                buttonData.buttonType = buttonType;
                buttonPanelCubit.selectButton(buttonData);
                buttonPanelCubit.getSelectedButton()!.enabled = true;
                buttonPanelCubit.refresh();
              },
              itemBuilder: (context) {
                return ButtonType.types.entries.map((type) {
                  ButtonType buttonType = type.value();
                  return PopupMenuItem<ButtonType>(
                    value: buttonType,
                    child: Row(
                      children: [
                        Icon(buttonType.listIcon),
                        SizedBox(width: 8.0),
                        Text(buttonType.name),
                      ],
                    ),
                  );
                }).toList();
              },
              child: Container(
                height: 32,
                width: 32,
                child: Center(
                  child: const Icon(
                    Icons.add,
                    size: 14.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
