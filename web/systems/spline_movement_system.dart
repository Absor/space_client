part of space_client;

class SplineMovementSystem implements System {
  
  bool enabled;
  int priority;
  
  List<Entity> _movingEntities;
    
  SplineMovementSystem() {
    _movingEntities = new List<Entity>();
  }
  
  void process(num timeDelta) {
    for (Entity entity in _movingEntities) {
      SplinePositionComponent spline = entity.getComponent(SplinePositionComponent);
      PositionComponent position = entity.getComponent(PositionComponent);
      if (spline.p0 == null) {
        position.x = spline.p3.x;
        position.y = spline.p3.y;
        continue;
      }
      num time = (new DateTime.now().millisecondsSinceEpoch - spline.startTime) / 100;
      position.x = _catmullRomX(spline.p0, spline.p1,spline.p2, spline.p3, time);
      position.y = _catmullRomY(spline.p0, spline.p1,spline.p2, spline.p3, time);
    }
  }
  
  num _catmullRomX(p0, p1, p2, p3, num t) {
    return 0.5*((2*p1.x)+(p2.x-p0.x)*t+(2*p0.x-5*p1.x+4*p2.x-p3.x)*t*t+(3*p1.x-p0.x-3*p2.x+p3.x)*t*t*t);
  }
  
  num _catmullRomY(p0, p1, p2, p3, num t) {
    return 0.5*((2*p1.y)+(p2.y-p0.y)*t+(2*p0.y-5*p1.y+4*p2.y-p3.y)*t*t+(3*p1.y-p0.y-3*p2.y+p3.y)*t*t*t);
  }
    
  void attachWorld(World world) {
  }
  
  void detachWorld() {
  }
  
  void entityActivation(Entity entity) {
    if (entity.hasComponent(PositionComponent) &&
        entity.hasComponent(SplinePositionComponent)) {
      _movingEntities.add(entity);
    }
  }
  
  void entityDeactivation(Entity entity) {
    _movingEntities.remove(entity);
  }
}