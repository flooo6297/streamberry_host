import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/ui/custom_elements/resize_direction_button.dart';

class ResizeButton extends StatelessWidget {
  final Alignment alignment;
  final ButtonData buttonData;
  final EdgeInsets buttonMargin;

  const ResizeButton(this.alignment, this.buttonData, this.buttonMargin, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool show1 = true;
    bool show2 = true;

    EdgeInsets margin;

    Function() button1Function = () {};
    Function() button2Function = () {};

    Widget rowOrColumn = Column(
      children: const [],
    );

    if (alignment == Alignment.topCenter) {
      margin = EdgeInsets.only(top: buttonMargin.top / 2);
      List<ButtonData> buttonsOnTop =
          context.read<ButtonPanelCubit>().getButtonsOnTop(buttonData);
      List<ButtonData> buttonsOnTopWithFunction =
          buttonsOnTop.where((button) => !button.canBeOverwritten).toList();
      show1 = buttonData.positionY > 0 && buttonsOnTopWithFunction.isEmpty ;
      show2 = buttonData.height > 1;
      if (buttonData.canBeOverwritten) {
        show1 = false;
        show2 = false;
      }
      button1Function = () {
        buttonData.height++;
        buttonData.positionY--;
        context.read<ButtonPanelCubit>().removeButtons(buttonsOnTop);
        context.read<ButtonPanelCubit>().refresh();
      };
      button2Function = () {
        List<ButtonData> newButtons = [];
        for (int i = 0; i < buttonData.width; i++) {
          newButtons.add(ButtonData(buttonData.positionX+i, buttonData.positionY, enabled: false));
        }
        buttonData.height--;
        buttonData.positionY++;
        context.read<ButtonPanelCubit>().addButtons(newButtons);
        context.read<ButtonPanelCubit>().refresh();
      };
      rowOrColumn = Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ResizeDirectionButton(
              show1, button1Function, Icons.keyboard_arrow_up, Axis.horizontal),
          ResizeDirectionButton(
              show2, button2Function, Icons.keyboard_arrow_down, Axis.horizontal),
        ],
      );
    } else if (alignment == Alignment.centerRight) {
      margin = EdgeInsets.only(right: buttonMargin.right / 2);
      List<ButtonData> buttonsOnRight =
          context.read<ButtonPanelCubit>().getButtonsOnRight(buttonData);
      List<ButtonData> buttonsOnRightWithFunction =
          buttonsOnRight.where((button) => !button.canBeOverwritten).toList();
      show1 = buttonData.positionX + buttonData.width < context.read<ButtonPanelCubit>().getState().xSize && buttonsOnRightWithFunction.isEmpty;
      show2 = buttonData.width > 1;
      if (buttonData.canBeOverwritten) {
        show1 = false;
        show2 = false;
      }
      button1Function = () {
        buttonData.width++;
        context.read<ButtonPanelCubit>().removeButtons(buttonsOnRight);
        context.read<ButtonPanelCubit>().refresh();
      };
      button2Function = () {
        List<ButtonData> newButtons = [];
        for (int i = 0; i < buttonData.height; i++) {
          newButtons.add(ButtonData(buttonData.positionX+buttonData.width-1, buttonData.positionY+i, enabled: false));
        }
        buttonData.width--;
        context.read<ButtonPanelCubit>().addButtons(newButtons);
        context.read<ButtonPanelCubit>().refresh();
      };
      rowOrColumn = Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          ResizeDirectionButton(
              show2, button2Function, Icons.keyboard_arrow_left, Axis.vertical),
          ResizeDirectionButton(
              show1, button1Function, Icons.keyboard_arrow_right, Axis.vertical),
        ],
      );
    } else if (alignment == Alignment.bottomCenter) {
      margin = EdgeInsets.only(bottom: buttonMargin.bottom / 2);
      List<ButtonData> buttonsOnBottom =
      context.read<ButtonPanelCubit>().getButtonsOnBottom(buttonData);
      List<ButtonData> buttonsOnBottomWithFunction =
      buttonsOnBottom.where((button) => !button.canBeOverwritten).toList();
      show1 = buttonData.positionY + buttonData.height < context.read<ButtonPanelCubit>().getState().ySize && buttonsOnBottomWithFunction.isEmpty;
      show2 = buttonData.height > 1;
      if (buttonData.canBeOverwritten) {
        show1 = false;
        show2 = false;
      }
      button1Function = () {
        buttonData.height++;
        context.read<ButtonPanelCubit>().removeButtons(buttonsOnBottom);
        context.read<ButtonPanelCubit>().refresh();
      };
      button2Function = () {
        List<ButtonData> newButtons = [];
        for (int i = 0; i < buttonData.width; i++) {
          newButtons.add(ButtonData(buttonData.positionX+i, buttonData.positionY+buttonData.height-1, enabled: false));
        }
        buttonData.height--;
        context.read<ButtonPanelCubit>().addButtons(newButtons);
        context.read<ButtonPanelCubit>().refresh();
      };
      rowOrColumn = Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ResizeDirectionButton(
              show2, button2Function, Icons.keyboard_arrow_up, Axis.horizontal),
          ResizeDirectionButton(
              show1, button1Function, Icons.keyboard_arrow_down, Axis.horizontal),
        ],
      );
    } else if (alignment == Alignment.centerLeft) {
      margin = EdgeInsets.only(left: buttonMargin.left / 2);
      List<ButtonData> buttonsOnLeft =
      context.read<ButtonPanelCubit>().getButtonsOnLeft(buttonData);
      List<ButtonData> buttonsOnLeftWithFunction =
      buttonsOnLeft.where((button) => !button.canBeOverwritten).toList();
      show1 = buttonData.positionX > 0 && buttonsOnLeftWithFunction.isEmpty ;
      show2 = buttonData.width > 1;
      if (buttonData.canBeOverwritten) {
        show1 = false;
        show2 = false;
      }
      button1Function = () {
        buttonData.positionX--;
        buttonData.width++;
        context.read<ButtonPanelCubit>().removeButtons(buttonsOnLeft);
        context.read<ButtonPanelCubit>().refresh();
      };
      button2Function = () {
        List<ButtonData> newButtons = [];
        for (int i = 0; i < buttonData.height; i++) {
          newButtons.add(ButtonData(buttonData.positionX, buttonData.positionY+i, enabled: false));
        }
        buttonData.positionX++;
        buttonData.width--;
        context.read<ButtonPanelCubit>().addButtons(newButtons);
        context.read<ButtonPanelCubit>().refresh();
      };
      rowOrColumn = Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          ResizeDirectionButton(
              show1, button1Function, Icons.keyboard_arrow_left, Axis.vertical),
          ResizeDirectionButton(
              show2, button2Function, Icons.keyboard_arrow_right, Axis.vertical)
        ],
      );
    } else {
      margin = EdgeInsets.zero;
    }

    return Align(
      alignment: alignment,
      child: Container(
        margin: margin,
        height: 20,
        width: 20,
        child: rowOrColumn,
      ),
    );
  }
}
