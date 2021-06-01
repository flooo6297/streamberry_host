import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/actions/open_folder_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';

class AddActionDialog extends StatefulWidget {
  final ButtonPanelCubit buttonPanelCubit;

  const AddActionDialog(this.buttonPanelCubit, {Key? key}) : super(key: key);

  @override
  _AddActionDialogState createState() => _AddActionDialogState();
}

class _AddActionDialogState extends State<AddActionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 8.0,
      child: contentList(context),
    );
  }

  Widget contentList(BuildContext context) {
    List<Widget> listContent = [];

    ButtonFunctions.functions.forEach((functionKey, function) {
      List<Widget> actions = [];

      function.actions({}).forEach((actionKey, action) {
        actions.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Card(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(action.title),
                    TextButton(
                        onPressed: () {
                          widget.buttonPanelCubit.getSelectedButton()!.onClicks
                              .add(action.toOnClick());

                          if (action.actionName ==
                              OpenFolderAction().actionName) {
                            widget.buttonPanelCubit.getSelectedButton()!
                                .childState = ButtonPanelCubit.init(
                                    widget.buttonPanelCubit.state.xSize,
                                    widget.buttonPanelCubit.state.ySize,
                                    parentButtonData: widget
                                        .buttonPanelCubit.getSelectedButton()!,
                                    parentButtonPanelCubit:
                                        widget.buttonPanelCubit)
                                .state;
                          }

                          widget.buttonPanelCubit.refresh();

                          Navigator.pop(context);
                        },
                        child: const Text('Add Action')),
                  ],
                ),
              ),
            ),
          ),
        );
      });

      actions.add(const SizedBox(
        height: 4.0,
      ));

      listContent.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    function.title,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                ),
              ],
            ),
          ),
        ),
      );
    });

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: listContent,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Close',
                      ),
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
