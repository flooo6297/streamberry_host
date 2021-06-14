import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/on_click.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:socket_io/src/namespace.dart';
import 'package:socket_io/socket_io.dart';

class SocketHelper{

  late Server io;

  String lastState = '';

  void createNamespaces(ButtonPanelCubit buttonPanelCubit) {
    io  = Server();

    io.on('connection', (client) {
      print('client connected');
      _listenToPanelDataRequest(client, buttonPanelCubit);
      _listenToGetImage(client, buttonPanelCubit);
      _listenToRunActions(client, buttonPanelCubit);
      notifyClients(buttonPanelCubit.state, force: true);

    });


    io.listen(3000);

  }

  void notifyClients(ButtonPanelState buttonPanelState, {bool force = false}) {
    //try {
    String newState = jsonEncode(buttonPanelState.toJson());
    if (newState != lastState || force) {
      print('notify Changes');

      io.emit('updateAvailable', '');

      lastState = newState;
    }
  }

  void _sendState(ButtonPanelCubit buttonPanelCubit, List<String> path) {
    MapEntry<ButtonPanelState, List<String>> stateToSend =
        buttonPanelCubit.getStateFromPath(path);

    String toTransfer = jsonEncode({
      'state': stateToSend.key.toJson(),
      'path': stateToSend.value,
      'pathNames':
          buttonPanelCubit.getPathNameList(pathToString: stateToSend.value)
    });
    io.emit('panelData', toTransfer);
  }

  void _listenToPanelDataRequest(
      Socket client, ButtonPanelCubit buttonPanelCubit) {
    client.on('requestState', (data) {
      print(data);

      Map<String, dynamic> contentMap = jsonDecode(data);

      List<dynamic> path = contentMap['path'];
      _sendState(buttonPanelCubit, path.cast());
    });
  }

  void _listenToRunActions(Socket client, ButtonPanelCubit buttonPanelCubit) {
    client.on('runActions', (data) {
      print(data);

      Map<String, dynamic> contentMap = jsonDecode(data);

      List<OnClick> onClicks = (contentMap['actions'] as List<dynamic>)
          .map((e) => OnClick.fromJson(e as Map<String, dynamic>))
          .toList();
      ButtonFunctions.runActionsFromOnClicks(onClicks, buttonPanelCubit);
    });
  }

  void _listenToGetImage(Socket client, ButtonPanelCubit buttonPanelCubit) {
    client.on('getImage', (data) {
      print(data);

      Map<String, dynamic> contentMap = jsonDecode(data);

        Box<String> images = Hive.box('images');
        if (images.containsKey(contentMap['image'] as String)) {
          client.emit('imageData', jsonEncode({
            'image': contentMap['image'] as String,
            'data': images.get(contentMap['image'] as String)
          }));
        }
    });
  }

}
