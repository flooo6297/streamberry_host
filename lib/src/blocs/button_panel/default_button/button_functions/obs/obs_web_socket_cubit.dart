import 'package:bloc/bloc.dart';
import 'package:obs_websocket/obsWebsocket.dart';

class ObsWebSocketCubit extends Cubit<ObsWebSocket?> {

  ObsWebSocketCubit() : super(null);

  Future<void> reconnect() async {

    if (state != null) {
      state!.close();
    }

    emit(null);

    await ObsWebSocket.connect(connectUrl: 'ws://localhost:4444').then((
        newObsWebSocket) {
      ObsWebSocket obsWebSocket = newObsWebSocket;
      obsWebSocket.channel.sink.done.then((value) {
        emit(null);
      });
      emit(obsWebSocket);
    }).onError((error, stackTrace) {
      emit(null);
    }).catchError((error) {
      emit(null);
    });

    return Future.value();

  }


}
