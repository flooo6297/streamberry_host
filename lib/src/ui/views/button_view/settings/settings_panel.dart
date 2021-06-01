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
                  Tab(text: 'Panel Settings',),
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

      /*child: Column(
        children: [
          Text(widget.panelState.selectedButton != null
              ? '${widget.panelState.selectedButton!.positionX} - ${widget.panelState.selectedButton!.positionY}'
              : 'sadfsdf'),
          TextButton(
            onPressed: () async {
              //var test = jsonEncode(App.buttonPanelStateOf(context).toJson());
              var test = App.buttonPanelStateOf(context).toJson();
              var test1 = 0;
            },
            child: const Text('json_test'),
          ),
          ..._buildButtonOptions(context, widget.panelState),
        ],
      ),*/
    );
  }

  List<Widget> _buildButtonOptions(
      BuildContext context, ButtonPanelState panelState) {
    if (panelState.selectedButton != null &&
        panelState.selectedButton!.onClicks.isNotEmpty) {
      return [
        TextButton(
          onPressed: () async {
            await ButtonFunctions.runActions(
                panelState.selectedButton!, context);
            //var test = jsonEncode(panelState.toJson());
            //var test1 = 0;
          },
          child: const Text('run Action'),
        ),
      ];
    }
    return [Container()];
  }
}
