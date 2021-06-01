import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/socket/connected_clients_cubit.dart';
import 'package:streamberry_host/src/ui/views/button_view/button_view.dart';

import 'blocs/button_panel/button_panel_cubit.dart';
import 'blocs/button_panel/button_panel_state.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static ButtonPanelState buttonPanelStateOf(BuildContext context) => buttonPanelCubitOf(context).state;
  static ButtonPanelCubit buttonPanelCubitOf(BuildContext context) => context.findAncestorStateOfType<_AppState>()!.buttonPanelCubit;

  @override
  _AppState createState() => _AppState();

}

class _AppState extends State<App> {
  late Future<ServerSocket> _serverSocketFuture;

  late final ConnectedClientsCubit _connectedClientsCubit;

  late final ButtonPanelCubit buttonPanelCubit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServerSocket>(
      future: _serverSocketFuture,
      builder: (context, serverSocket) {
        if (serverSocket.hasData) {
          return BlocProvider(
            create: (context) => _connectedClientsCubit,
            child: MaterialApp(
                themeMode: ThemeMode.dark,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                home: ButtonView(buttonPanelCubit: buttonPanelCubit)),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void initState() {
    _serverSocketFuture = ServerSocket.bind(InternetAddress.loopbackIPv4, 4567)
      ..then((serverSocket) {
        _connectedClientsCubit = ConnectedClientsCubit();
        serverSocket.listen((client) {
          _connectedClientsCubit.add(client);
        });
      });

    buttonPanelCubit = ButtonPanelCubit.init(8, 4);

    super.initState();
  }
}
