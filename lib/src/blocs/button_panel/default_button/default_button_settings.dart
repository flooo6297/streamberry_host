import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/on_click.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/alignment_slider.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/add_action_dialog.dart';
import 'package:uuid/uuid.dart';

class DefaultButtonSettings extends StatefulWidget {
  final ButtonPanelCubit buttonPanelCubit;
  final ButtonData selectedButton;

  final String selectedId;

  const DefaultButtonSettings(this.buttonPanelCubit, this.selectedButton,
      {this.selectedId = '', Key? key})
      : super(key: key);

  @override
  _DefaultButtonSettingsState createState() => _DefaultButtonSettingsState();
}

class _DefaultButtonSettingsState extends State<DefaultButtonSettings> {
  late final TextEditingController buttonTextController;
  late final TextEditingController buttonTextSizeController;

  List<Widget> options = [];
  List<MapEntry<ButtonAction, OnClick>> actions = [];

  late DefaultButton defaultButton;

  @override
  void initState() {
    defaultButton = (widget.selectedButton.buttonType as DefaultButton);
    buttonTextController = TextEditingController(text: defaultButton.text);
    buttonTextSizeController =
        TextEditingController(text: '${(defaultButton.textSize).round()}');
    buttonTextController.addListener(() {
      if (buttonTextController.text != defaultButton.text) {
        defaultButton.text = buttonTextController.text;
        widget.buttonPanelCubit.refresh();
      }
    });
    buttonTextSizeController.addListener(() {
      if (buttonTextSizeController.text !=
          '${defaultButton.textSize.round()}') {
        defaultButton.textSize =
            double.parse('${buttonTextSizeController.text}.0');
        widget.buttonPanelCubit.refresh();
      }
    });
    _updateActions();
    super.initState();
  }

  @override
  void didUpdateWidget(DefaultButtonSettings oldWidget) {
    if (oldWidget.selectedId != widget.selectedId) {
      buttonTextSizeController.text = '${(defaultButton.textSize).round()}';
      buttonTextController.text = defaultButton.text;
      _updateActions();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {

    bool snapToGrid = defaultButton.snapToGrid;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
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
                ReorderableListView(
                  buildDefaultDragHandles: false,
                  shrinkWrap: true,
                  children: List<int>.generate(options.length, (i) => i)
                      .map((index) => Stack(
                            clipBehavior: Clip.none,
                            key: ValueKey(options[index]),
                            children: [
                              Card(
                                key: ValueKey(options[index]),
                                color: Theme.of(context).backgroundColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 40.0),
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(minHeight: 72),
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
                                    visible: options.length > 1,
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
                                      defaultButton.onClicks.removeAt(index);
                                      widget.buttonPanelCubit.refresh();
                                      _updateActions();
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                  onReorder: (oldIndex, newIndex) {
                    //TODO: implement reorder!!!
                  },
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
                            return AddActionDialog(widget.buttonPanelCubit, () {
                              _updateActions();
                            });
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: null,
                  controller: buttonTextController,
                  decoration: const InputDecoration(
                    labelText: 'Button Text',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2.0,
                  color: Theme.of(context).backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Text size:'),
                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: buttonTextSizeController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                min: 0.0,
                                max: defaultButton.textSize < 60.0
                                    ? 60.0
                                    : defaultButton.textSize,
                                value: defaultButton.textSize,
                                onChanged: (newValue) {
                                  defaultButton.textSize =
                                      newValue.roundToDouble();
                                  widget.buttonPanelCubit.refresh();
                                  buttonTextSizeController.text =
                                      '${newValue.round()}';
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: [
                            const Text('Text color:'),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Pick a color!'),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: defaultButton.textColor,
                                          onColorChanged: (Color value) {
                                            defaultButton.textColor = value;
                                            widget.buttonPanelCubit.refresh();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 16,
                                width: 30,
                                color: defaultButton.textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 8.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Text-Alignment:'),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Snap to Grid: '),
                            Switch(
                                value: defaultButton.snapToGrid,
                                onChanged: (newValue) {
                                  defaultButton.snapToGrid = newValue;
                                  widget.buttonPanelCubit.refresh();
                                }),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                        child: AlignmentSlider(
                            const Size(100, 100),
                            widget.buttonPanelCubit,
                            widget.selectedId,
                            snapToGrid)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                child: const Text('Pick Icon'),
                onPressed: () async {
                  OpenFilePicker picker = OpenFilePicker();
                  picker.fileMustExist = true;
                  picker.filterSpecification = {
                    'Image Files (*.jpg; *.gif; *.png)': '*.jpg;*.gif;*.png'
                  };
                  picker.title = 'Pick an Image';
                  File? file = picker.getFile();
                  if (file != null) {
                    print(file.path);
                    Uint8List imageBytes = await file.readAsBytes();
                    Box<String> images = Hive.box('images');
                    String currentImage = defaultButton.image;
                    if (currentImage.isNotEmpty &&
                        images.containsKey(currentImage)) {
                      images.delete(currentImage);
                    }
                    String newImage = const Uuid().v1();
                    images.put(newImage, base64Encode(imageBytes));
                    defaultButton.image = newImage;
                    widget.buttonPanelCubit.refresh();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateActions() {
    options = [];
    actions = [];
    actions = ButtonFunctions.getActions(widget.selectedButton);
    for (int i = 0; i < actions.length; i++) {
      options.add(
        actions[i].key.buildSettings(
          widget.buttonPanelCubit,
          widget.selectedButton,
          actions[i].value.params,
          (newParams) {
            defaultButton.onClicks[i].params = newParams;
            widget.buttonPanelCubit.refresh();
          },
        ),
      );
    }
  }
}
