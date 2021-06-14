import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';

class GlobalSettings extends StatefulWidget {

  final ButtonPanelCubit buttonPanelCubit;

  const GlobalSettings(this.buttonPanelCubit, {Key? key}) : super(key: key);

  @override
  State<GlobalSettings> createState() => _GlobalSettingsState();
}

class _GlobalSettingsState extends State<GlobalSettings> {
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
                  'Settings that affect new Folders',
                  style:
                  Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16),
                )),
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 35,
                    child: TextButton(
                      onPressed: () {
                        widget.buttonPanelCubit.state.defaultPanelOptions!.xSize -= 1;
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
                          widget.buttonPanelCubit.state.defaultPanelOptions!.xSize.toString(),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 20),
                        ),
                        Text(
                          ' ${widget.buttonPanelCubit.state.defaultPanelOptions!.xSize > 1 ? 'Columns' : 'Column'}',
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
                        widget.buttonPanelCubit.state.defaultPanelOptions!.xSize += 1;
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
                        widget.buttonPanelCubit.state.defaultPanelOptions!.ySize -= 1;
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
                          widget.buttonPanelCubit.state.defaultPanelOptions!.ySize.toString(),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 20),
                        ),
                        Text(
                          ' ${widget.buttonPanelCubit.state.defaultPanelOptions!.ySize > 1 ? 'Rows' : 'Row'}',
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
                        widget.buttonPanelCubit.state.defaultPanelOptions!.ySize += 1;
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
            ],
          ),
        ),
      ],
    );
  }
}
