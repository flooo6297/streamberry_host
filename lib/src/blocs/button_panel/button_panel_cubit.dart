import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';

class ButtonPanelCubit extends Cubit<ButtonPanelState> {

  ButtonPanelCubit._(ButtonPanelState initialState) : super(initialState) {
    //loadTesting();
  }

  static ButtonPanelCubit init(int x, int y) {
    ButtonPanelState initialState = ButtonPanelState(x, y, const Size(100, 100),
        Colors.black87, const EdgeInsets.all(8.0)); //TODO: Implement loading from disk
    return ButtonPanelCubit._(initialState);
  }

  ButtonPanelCubit(ButtonPanelState initialState) : super(initialState);

  void selectButton(ButtonData buttonToSelect) {
    state.selectedButton = buttonToSelect;
    refresh();
  }

  void refresh() {
    emit(ButtonPanelState.copy(state));
  }

  bool setNewGridSize(int x, int y) {
    int oldX = state.xSize;
    int oldY = state.ySize;

    state.ySize = y;
    state.xSize = x;

    bool toReturn = true;

    if (x > oldX) {
      addColsOnRight(x - oldX);
    }
    if (x < oldX) {
      if (!removeColsOnRight(oldX - x)) {
        state.ySize = oldY;
        state.xSize = oldX;
        toReturn = false;
      }
    }
    if (y > oldY) {
      addRowsOnBottom(y - oldY);
    }
    if (y < oldY) {
      if (!removeRowsOnBottom(oldY - y)) {
        state.ySize = oldY;
        state.xSize = oldX;
        toReturn = false;
      }
    }

    emit(ButtonPanelState.copy(state));
    return toReturn;
  }

  void addColsOnRight(int numColsToAdd) {
    List<ButtonData> newButtons = [];
    for (int i = 0; i < numColsToAdd; i++) {
      for (int j = 0; j < state.ySize; j++) {
        newButtons.add(ButtonData(state.xSize - 1 - i, j, enabled: false));
      }
    }
    addButtons(newButtons);
  }

  bool removeColsOnRight(int numColsToRemove) {
    ButtonData canNotOverlap =
        ButtonData(state.xSize, 0, width: numColsToRemove, height: state.ySize);

    List<ButtonData> buttonsToRemove = getOverlappingButtons(canNotOverlap);

    if (buttonsToRemove
        .where((element) => element.positionX < state.xSize)
        .isNotEmpty) {
      return false;
    }

    removeButtons(buttonsToRemove);

    return true;
  }

  void addRowsOnBottom(int numRowsToAdd) {
    List<ButtonData> newButtons = [];
    for (int i = 0; i < numRowsToAdd; i++) {
      for (int j = 0; j < state.xSize; j++) {
        newButtons.add(ButtonData(j, state.ySize - 1 - i, enabled: false));
      }
    }
    addButtons(newButtons);
  }

  bool removeRowsOnBottom(int numRowsToRemove) {
    ButtonData canNotOverlap =
        ButtonData(0, state.ySize, width: state.xSize, height: numRowsToRemove);

    List<ButtonData> buttonsToRemove = getOverlappingButtons(canNotOverlap);

    if (buttonsToRemove
        .where((element) => element.positionY < state.ySize)
        .isNotEmpty) {
      return false;
    }

    removeButtons(buttonsToRemove);

    return true;
  }

  bool addButtons(List<ButtonData> newButtons) {
    emit(state..panelList.addAll(newButtons));
    return false;
  }

  void removeButtons(List<ButtonData> buttons) {
    state.panelList.removeWhere((toDeleteMaybe) =>
        buttons.where((toCheck) => toCheck.equals(toDeleteMaybe)).isNotEmpty);
  }

  List<ButtonData> getOverlappingButtons(ButtonData buttonData) {
    return state.panelList
        .where((button) =>
            buttonData.overlaps(button) && !buttonData.equals(button))
        .toList();
  }

  void disableButtons(List<ButtonData> buttons) {
    _setButtonsEnableStatus(buttons, false);
  }

  void enableButtons(List<ButtonData> buttons) {
    _setButtonsEnableStatus(buttons, true);
  }

  void _setButtonsEnableStatus(List<ButtonData> buttons, bool status) {
    for (int i = 0; i < buttons.length; i++) {
      for (ButtonData buttonData in state.panelList) {
        if (buttonData.equals(buttons[i])) {
          buttonData.enabled = status;
        }
      }
    }
  }

  List<ButtonData> getButtonsOnTop(ButtonData buttonData) {
    ButtonData buttonToCheck = ButtonData.copy(buttonData);
    buttonToCheck.height++;
    buttonToCheck.positionY--;

    return getOverlappingButtons(buttonToCheck)
      ..removeWhere((element) => element.equals(buttonData));
  }

  List<ButtonData> getButtonsOnRight(ButtonData buttonData) {
    ButtonData buttonToCheck = ButtonData.copy(buttonData);
    buttonToCheck.width++;

    return getOverlappingButtons(buttonToCheck)
      ..removeWhere((element) => element.equals(buttonData));
  }

  List<ButtonData> getButtonsOnBottom(ButtonData buttonData) {
    ButtonData buttonToCheck = ButtonData.copy(buttonData);
    buttonToCheck.height++;

    return getOverlappingButtons(buttonToCheck)
      ..removeWhere((element) => element.equals(buttonData));
  }

  List<ButtonData> getButtonsOnLeft(ButtonData buttonData) {
    ButtonData buttonToCheck = ButtonData.copy(buttonData);
    buttonToCheck.width++;
    buttonToCheck.positionX--;

    return getOverlappingButtons(buttonToCheck)
      ..removeWhere((element) => element.equals(buttonData));
  }
}
