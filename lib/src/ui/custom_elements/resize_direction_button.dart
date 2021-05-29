import 'package:flutter/material.dart';

class ResizeDirectionButton extends StatelessWidget {

  final bool visible;
  final Function() function;
  final IconData icon;
  final Axis axis;

  const ResizeDirectionButton(this.visible, this.function, this.icon, this.axis, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: visible ? 1.0 : 0.0,
      child: Container(
        height: axis==Axis.horizontal?10:20,
        width: axis==Axis.horizontal?20:10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black.withAlpha(128),
        ),
        child: Visibility(
          visible: visible,
          child: InkWell(
            onTap: () {
              function();
            },
            child: Icon(
              icon,
              size: 10,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
