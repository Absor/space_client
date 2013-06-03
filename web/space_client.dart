library space_client;

import 'dart:html';
import 'dart:json';
import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:siege_engine/siege_engine.dart';
import 'package:space_shared/space_shared.dart';
import 'package:json_object/json_object.dart';

part 'utils/canvas_manager.dart';
part 'utils/connection_manager.dart';
part 'utils/game_settings.dart';
part 'utils/latency_counter.dart';
part 'utils/message_checker.dart';
part 'utils/world_controller.dart';
part 'utils/world_runner.dart';
part 'systems/input_system.dart';
part 'systems/rendering_system.dart';
part 'systems/client_movement_system.dart';
part 'systems/spline_movement_system.dart';
part 'components/render_component.dart';
part 'components/spline_position_component.dart';

CanvasManager canvasManager;

void main() {
  CanvasElement canvas = query("#space_game_canvas");
  canvasManager = new CanvasManager(canvas);
  WorldRunner wr = new WorldRunner();
  WorldController wc = new WorldController(wr.world);
  new ConnectionManager(wc);
}