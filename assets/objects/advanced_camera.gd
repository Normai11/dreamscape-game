extends Camera2D

@export var cameraTarget : CharacterBody2D
@export var cameraZoom : Vector2 = Vector2(0.8, 0.8)
@export var followForesight : Vector2 = Vector2(4.0, 7.0)
@export var followWeight : Vector2 = Vector2(0.15, 0.12)

func _ready() -> void:
	if cameraTarget:
		global_position = cameraTarget.global_position
		zoom = cameraZoom

func _physics_process(delta: float) -> void:
	if cameraTarget:
		var targetPos : Vector2 = cameraTarget.global_position + (cameraTarget.velocity / followForesight)*zoom
		global_position.x = lerp(global_position.x, targetPos.x, followWeight.x)
		global_position.y = lerp(global_position.y, targetPos.y, followWeight.y)
		zoom = lerp(zoom, cameraZoom, followWeight)
