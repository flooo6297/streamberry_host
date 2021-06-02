import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';

class PanelSettings extends StatefulWidget {

  final ButtonPanelCubit buttonPanelCubit;

  const PanelSettings(this.buttonPanelCubit, {Key? key}) : super(key: key);

  @override
  State<PanelSettings> createState() => _PanelSettingsState();
}

class _PanelSettingsState extends State<PanelSettings> {

  late TextEditingController numOfCols;
  late TextEditingController numOfRows;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        TextField(
            controller: numOfCols,
            decoration: const InputDecoration(labelText: "Number of Columns"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ]),
        TextField(
          controller: numOfRows,
          decoration: const InputDecoration(labelText: "Number of Rows"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    numOfCols = TextEditingController(
        text: widget.buttonPanelCubit.getState().xSize.toString());

    numOfRows = TextEditingController(
        text: widget.buttonPanelCubit.getState().ySize.toString());

    numOfCols.addListener(_changeRowsAndColsListener);
    numOfRows.addListener(_changeRowsAndColsListener);
    super.initState();
  }

  void _changeRowsAndColsListener() {
    if (numOfCols.text.trim().toString().isNotEmpty &&
        numOfRows.text.trim().toString().isNotEmpty) {
      int x = int.parse(numOfCols.text.trim().toString());
      int y = int.parse(numOfRows.text.trim().toString());
      if (!widget.buttonPanelCubit.setNewGridSize(x, y)) {
        numOfCols.text = widget.buttonPanelCubit.getState().xSize.toString();
        numOfRows.text = widget.buttonPanelCubit.getState().ySize.toString();
      } else {
        widget.buttonPanelCubit.refresh();
      }
    }
  }
}
