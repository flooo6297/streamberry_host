import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/socket/socket_helper.dart';
import 'package:streamberry_host/src/ui/views/button_view/button_view.dart';

import 'blocs/button_panel/button_panel_cubit.dart';
import 'blocs/button_panel/button_panel_state.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static ButtonPanelState buttonPanelStateOf(BuildContext context) => buttonPanelCubitOf(context).state;
  static ButtonPanelCubit buttonPanelCubitOf(BuildContext context) => context.findAncestorStateOfType<_AppState>()!.buttonPanelCubit;
  static SocketHelper socketHelperOf(BuildContext context) => context.findAncestorStateOfType<_AppState>()!._socketHelper;

  @override
  _AppState createState() => _AppState();

}

class _AppState extends State<App> {

  late final SocketHelper _socketHelper;

  late final ButtonPanelCubit buttonPanelCubit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initWindowOptions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return MaterialApp(
            themeMode: ThemeMode.dark,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: ButtonView(buttonPanelCubit: buttonPanelCubit));
      }
    );
  }

  @override
  void initState() {
    _socketHelper = SocketHelper();
    buttonPanelCubit = ButtonPanelCubit.init(8, 4, _socketHelper);
    _socketHelper.createNamespaces(buttonPanelCubit);

    super.initState();
  }

  Future<bool> _initWindowOptions() async {

    await DesktopWindow.setMinWindowSize(Size(800, 400));

    return true;
  }

}
