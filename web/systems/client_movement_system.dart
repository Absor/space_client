part of space_client;

class ClientMovementSystem implements System {
  
  bool enabled;
  int priority;
  
  List<Entity> _movingEntities;
    
  ClientMovementSystem() {
    _movingEntities = new List<Entity>();
  }
  
  void process(num timeDelta) {
    for (Entity entity in _movingEntities) {
      AccelerationComponent acceleration = entity.getComponent(AccelerationComponent);
      VelocityComponent velocity = entity.getComponent(VelocityComponent);
      PositionComponent position = entity.getComponent(PositionComponent);
      num maxVelocity = 250;
      velocity.x += acceleration.x * timeDelta / 1000;
      velocity.y += acceleration.y * timeDelta / 1000;
      num newVelocity = sqrt(velocity.x*velocity.x + velocity.y*velocity.y);
      if (newVelocity > maxVelocity) {
        num scaler = maxVelocity / newVelocity;
        velocity.x = velocity.x * scaler;
        velocity.y = velocity.y * scaler;
      }
      position.x += velocity.x * timeDelta / 1000;
      position.y += velocity.y * timeDelta / 1000;
    }
  }
    
  void attachWorld(World world) {
  }
  
  void detachWorld() {
  }
  
  void entityActivation(Entity entity) {
    if (entity.hasComponent(PositionComponent) &&
        entity.hasComponent(VelocityComponent) &&
        entity.hasComponent(AccelerationComponent)) {
      _movingEntities.add(entity);
    }
  }
  
  void entityDeactivation(Entity entity) {
    _movingEntities.remove(entity);
  }
}