part of space_client;

class WorldRunner {
  
  World world;
  num _lastTick;
  
  WorldRunner() {
    world = new World();
    _lastTick = 0;
    _setupSystems();
    _run(0);
  }

  void _setupSystems() {
    RenderingSystem renderingSystem = new RenderingSystem();
    InputProcessingSystem inputProcessingSystem = new InputProcessingSystem();
    ClientMovementSystem movementSystem = new ClientMovementSystem();
    InputSystem inputSystem = new InputSystem();
    SplineMovementSystem splineMovementSystem = new SplineMovementSystem();
    
    renderingSystem.enabled = true;
    inputProcessingSystem.enabled = true;
    movementSystem.enabled = true;
    inputSystem.enabled = true;
    splineMovementSystem.enabled = true;
    
    inputSystem.priority = 0;
    inputProcessingSystem.priority = 5;
    movementSystem.priority = 10;
    renderingSystem.priority = 20;
    splineMovementSystem.priority = 10;
    
    world.addSystem(renderingSystem);
    world.addSystem(movementSystem);
    world.addSystem(inputProcessingSystem);
    world.addSystem(inputSystem);
    world.addSystem(splineMovementSystem);
  }
  
  void _run(num time) {
    world.process(time - _lastTick);
    _lastTick = time;
    window.requestAnimationFrame(_run);
  }
}