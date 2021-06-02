import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/on_click.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';

class ConnectedClientsCubit extends Cubit<List<Socket>> {
  ConnectedClientsCubit() : super([]);

  String lastTransfer = '';

  void add(Socket client, ButtonPanelCubit buttonPanelCubit) {
    if (state.where((element) => element.address == client.address).isEmpty) {
      emit(state..add(client));
      _listen(client, buttonPanelCubit);
    }
    sync(buttonPanelCubit.state);
  }

  void sync(ButtonPanelState buttonPanelState) {
    print('syncing panel-state');
    for (int i = 0; i < state.length; i++) {
      //try {
        String toTransfer = jsonEncode({'panelData': buttonPanelState.toJson()});
        if (toTransfer != lastTransfer) {
          state[i].write(toTransfer);
          lastTransfer = toTransfer;
        }
      /*} catch (exception) {
        print(exception);
        emit(state..removeAt(i));
        i--;
      }*/
    }
  }

  void _listen(Socket client, ButtonPanelCubit buttonPanelCubit) {
    client.listen(
      (data) {
        final message = String.fromCharCodes(data);
        print(message);

        Map<String, dynamic> contentMap = jsonDecode(message);

        if (contentMap.containsKey('actions')) {
          List<OnClick> onClicks = (contentMap['actions'] as List<dynamic>).map((e) => OnClick.fromJson(e as Map<String, dynamic>)).toList();
          ButtonFunctions.runActionsFromOnClicks(onClicks, buttonPanelCubit);
        }

      },
      onDone: () {
        print('Client with IP: ${client.remoteAddress.address} left');
        client.close();
      },
      onError: (error) {
        print(error);
        print('Client with IP: ${client.remoteAddress.address} has an error');
        client.close();

        //TODO: Maybe try a reconnect in the future
      },
    );
  }
}
