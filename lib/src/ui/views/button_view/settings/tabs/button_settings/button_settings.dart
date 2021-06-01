import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/ui/views/button_view/settings/tabs/button_settings/add_action_dialog.dart';

class ButtonSettings extends StatelessWidget {
  final ButtonPanelCubit buttonPanelCubit;

  const ButtonSettings(this.buttonPanelCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (buttonPanelCubit.getState().selectedButton == null) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: const Text(
          'Select a Button first',
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
      );
    }
    ButtonData selectedButton = buttonPanelCubit.getSelectedButton()!;
    List<Widget> options = [];
    ButtonFunctions.getActions(selectedButton).forEach((element) {
      options.add(element.buildSettings(context, selectedButton));
    });
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Button Functions:',
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                  ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        clipBehavior: Clip.none,
                        key: ValueKey(options[index]),
                        children: [
                          Card(
                            key: ValueKey(options[index]),
                            color: Theme.of(context).backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 40.0),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minHeight: 72),
                                child: options[index],
                              ),
                            ),
                          ),
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            start: 4,
                            end: 4,
                            bottom: 4,
                            top: 4,
                            child: Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Visibility(
                                visible: options.length>1,
                                child: ReorderableDragStartListener(
                                  index: index,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.reorder),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            start: 4,
                            end: 4,
                            bottom: 4,
                            child: Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: IconButton(
                                onPressed: () {
                                  selectedButton.onClicks.removeAt(index);
                                  buttonPanelCubit.refresh();
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    onReorder: (oldIndex, newIndex) {},
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: const Text(
                        'Add new Action',
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AddActionDialog(buttonPanelCubit);
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                child: const Text(
                  'Delete This Button',
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                onPressed: () {
                  buttonPanelCubit.removeSelectedButton();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
