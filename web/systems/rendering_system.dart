part of space_client;

class RenderingSystem implements System {
  
  bool enabled;
  int priority;
    
  List<Entity> _renderables;
  
  Entity _centerEntity;
    
  RenderingSystem() {
    _renderables = new List<Entity>();
  }
  
  void process(num timeDelta) {
    if (_centerEntity == null) return;
    
    canvasManager.clearCanvas();
    
    PositionComponent centerPosition = _centerEntity.getComponent(PositionComponent);
    
    for (Entity entity in _renderables) {
      RenderComponent renderable = entity.getComponent(RenderComponent);
      PositionComponent position = entity.getComponent(PositionComponent);
      RotationComponent rotation;
      if (entity.hasComponent(RotationComponent)) {
        rotation = entity.getComponent(RotationComponent);
      } else {
        rotation = new RotationComponent();
        rotation.angleInDegrees = 0;
      }
      canvasManager.context.save();
      canvasManager.context.translate(
          (position.x - centerPosition.x) * canvasManager.drawScaler +
           canvasManager.canvasDrawArea.left + canvasManager.canvasDrawArea.width / 2,
          (position.y - centerPosition.y) * canvasManager.drawScaler +
           canvasManager.canvasDrawArea.top + canvasManager.canvasDrawArea.height / 2);
      canvasManager.context.rotate(rotation.angleInRadians);
      canvasManager.context.drawImageScaledFromSource(renderable.source,
          renderable.sourceX, renderable.sourceY,
          renderable.sourceWidth, renderable.sourceHeight,
          renderable.xOffset * renderable.imageScaler * canvasManager.drawScaler,
          renderable.yOffset * renderable.imageScaler * canvasManager.drawScaler,
          renderable.sourceWidth * canvasManager.drawScaler * renderable.imageScaler,
          renderable.sourceHeight * canvasManager.drawScaler * renderable.imageScaler
          );
      canvasManager.context.restore();
    }
  }
    
  void attachWorld(World world) {
  }
  
  void detachWorld() {
  }
  
  void entityActivation(Entity entity) {
    if (entity.hasComponent(RenderComponent) &&
        entity.hasComponent(PositionComponent)) {
      _renderables.add(entity);
    }
    if (entity.hasComponent(CameraCenteringComponent) &&
        entity.hasComponent(PositionComponent)) {
      _centerEntity = entity;
    }
  }
  
  void entityDeactivation(Entity entity) {
    _renderables.remove(entity);
    if (entity == _centerEntity) _centerEntity = null;
  }
}