import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/on_click.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';

class ConnectedClientsCubit extends Cubit<List<Socket>> {
  ConnectedClientsCubit() : super([]);

  String lastTransfer = '';

  void add(Socket client, ButtonPanelCubit buttonPanelCubit) {
    if (state
        .where((element) =>
            element.remoteAddress.address == client.remoteAddress.address)
        .isEmpty) {
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

        List<dynamic> contentMapList =
            jsonDecode('[${message.replaceAll('}{', '},{')}]');

        for (var contentMap in contentMapList) {
          if (contentMap is Map<String, dynamic>) {
            if (contentMap.containsKey('actions')) {
              List<OnClick> onClicks = (contentMap['actions'] as List<dynamic>)
                  .map((e) => OnClick.fromJson(e as Map<String, dynamic>))
                  .toList();
              ButtonFunctions.runActionsFromOnClicks(
                  onClicks, buttonPanelCubit);
            }

            if (contentMap.containsKey('getImage')) {
              Box<String> images = Hive.box('images');
              if (images.containsKey(contentMap['getImage'] as String)) {
                client.write(jsonEncode({
                  'imageResponse': {
                    'image': contentMap['getImage'] as String,
                    'data': images.get(contentMap['getImage'] as String)
                  }
                }));
              }
            }
          }
        }
      },
      onDone: () {
        print('Client with IP: ${client.remoteAddress.address} left');
        state.removeWhere((element) =>
            element.remoteAddress.address == client.remoteAddress.address);
        client.close();
        lastTransfer = '';
        sync(buttonPanelCubit.state);
      },
      onError: (error) {
        print(error);
        print('Client with IP: ${client.remoteAddress.address} has an error');
        state.removeWhere((element) =>
            element.remoteAddress.address == client.remoteAddress.address);
        client.close();
        lastTransfer = '';

        //TODO: Maybe try a reconnect in the future
      },
    );
  }
}
