extends State

var player : Player
var realSpeed : float = 800.0
@export var enterSpeed : float = 1100.0

func enter() -> void:
	player = machine.get_parent()
	player.velocity.x = enterSpeed * player.direction
	player.breakDetect.monitoring = true
	player.set_collision_mask_value(4, false)

func physics_update(delta) -> void:
	player.breakDetect.get_child(0).shape.size = Vector2(clampf(abs(player.velocity.x/6.5) - 100, player.minBreakSize.x, INF), player.minBreakSize.y)
	if player.breakDetect.has_overlapping_bodies():
		var collider = player.breakDetect.get_overlapping_bodies()[0]
		if collider is Destroyable:
			if collider.requiredStateName.to_lower() == "dash":
				collider.destroy()
			else:
				player.set_collision_mask_value(4, true)
	
	player.velocity.y += player.gravity * delta
	player.velocity.x = lerp(player.velocity.x, realSpeed * player.direction, 0.02)
	
	player.move_and_slide()
	check_transition()

func check_transition() -> void:
	if abs(player.velocity.x) <= enterSpeed - 175:
		transitioned.emit(self, "move")
	if Input.is_action_just_pressed("crouch"):
		transitioned.emit(self, "slide")
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "dashjump")
	if Input.is_action_just_pressed("ability"):
		transitioned.emit(self, "dash")

func exit() -> void:
	player.breakDetect.monitoring = false
	player.set_collision_mask_value(4, true)
