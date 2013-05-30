library space_client;

import 'dart:html';
import 'dart:json';
import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:siege_engine/siege_engine.dart';
import 'package:space_shared/space_shared.dart';

part 'utils/canvas_manager.dart';
part 'utils/client_connection_manager.dart';
part 'utils/game_settings.dart';
part 'utils/latency_counter.dart';
part 'systems/input_system.dart';
part 'systems/rendering_system.dart';
part 'components/render_component.dart';

CanvasManager canvasManager;

void main() {
  CanvasElement canvas = query("#space_game_canvas");
  canvasManager = new CanvasManager(canvas);
  SpaceGameRunner game = new SpaceGameRunner();
  game.run();
}

class SpaceGameRunner {
  
  World _world;
  num _lastTick;
  
  SpaceGameRunner() {
    _lastTick = 0;
    _world = new World();
    new ClientConnectionManager(_world);
    _setupSystems();
  }
  
  void _setupSystems() {
    RenderingSystem renderingSystem = new RenderingSystem();
    InputProcessingSystem inputProcessingSystem = new InputProcessingSystem();
    MovementSystem movementSystem = new MovementSystem();
    InputSystem inputSystem = new InputSystem();
    
    renderingSystem.enabled = true;
    inputProcessingSystem.enabled = true;
    movementSystem.enabled = true;
    inputSystem.enabled = true;
    
    inputSystem.priority = 0;
    inputProcessingSystem.priority = 5;
    movementSystem.priority = 10;
    renderingSystem.priority = 20;
    
    _world.addSystem(renderingSystem);
    _world.addSystem(movementSystem);
    _world.addSystem(inputProcessingSystem);
    _world.addSystem(inputSystem);
  }
  
  void run([num time = 0]) {
    _world.process(time - _lastTick);
    _lastTick = time;
    window.requestAnimationFrame(run);
  }
}


