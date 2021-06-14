import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obsWebsocket.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/obs/obs_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/obs/obs_web_socket_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:obs_websocket/src/model/scene.dart';

class SetSceneAction extends ButtonAction {
  SetSceneAction(ObsFunctions parentType) : super(parentType);

  ObsWebSocketCubit getCubit() {
    return (parentType as ObsFunctions).obsWebSocketCubit;
  }

  @override
  get actionName => 'setScene';

  @override
  Widget buildSettings(
      ButtonPanelCubit buttonPanelCubit,
      ButtonData parentButtonData,
      Map<String, String> params,
      Function(Map<String, String> newParams) madeChanges) {
    Future<BaseResponse?> obsFuture;
    /*if (getObs() != null) {
      obsFuture =
          getObs()!.command('GetSceneList');
    } else {
      obsFuture = Future.value();
    }*/

    return BlocProvider<ObsWebSocketCubit>(
      create: (context) => getCubit(),
      child: BlocBuilder<ObsWebSocketCubit, ObsWebSocket?>(
        builder: (context, obsWebSocket) {
          if (obsWebSocket == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Is OBS running?'),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        getCubit().reconnect();
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          obsFuture = obsWebSocket.command('GetSceneList');
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('set OBS-Scene'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      getCubit().reconnect();
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<BaseResponse?>(
                  future: obsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        List<Scene> scenes = (snapshot
                            .data!.rawResponse['scenes'] as List<dynamic>)
                            .map((e) =>
                            Scene.fromJson(e as Map<String, dynamic>))
                            .toList();

                        if (scenes.isEmpty) {
                          scenes.add(Scene(name: '', scenes: []));
                        }

                        String currentSelectedScene =
                            params['scene-name'] ?? '';
                        if (scenes
                            .where((element) =>
                        element.name == currentSelectedScene)
                            .isEmpty) {
                          currentSelectedScene = scenes[0].name;
                          madeChanges({'scene-name': currentSelectedScene});
                        }

                        return DropdownButton<String>(
                          isExpanded: true,
                          items: scenes
                              .map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem(
                                child: Text(
                                  e.name,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                                value: e.name,
                              ))
                              .toList(),
                          value: currentSelectedScene,
                          onChanged: (String? newValue) {
                            madeChanges({'scene-name': newValue!});
                          },
                        );
                      }
                    }
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Is OBS running?'),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Map<String, String> getDefaultParams() => {'scene-name': ''};

  @override
  bool isVisible(ButtonPanelCubit buttonPanelCubit) => true;

  @override
  Future<void> runFunction(
      ButtonPanelCubit buttonPanelCubit, Map<String, String> params) async {
    if (getCubit().state == null) {
      await getCubit().reconnect();
    }
    if (getCubit().state != null) {
      await getCubit().state!.setCurrentScene({"scene-name": params["scene-name"]});
    }
    return Future.value();
  }

  @override
  get title => 'set OBS Scene';

  @override
  get tooltip => 'Sets the current OBS Scene';
}
