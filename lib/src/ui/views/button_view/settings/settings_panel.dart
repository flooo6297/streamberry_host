import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/app.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/ui/views/button_view/settings/tabs/button_settings/button_settings.dart';
import 'package:streamberry_host/src/ui/views/button_view/settings/tabs/global_settings.dart';
import 'package:streamberry_host/src/ui/views/button_view/settings/tabs/panel_settings.dart';

class SettingsPanel extends StatefulWidget {
  final ButtonPanelState panelState;

  const SettingsPanel(
    this.panelState, {
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              height: kToolbarHeight,
              child: const TabBar(

                tabs: [
                  Tab(text: 'Button Settings',),
                  Tab(text: 'Folder Settings',),
                  Tab(text: 'Global Settings',),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ButtonSettings(context.read<ButtonPanelCubit>()),
              PanelSettings(context.read<ButtonPanelCubit>()),
              GlobalSettings(App.buttonPanelCubitOf(context)),
            ],
          ),
        ),
      ),
    );
  }
}
