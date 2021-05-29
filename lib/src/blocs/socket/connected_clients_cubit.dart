import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectedClientsCubit extends Cubit<List<Socket>> {
  ConnectedClientsCubit() : super([]);

  void add(Socket client) {
    if (state.where((element) => element.address == client.address).isEmpty) {
      emit(state..add(client));
      _listen(client);
    }
  }

  void _listen(Socket client) {
    client.listen(
      (data) {
        final message = String.fromCharCodes(data);
      },
      onDone: () {
        print('Client with IP: ${client.remoteAddress.address} left');
        client.close();
      },
      onError: (error) {
        print(error);
        print('Client with IP: ${client.remoteAddress.address} has an error');
        client.close();

        //TODO: Maybe try a reconnect in the future
      },
    );
  }
}
