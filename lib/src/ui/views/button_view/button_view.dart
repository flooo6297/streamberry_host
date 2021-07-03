
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/ui/views/button_view/button/button.dart';
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
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 380,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            left: 8,
                            child:
                                Text(widget.buttonPanelCubit.getPathString()),
                          ),
                          Positioned.fill(
                            child: Container(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: panelState.ySize *
                                            panelState.gridTilingSize.height >
                                        MediaQuery.of(context).size.height
                                    ? MediaQuery.of(context).size.height
                                    : panelState.ySize *
                                        panelState.gridTilingSize.height,
                                width: panelState.xSize *
                                            panelState.gridTilingSize.width >
                                        MediaQuery.of(context).size.width - 380
                                    ? MediaQuery.of(context).size.width - 380
                                    : panelState.xSize *
                                        panelState.gridTilingSize.width,
                                child: InteractiveViewer(
                                  constrained: false,
                                  scaleEnabled: true,
                                  alignPanAxis: true,
                                  minScale: 1,
                                  maxScale: 1,
                                  child: SizedBox(
                                    height: panelState.ySize *
                                        panelState.gridTilingSize.height,
                                    width: panelState.xSize *
                                        panelState.gridTilingSize.width,
                                    child: Stack(
                                      children: [
                                        panelState.selectedButton != null
                                            ? Positioned(
                                                top: panelState
                                                        .gridTilingSize.height *
                                                    panelState.selectedButton!
                                                        .positionY,
                                                left: panelState
                                                        .gridTilingSize.width *
                                                    panelState.selectedButton!
                                                        .positionX,
                                                height: panelState
                                                        .gridTilingSize.height *
                                                    panelState
                                                        .selectedButton!.height,
                                                width: panelState
                                                        .gridTilingSize.width *
                                                    panelState
                                                        .selectedButton!.width,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                        color:
                                                            Colors.greenAccent,
                                                        width: 3.0),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        ...(panelState.panelList
                                            .map((buttonData) => Button(
                                                buttonData,
                                                widget.buttonPanelCubit))
                                            .toList()),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SettingsPanel(panelState),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
