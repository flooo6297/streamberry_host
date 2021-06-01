import 'package:streamberry_host/src/blocs/button_panel/button_functions/audio/actions/mute_audio_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/actions/close_folder_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/actions/open_folder_action.dart';

class AudioFunctions extends ButtonFunctions {

  @override
  get title => 'Audio';

  @override
  Map<String, ButtonAction> actions(Map<String, String> params) => {
    MuteAudioAction().actionName: MuteAudioAction()..setParams(params),
  };

  @override
  get function => 'audioFunctions';

}
