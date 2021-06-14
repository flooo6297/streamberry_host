import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button.dart';

class DefaultButtonWidget extends StatefulWidget {

  final ButtonPanelCubit buttonPanelCubit;
  final ButtonData buttonData;

  const DefaultButtonWidget(this.buttonPanelCubit, this.buttonData, {Key? key}) : super(key: key);

  @override
  _DefaultButtonWidgetState createState() => _DefaultButtonWidgetState();
}

class _DefaultButtonWidgetState extends State<DefaultButtonWidget> {
  @override
  Widget build(BuildContext context) {
    DefaultButton defaultButton = widget.buttonData.defaultButton!;

    double borderRadius = 0.0;

    if (widget.buttonPanelCubit.getState().gridTilingSize.width >
        widget.buttonPanelCubit.getState().gridTilingSize.height) {
      borderRadius = (widget.buttonPanelCubit.getState().gridTilingSize.height -
          widget.buttonPanelCubit.getState().margin.vertical) *
          widget.buttonPanelCubit.getState().borderRadius;
    } else {
      borderRadius = (widget.buttonPanelCubit.getState().gridTilingSize.width -
          widget.buttonPanelCubit.getState().margin.horizontal) *
          widget.buttonPanelCubit.getState().borderRadius;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: widget.buttonPanelCubit.getState().margin,
            decoration: BoxDecoration(
              color: defaultButton.color,
              border: Border.all(
                  color: defaultButton.color, width: widget.buttonData.borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: InkWell(
              onTap: () {
                widget.buttonPanelCubit.selectButton(widget.buttonData);
                widget.buttonPanelCubit.refresh();
              },
              child: Builder(
                builder: (context) {
                  Box<String> images = Hive.box('images');
                  if (images.containsKey(defaultButton.image)) {
                    return Image.memory(
                        base64Decode(images.get(defaultButton.image)!));
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
        Positioned(
          left: widget.buttonPanelCubit.getState().margin.left,
          top: widget.buttonPanelCubit.getState().margin.top,
          right: widget.buttonPanelCubit.getState().margin.right,
          bottom: widget.buttonPanelCubit.getState().margin.bottom,
          child: Align(
            alignment: defaultButton.textAlignment,
            child: Padding(
              padding: EdgeInsets.all(widget.buttonData.borderWidth),
              child: IgnorePointer(
                ignoring: true,
                child: Text(
                  defaultButton.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: defaultButton.textSize, color: defaultButton.textColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}