part of space_client;

class WorldController {
  
  World _world;
  Component playerInput;
  
  WorldController(this._world);
  
  void localPlayerJoin(int id) {
    Entity player = _world.createEntity(id);
    
    PositionComponent position = new PositionComponent();
    position.x = 0;
    position.y = 0;
    player.addComponent(position);
    
    RenderComponent rc = new RenderComponent();
    rc.source = new ImageElement(src:"assets/ships.png");
    rc.sourceX = 0;
    rc.sourceY = 0;
    rc.sourceHeight = 256;
    rc.sourceWidth = 256;
    rc.xOffset = -128;
    rc.yOffset = -128;
    rc.imageScaler = 1;
    player.addComponent(rc);
    
    RotationComponent rotation = new RotationComponent();
    rotation.angleInDegrees = 0;
    player.addComponent(rotation);
    
    AccelerationComponent acceleration = new AccelerationComponent();
    acceleration.x = 0;
    acceleration.y = 0;
    player.addComponent(acceleration);
    
    VelocityComponent velocity = new VelocityComponent();
    velocity.x = 0;
    velocity.y = 0;
    player.addComponent(velocity);
    
    player.addComponent(new CameraCenteringComponent());
    InputComponent input = new InputComponent();
    input.thrust = 0;
    input.turn = 0;
    player.addComponent(input);
    playerInput = input;
    
    _world.activateEntity(id);
  }
  
  void internetPlayerJoin(int id) {
    Entity player = _world.createEntity(id);
    
    PositionComponent position = new PositionComponent();
    position.x = 0;
    position.y = 0;
    player.addComponent(position);
    
    RenderComponent rc = new RenderComponent();
    rc.source = new ImageElement(src:"assets/ships.png");
    rc.sourceX = 0;
    rc.sourceY = 0;
    rc.sourceHeight = 256;
    rc.sourceWidth = 256;
    rc.xOffset = -128;
    rc.yOffset = -128;
    rc.imageScaler = 1;
    player.addComponent(rc);
    
    RotationComponent rotation = new RotationComponent();
    rotation.angleInDegrees = 0;
    player.addComponent(rotation);
    
    SplinePositionComponent spline = new SplinePositionComponent();
    spline.p3 = new Point(0, 0);
    player.addComponent(spline);
    
    _world.activateEntity(id);
  }
  
  void internetPlayerUpdate(int id, var data, num latency) {
    if (!_world.containsEntity(id)) return; // TODO should have join message before?
    Entity entity = _world.getEntityById(id);
    RotationComponent rotation = entity.getComponent(RotationComponent);
    rotation.angleInDegrees = data.r["a"];
    SplinePositionComponent spline = entity.getComponent(SplinePositionComponent);
    Point newPosition = new Point(data.p["x"], data.p["y"]);
    if (spline.p3 != newPosition) {
      // TODO should be new position replaces last guess and new guess is made
      _moveSplinePoints(spline);
      spline.p3 = newPosition;
    }
    // new guesses if the distance is too far
    spline.startTime = new DateTime.now().millisecondsSinceEpoch;
  }
  
  void _moveSplinePoints(SplinePositionComponent spline) {
    spline.p0 = spline.p1;
    spline.p1 = spline.p2;
    spline.p2 = spline.p3;
  }
}