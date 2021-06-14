import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/audio/actions/dec_audio_volume_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/audio/actions/inc_audio_volume_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/audio/actions/mute_audio_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/audio/actions/set_audio_volume_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';

class AudioFunctions extends ButtonFunctions {

  AudioFunctions() {
    _actions = <ButtonAction>[
      MuteAudioAction(this),
      IncAudioVolumeAction(this),
      DecAudioVolumeAction(this),
      SetAudioVolumeAction(this),
    ].asMap().map((key, value) => MapEntry(value.actionName, value));
  }

  @override
  get title => 'Audio';

  late Map<String, ButtonAction> _actions;

  @override
  Map<String, ButtonAction> actions() => _actions;

  @override
  get function => 'audioFunctions';

}
