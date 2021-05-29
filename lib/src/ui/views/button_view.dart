import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/app.dart';
import 'package:streamberry_host/src/blocs/button_panel/button.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';

class ButtonView extends StatefulWidget {
  final ButtonPanelCubit buttonPanelCubit;

  // ignore: prefer_const_constructors_in_immutables
  ButtonView({Key? key, required this.buttonPanelCubit}) : super(key: key);

  @override
  _ButtonViewState createState() => _ButtonViewState();
}

class _ButtonViewState extends State<ButtonView> {
  //final ButtonPanelCubit buttonPanelCubit = ButtonPanelCubit.init(5, 5);
  late TextEditingController numOfCols;
  late TextEditingController numOfRows;

  void _changeRowsAndColsListener() {
    if (numOfCols.text.trim().toString().isNotEmpty &&
        numOfRows.text.trim().toString().isNotEmpty) {
      int x = int.parse(numOfCols.text.trim().toString());
      int y = int.parse(numOfRows.text.trim().toString());
      if (!widget.buttonPanelCubit.setNewGridSize(x, y)) {
        numOfCols.text = widget.buttonPanelCubit.state.xSize.toString();
        numOfRows.text = widget.buttonPanelCubit.state.ySize.toString();
      }
    }
  }

  @override
  void initState() {
    numOfCols = TextEditingController(
        text: widget.buttonPanelCubit.state.xSize.toString());
    numOfRows = TextEditingController(
        text: widget.buttonPanelCubit.state.ySize.toString());

    numOfCols.addListener(_changeRowsAndColsListener);
    numOfRows.addListener(_changeRowsAndColsListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider(
        create: (context) => widget.buttonPanelCubit,
        child: BlocBuilder<ButtonPanelCubit, ButtonPanelState>(
          builder: (context, panelState) {
            return Container(
              color: panelState.backgroundColor,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height:
                            panelState.ySize * panelState.gridTilingSize.height,
                        width:
                            panelState.xSize * panelState.gridTilingSize.width,
                        child: Stack(
                          children: panelState.panelList
                              .map((buttonData) =>
                                  Button(buttonData, panelState))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    color: Colors.red,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextField(
                            controller: numOfCols,
                            decoration: const InputDecoration(
                                labelText: "Number of Columns"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                        TextField(
                          controller: numOfRows,
                          decoration: const InputDecoration(
                              labelText: "Number of Rows"),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        Text(panelState.selectedButton != null
                            ? '${panelState.selectedButton!.positionX} - ${panelState.selectedButton!.positionY}'
                            : 'sadfsdf'),
                        TextButton(
                          onPressed: () async {
                            var test = jsonEncode(App.buttonPanelStateOf(context).toJson());
                            var test1 = 0;
                          },
                          child: const Text('json_test'),
                        ),
                        ..._buildButtonOptions(context, panelState),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildButtonOptions(
      BuildContext context, ButtonPanelState panelState) {
    if (panelState.selectedButton != null && panelState.selectedButton!.functions.isNotEmpty) {
      return [
        TextButton(
          onPressed: () async {
            await ButtonFunctions.parse(panelState.selectedButton!, context);
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
