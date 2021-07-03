import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/data_update_templates/data_update_template.dart';
import 'package:streamberry_host/src/blocs/button_panel/slider_button/slider_button.dart';

class SliderButtonWidget extends StatelessWidget {
  final ButtonPanelCubit buttonPanelCubit;
  final ButtonData buttonData;

  const SliderButtonWidget(this.buttonPanelCubit, this.buttonData, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SliderButton sliderButton = buttonData.buttonType as SliderButton;

    double borderRadius = 0.0;

    if (buttonPanelCubit.getState().gridTilingSize.width >
        buttonPanelCubit.getState().gridTilingSize.height) {
      borderRadius = (buttonPanelCubit.getState().gridTilingSize.height -
          buttonPanelCubit.getState().margin.vertical) *
          buttonPanelCubit.getState().borderRadius;
    } else {
      borderRadius = (buttonPanelCubit.getState().gridTilingSize.width -
          buttonPanelCubit.getState().margin.horizontal) *
          buttonPanelCubit.getState().borderRadius;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: buttonPanelCubit.getState().margin,
            decoration: BoxDecoration(
              color: sliderButton.backgroundColor,
              border: Border.all(
                  color: sliderButton.backgroundColor, width: buttonData.borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius-buttonData.borderWidth/2),
              child: InkWell(
                onTap: () {
                  buttonPanelCubit.selectButton(buttonData);
                  buttonPanelCubit.refresh();
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return StreamBuilder<Map<String, String>>(
                      stream: DataUpdateTemplate.dataUpdateStream.stream,
                      builder: (context, snapshot) {
                        double distance = (sliderButton.axis == Axis.vertical
                                ? constraints.biggest.height
                                : constraints.biggest.width) *
                            0.5;
                        if (snapshot.hasData) {
                          distance = (sliderButton.axis == Axis.vertical
                                  ? constraints.biggest.height
                                  : constraints.biggest.width) *
                              double.parse(snapshot.data!['volume'] ?? '0.5');
                        }
                        if (sliderButton.axis == Axis.vertical) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                color: Colors.greenAccent,
                                height: distance,
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                color: Colors.greenAccent,
                                width: distance,
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
