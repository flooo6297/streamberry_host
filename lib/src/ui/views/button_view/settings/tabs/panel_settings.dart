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
  late TextEditingController folderNameController;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
                child: Text(
              'Settings for the current Folder',
              style:
                  Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16),
            )),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 35,
              child: TextButton(
                onPressed: () {
                  widget.buttonPanelCubit.setNewGridSize(
                      widget.buttonPanelCubit.getState().xSize - 1,
                      widget.buttonPanelCubit.getState().ySize);
                  widget.buttonPanelCubit.refresh();
                },
                child: Text(
                  '-',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 30),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.buttonPanelCubit.getState().xSize.toString(),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20),
                  ),
                  Text(
                    ' ${widget.buttonPanelCubit.getState().xSize > 1 ? 'Columns' : 'Column'}',
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 35,
              child: TextButton(
                onPressed: () {
                  widget.buttonPanelCubit.setNewGridSize(
                      widget.buttonPanelCubit.getState().xSize + 1,
                      widget.buttonPanelCubit.getState().ySize);
                  widget.buttonPanelCubit.refresh();
                },
                child: Text(
                  '+',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 26),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 35,
              child: TextButton(
                onPressed: () {
                  widget.buttonPanelCubit.setNewGridSize(
                      widget.buttonPanelCubit.getState().xSize,
                      widget.buttonPanelCubit.getState().ySize - 1);
                  widget.buttonPanelCubit.refresh();
                },
                child: Text(
                  '-',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 30),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.buttonPanelCubit.getState().ySize.toString(),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20),
                  ),
                  Text(
                    ' ${widget.buttonPanelCubit.getState().ySize > 1 ? 'Rows' : 'Row'}',
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 35,
              child: TextButton(
                onPressed: () {
                  widget.buttonPanelCubit.setNewGridSize(
                      widget.buttonPanelCubit.getState().xSize,
                      widget.buttonPanelCubit.getState().ySize + 1);
                  widget.buttonPanelCubit.refresh();
                },
                child: Text(
                  '+',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 26),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: folderNameController,
                    validator: (value) {
                      if (folderNameController.text.isEmpty) {
                        return 'The name must not be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Folder name",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(PanelSettings oldWidget) {
    if (oldWidget.buttonPanelCubit.path.length !=
        widget.buttonPanelCubit.path.length) {
      folderNameController.text = widget.buttonPanelCubit.getState().name;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    folderNameController =
        TextEditingController(text: widget.buttonPanelCubit.getState().name);
    folderNameController.addListener(() {
      if (_formKey.currentState!.validate() &&
          folderNameController.text !=
              widget.buttonPanelCubit.getState().name) {
        widget.buttonPanelCubit.getState().name = folderNameController.text;
        widget.buttonPanelCubit.refresh();
      }
    });
    super.initState();
  }
}
