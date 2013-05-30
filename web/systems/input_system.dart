part of space_client;

class InputSystem implements System {
  
  bool enabled;
  int priority;
    
  Map<String, bool> _keys;
  Map<int, String> _mappings;
  
  List<Entity> _inputEntities;
  
  InputSystem() {
    _setupMappings();
    _keys = new HashMap<String, bool>();
    window.onKeyDown.listen(_keydown);
    window.onKeyUp.listen(_keyup);
    
    canvasManager.canvas.onMouseMove.listen(_mouseMove);
    canvasManager.canvas.onMouseDown.listen(_mouseDown);
    canvasManager.canvas.onMouseUp.listen(_mouseUp);
    // mouse 2 menu
    canvasManager.canvas.onContextMenu.listen((e) => e.preventDefault());
    
    _inputEntities = new List<Entity>();
  }
  
  void _setupMappings() {
    _mappings = new HashMap<int, String>();
    _mappings[65] = "left";
    _mappings[87] = "up";
    _mappings[68] = "right";
    _mappings[83] = "down";
    
    _mappings[37] = "left";
    _mappings[38] = "up";
    _mappings[39] = "right";
    _mappings[40] = "down";
  }
  
  void _keydown(KeyboardEvent event) {
    String key = _translateKeyCode(event.keyCode);
    if (key != null) _keys[key] = true;
  }
  
  void _keyup(KeyboardEvent event) {
    String key = _translateKeyCode(event.keyCode);
    if (key != null) _keys[key] = false;
  }
  
  void _mouseDown(MouseEvent event) {
  }
  
  void _mouseUp(MouseEvent event) {
  }
  
  void _mouseMove(MouseEvent event) {
  }
  
  String _translateKeyCode(int keyCode) => _mappings[keyCode];
    
  void process(num timeDelta) {
    int turn = 0;
    int thrust = 0;
    if (_keys["left"] != null && _keys["left"]) turn--;
    if (_keys["right"] != null && _keys["right"]) turn++;
    if (_keys["down"] != null && _keys["down"]) thrust++;
    if (_keys["up"] != null && _keys["up"]) thrust--;
    
    for (Entity entity in _inputEntities) {
      InputComponent input = entity.getComponent(InputComponent);
      input.turn = turn;
      input.thrust = thrust;
    }
  }
  
  void attachWorld(World world) {
  }
  
  void detachWorld() {
  }
  
  void entityActivation(Entity entity) {
    if (entity.hasComponent(InputComponent) &&
        entity.hasComponent(CameraCenteringComponent)) {
      _inputEntities.add(entity);
    }
  }
  
  void entityDeactivation(Entity entity) {
    _inputEntities.remove(entity);
  }
}