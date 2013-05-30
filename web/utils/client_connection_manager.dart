part of space_client;

class ClientConnectionManager {
  
  World _world;
  WebSocket _ws;
  
  Component _playerInput;
  
  LatencyCounter _lc;
  
  num _lastPing;
    
  ClientConnectionManager(this._world) {
    _init();
    _lc = new LatencyCounter();
  }
  
  _init() {
    print("client connecting to server");
    _ws = new WebSocket("ws://127.0.0.1:8080");
    _ws.onError.listen((e) => print("error"));
    _ws.onClose.listen((e) => print("client closed"));
    _ws.onOpen.listen((e) {
      _requestId();
      new Timer.periodic(new Duration(milliseconds:500), (t) {
        _ping();
      });
    });
    _ws.onMessage.listen((event) => _onMessage(event.data));
  }
  
  void _ping() {
    _lastPing = new DateTime.now().millisecondsSinceEpoch;
    _ws.send(stringify({"ping":_lc.checkoutPingId()}));
  }
  
  void _requestId() {
    _ws.send(stringify("requestId"));
  }
  
  void _onMessage(var data) {
    var jsonData;
    try {
      jsonData = parse(data);
    } catch (error) {
      print("Error parsing JSON." + " " + error);
    }
    if (!(jsonData is Map)) return;
    if (jsonData["ping"] != null) {
      _lc.checkInPingId(jsonData["ping"]);
    } else if (jsonData["newId"] != null) {
      _createPlayer(jsonData["newId"], true);
      new Timer.periodic(new Duration(milliseconds:100), (t) => _sendInput());
    } else {
      for (String idS in jsonData.keys) {
        int id = int.parse(idS);
        if (!_world.containsEntity(id)) _createPlayer(id, false);
        _updatePlayer(id, jsonData[idS]);
      }
    }
  }
  
  void _sendInput() {
    new Timer(new Duration(milliseconds:300), () {
      _ws.send(stringify(_playerInput));
    });
  }
  
  void _createPlayer(int id, bool localPlayer) {
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
    rc.imageScaler = 0.3;
    player.addComponent(rc);
    
    RotationComponent rotation = new RotationComponent();
    rotation.angle = 0;
    player.addComponent(rotation);
    
    AccelerationComponent acceleration = new AccelerationComponent();
    acceleration.x = 0;
    acceleration.y = 0;
    player.addComponent(acceleration);
    
    VelocityComponent velocity = new VelocityComponent();
    velocity.x = 0;
    velocity.y = 0;
    player.addComponent(velocity);
    
    if (localPlayer) {
      player.addComponent(new CameraCenteringComponent());
      InputComponent input = new InputComponent();
      input.thrust = 0;
      input.turn = 0;
      player.addComponent(input);
      _playerInput = input;
    }
    
    _world.activateEntity(id);
  }
  
  void _updatePlayer(int id, var data) {
    Entity entity = _world.getEntityById(id);
    PositionComponent position = entity.getComponent(PositionComponent);
    position.x = data["position"]["x"];
    position.y = data["position"]["y"];
    RotationComponent rotation = entity.getComponent(RotationComponent);
    rotation.angle = data["rotation"]["angle"];
    AccelerationComponent acceleration = entity.getComponent(AccelerationComponent);
    acceleration.x = data["acceleration"]["x"];
    acceleration.y = data["acceleration"]["y"];
    VelocityComponent velocity = entity.getComponent(VelocityComponent);
    velocity.x = data["velocity"]["x"];
    velocity.y = data["velocity"]["y"];
    
    position.x += data["velocity"]["x"] * _lc.latency / 1000;
    position.y += data["velocity"]["y"] * _lc.latency / 1000;
  }
}