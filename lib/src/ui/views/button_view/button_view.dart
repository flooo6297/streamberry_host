import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/app.dart';
import 'package:streamberry_host/src/ui/custom_elements/split.dart';
import 'package:streamberry_host/src/ui/views/button_view/button/button.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/ui/views/button_view/settings/settings_panel.dart';

class ButtonView extends StatefulWidget {
  final ButtonPanelCubit buttonPanelCubit;

  // ignore: prefer_const_constructors_in_immutables
  ButtonView({Key? key, required this.buttonPanelCubit}) : super(key: key);

  @override
  _ButtonViewState createState() => _ButtonViewState();
}

class _ButtonViewState extends State<ButtonView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.0,
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: BlocProvider(
          create: (context) => widget.buttonPanelCubit,
          child: BlocBuilder<ButtonPanelCubit, ButtonPanelState>(
            builder: (context, topPanelState) {
              ButtonPanelState panelState =
                  context.read<ButtonPanelCubit>().getState();
              return Container(
                color: panelState.backgroundColor,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: Split(
                  axis: Axis.horizontal,
                  firstChild: Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height:
                          panelState.ySize * panelState.gridTilingSize.height,
                      width: panelState.xSize * panelState.gridTilingSize.width,
                      child: Stack(
                        children: [
                          panelState.selectedButton!=null?Positioned(
                            top: panelState.gridTilingSize.height * panelState.selectedButton!.positionY,
                            left: panelState.gridTilingSize.width * panelState.selectedButton!.positionX,
                            height: panelState.gridTilingSize.height * panelState.selectedButton!.height,
                            width: panelState.gridTilingSize.width * panelState.selectedButton!.width,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.greenAccent, width: 3.0),
                              ),
                            ),
                          ):Container(),
                          ...(panelState.panelList
                              .map((buttonData) =>
                                  Button(buttonData, panelState))
                              .toList()),
                        ],
                      ),
                    ),
                  ),
                  secondChild: SettingsPanel(panelState),
                  initialFirstFraction: 2 / 3,
                  mode: SplitMode.leftExpand,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
