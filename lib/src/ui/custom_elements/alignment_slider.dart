import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button.dart';

class AlignmentSlider extends StatefulWidget {
  final Size size;

  final String selectedId;
  final ButtonPanelCubit buttonPanelCubit;
  final bool snapToGrid;

  const AlignmentSlider(this.size, this.buttonPanelCubit, this.selectedId, this.snapToGrid,
      {Key? key})
      : super(key: key);

  @override
  _AlignmentSliderState createState() => _AlignmentSliderState();
}

class _AlignmentSliderState extends State<AlignmentSlider> {
  late ValueNotifier<Alignment> _notifier;

  double pointerSizeHalf = 4.0;
  double snapOffsetMultiplier = 1.5;

  @override
  Widget build(BuildContext context) {
    final center = Offset(widget.size.width / 2, widget.size.height / 2);

    return Center(
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            height: widget.size.height,
            width: widget.size.width,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(color: Theme.of(context).backgroundColor)),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: (center.dx-0.25),
                  right: (center.dx-0.25),
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: (center.dx-(pointerSizeHalf))/2+(pointerSizeHalf)-0.25,
                  width: 0.5,
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: (center.dx-(pointerSizeHalf))/2+(pointerSizeHalf)-0.25,
                  width: 0.5,
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: (pointerSizeHalf)-0.25,
                  width: 0.5,
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: (pointerSizeHalf)-0.25,
                  width: 0.5,
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                  ),
                ),
                Positioned(
                  top: (center.dx-0.25),
                  bottom: (center.dx-0.25),
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                  ),
                ),
                Positioned(
                  top: (center.dy-(pointerSizeHalf))/2+(pointerSizeHalf)-0.25,
                  height: 0.5,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                  ),
                ),
                Positioned(
                  bottom: (center.dy-(pointerSizeHalf))/2+(pointerSizeHalf)-0.25,
                  height: 0.5,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: (pointerSizeHalf)-0.25,
                  height: 0.5,
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: (pointerSizeHalf)-0.25,
                  height: 0.5,
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                  ),
                ),
                ValueListenableBuilder<Alignment>(
                  valueListenable: _notifier,
                  builder: (context, value, _) {
                    final offset =
                        _toLocal(value, center, widget.size, pointerSizeHalf);
                    return Positioned(
                      left: offset.dx - (pointerSizeHalf),
                      top: offset.dy - (pointerSizeHalf),
                      child: Material(
                        borderRadius: BorderRadius.circular(pointerSizeHalf),
                        elevation: 2.0,
                        child: Container(
                          height: pointerSizeHalf * 2,
                          width: pointerSizeHalf * 2,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(pointerSizeHalf),
                            color: Theme.of(context).selectedRowColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onPanStart: (details) {
                    final alignment = _toGrid(
                      details.localPosition,
                      center,
                      widget.size,
                      pointerSizeHalf,
                    );
                    (widget.buttonPanelCubit
                        .getState()
                        .selectedButton!.defaultButton!)
                        .textAlignment = Alignment(alignment.x, alignment.y);
                    widget.buttonPanelCubit.refresh();
                  },
                  onPanUpdate: (details) {
                    final alignment = _toGrid(
                      details.localPosition,
                      center,
                      widget.size,
                      pointerSizeHalf,
                    );
                    (widget.buttonPanelCubit
                        .getState()
                        .selectedButton!.defaultButton!)
                        .textAlignment = Alignment(alignment.x, alignment.y);
                    widget.buttonPanelCubit.refresh();
                  },
                  onPanEnd: (details) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Offset _toLocal(Alignment value, Offset center, Size size, double dl) {
    final limitX = (size.width / 2) - (dl);
    final limitY = (size.height / 2) - (dl);
    final x = value.x * limitX;
    final y = -value.y * limitY;
    return Offset(x, -y) + center;
  }

  Alignment _toGrid(Offset value, Offset center, Size size, double dl) {
    Offset limitedValue = getFromLimits(
        value, Offset(dl, dl), Offset(size.width - dl, size.height - dl));
    limitedValue = snapToGrid(limitedValue, center, dl);

    final vector = limitedValue - center;
    final limitX = (size.width / 2) - dl;
    final limitY = (size.height / 2) - dl;

    return Alignment(vector.dx / limitX, vector.dy / limitY);
  }

  Offset snapToGrid(Offset value, Offset center, double dl) {
    double newX = value.dx;
    double newY = value.dy;

    if (widget.snapToGrid) {
      if (center.dx - (dl*snapOffsetMultiplier) < value.dx && center.dx + (dl*snapOffsetMultiplier) > value.dx) {
        newX = center.dx;
      }
      if (dl + ((center.dx-dl)/2) - (dl*snapOffsetMultiplier) < value.dx && dl + ((center.dx-dl)/2) + (dl*snapOffsetMultiplier) > value.dx) {
        newX = (center.dx-dl)/2 + dl;
      }
      if (center.dx + (((center.dx-dl)/2) - (dl*snapOffsetMultiplier)) < value.dx && center.dx + (((center.dx-dl)/2) + (dl*snapOffsetMultiplier)) > value.dx) {
        newX = (center.dx+((center.dx-dl)/2));
      }
      if (center.dy - (dl*snapOffsetMultiplier) < value.dy && center.dy + (dl*snapOffsetMultiplier) > value.dy) {
        newY = center.dy;
      }
      if (dl + ((center.dy-dl)/2) - (dl*snapOffsetMultiplier) < value.dy && dl + ((center.dy-dl)/2) + (dl*snapOffsetMultiplier) > value.dy) {
        newY = (center.dy-dl)/2 + dl;
      }
      if (center.dy + (((center.dy-dl)/2) - (dl*snapOffsetMultiplier)) < value.dy && center.dy + (((center.dy-dl)/2) + (dl*snapOffsetMultiplier)) > value.dy) {
        newY = (center.dy+((center.dy-dl)/2));
      }
    }

    return Offset(newX, newY);
  }

  Offset getFromLimits(Offset value, Offset bottomLimit, Offset topLimit) {
    double newX = value.dx;
    double newY = value.dy;

    if (value.dx < bottomLimit.dx) {
      newX = bottomLimit.dx;
    }
    if (value.dy < bottomLimit.dy) {
      newY = bottomLimit.dy;
    }
    if (value.dx > topLimit.dx) {
      newX = topLimit.dx;
    }
    if (value.dy > topLimit.dy) {
      newY = topLimit.dy;
    }
    return Offset(newX, newY);
  }

  @override
  void didUpdateWidget(AlignmentSlider oldWidget) {
    if ((oldWidget.selectedId != widget.selectedId &&
        widget.buttonPanelCubit.getState().selectedButton != null)) {
      _notifier.value =
          (widget.buttonPanelCubit.getState().selectedButton!.defaultButton!).textAlignment;
    }

    _notifier.value =
        (widget.buttonPanelCubit.getState().selectedButton!.defaultButton!).textAlignment;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _notifier = ValueNotifier(
        (widget.buttonPanelCubit.getState().selectedButton!.defaultButton!).textAlignment);

    super.initState();
  }
}
