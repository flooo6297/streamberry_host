import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/app.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/blocs/socket/connected_clients_cubit.dart';

class ButtonPanelCubit extends Cubit<ButtonPanelState> {

  final ConnectedClientsCubit connectedClientsCubit;

  List<int> path = [];

  ButtonPanelCubit._(ButtonPanelState initialState, this.connectedClientsCubit)
      : super(initialState);

  static ButtonPanelCubit init(int x, int y, ConnectedClientsCubit connectedClientsCubit,
      {ButtonData? parentButtonData,
      ButtonPanelCubit? parentButtonPanelCubit}) {
    ButtonPanelState initialState = ButtonPanelState(
        x,
        y,
        const Size(100, 100),
        Colors.black87,
        const EdgeInsets.all(8.0)); //TODO: Implement loading from disk
    initialState.defaultPanelOptions =
        ButtonPanelState.asDefaultPanelSettings(8, 4, const Size(100, 100),
            Colors.black87, const EdgeInsets.all(8.0));
    return ButtonPanelCubit._(initialState, connectedClientsCubit);
  }

  ButtonPanelCubit(ButtonPanelState initialState, this.connectedClientsCubit) : super(initialState);

  ButtonPanelState getState() {
    ButtonPanelState cur = state;
    for (var value in path) {
      cur = cur.panelList[value].childState!;
    }
    return cur;
  }

  void selectButton(ButtonData buttonToSelect) {
    getState().selectedButton = buttonToSelect;
    //_saveAndSync();
  }

  ButtonData? getSelectedButton() {
    if (getState().selectedButton == null) {
      return null;
    }
    return getState().panelList.firstWhere((element) => element.equals(getState().selectedButton!));
  }

  void refresh() {
    _saveAndSync();
  }

  bool setNewGridSize(int x, int y) {
    int oldX = getState().xSize;
    int oldY = getState().ySize;

    getState().ySize = y;
    getState().xSize = x;

    bool toReturn = true;

    if (x > oldX) {
      addColsOnRight(x - oldX);
    }
    if (x < oldX) {
      if (!removeColsOnRight(oldX - x)) {
        getState().ySize = oldY;
        getState().xSize = oldX;
        toReturn = false;
      }
    }
    if (y > oldY) {
      addRowsOnBottom(y - oldY);
    }
    if (y < oldY) {
      if (!removeRowsOnBottom(oldY - y)) {
        getState().ySize = oldY;
        getState().xSize = oldX;
        toReturn = false;
      }
    }

    //_saveAndSync();
    return toReturn;
  }

  void addColsOnRight(int numColsToAdd) {
    List<ButtonData> newButtons = [];
    for (int i = 0; i < numColsToAdd; i++) {
      for (int j = 0; j < getState().ySize; j++) {
        newButtons.add(ButtonData(getState().xSize - 1 - i, j, enabled: false));
      }
    }
    addButtons(newButtons);
  }

  bool removeColsOnRight(int numColsToRemove) {
    ButtonData canNotOverlap =
        ButtonData(getState().xSize, 0, width: numColsToRemove, height: getState().ySize);

    List<ButtonData> buttonsToRemove = getOverlappingButtons(canNotOverlap);

    if (buttonsToRemove
        .where((element) => element.positionX < getState().xSize)
        .isNotEmpty) {
      return false;
    }

    removeButtons(buttonsToRemove);
    //_saveAndSync();

    return true;
  }

  void addRowsOnBottom(int numRowsToAdd) {
    List<ButtonData> newButtons = [];
    for (int i = 0; i < numRowsToAdd; i++) {
      for (int j = 0; j < getState().xSize; j++) {
        newButtons.add(ButtonData(j, getState().ySize - 1 - i, enabled: false));
      }
    }
    addButtons(newButtons);
  }

  bool removeRowsOnBottom(int numRowsToRemove) {
    ButtonData canNotOverlap =
        ButtonData(0, getState().ySize, width: getState().xSize, height: numRowsToRemove);

    List<ButtonData> buttonsToRemove = getOverlappingButtons(canNotOverlap);

    if (buttonsToRemove
        .where((element) => element.positionY < getState().ySize)
        .isNotEmpty) {
      return false;
    }

    removeButtons(buttonsToRemove);
    //_saveAndSync();

    return true;
  }

  bool addButtons(List<ButtonData> newButtons) {
    getState().panelList.addAll(newButtons);
    //_saveAndSync();
    return false;
  }

  void removeButtons(List<ButtonData> buttons) {
    getState().panelList.removeWhere((toDeleteMaybe) =>
        buttons.where((toCheck) => toCheck.equals(toDeleteMaybe)).isNotEmpty);
  }

  List<ButtonData> getOverlappingButtons(ButtonData buttonData) {
    return getState().panelList
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
      for (ButtonData buttonData in getState().panelList) {
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

  void removeSelectedButton() {
    if (getState().selectedButton != null) {
      List<ButtonData> newButtons = [];
      for (int i = getState().selectedButton!.positionX;
          i < getState().selectedButton!.positionX + getState().selectedButton!.width;
          i++) {
        for (int j = getState().selectedButton!.positionY;
            j < getState().selectedButton!.positionY + getState().selectedButton!.height;
            j++) {
          newButtons.add(ButtonData(i, j, enabled: false));
        }
      }
      removeButtons([getState().selectedButton!]);
      getState().selectedButton = null;
      addButtons(newButtons);
    }
  }

  ButtonData? getButtonData(ButtonData buttonData) {
    return getState().panelList.firstWhere((element) => element.equals(buttonData));
  }

  void _saveAndSync() {
    emit(ButtonPanelState.copy(state));
    connectedClientsCubit.sync(state);
  }
}
