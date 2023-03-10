import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/obs/actions/set_scene_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/obs/obs_web_socket_cubit.dart';

class ObsFunctions extends ButtonFunctions {

  ObsWebSocketCubit obsWebSocketCubit = ObsWebSocketCubit();

  ObsFunctions() {
    obsWebSocketCubit.reconnect();
    _actions = <ButtonAction>[
      SetSceneAction(this),
    ].asMap().map((key, value) => MapEntry(value.actionName, value));
  }

  late Map<String, ButtonAction> _actions;

  @override
  Map<String, ButtonAction> actions() => _actions;

  @override
  get function => 'obsFunctions';

  @override
  get title => 'OBS';
}
