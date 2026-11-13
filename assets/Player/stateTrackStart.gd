extends State

var player : Player
var realSpeed : float = 800.0
@export var enterSpeed : float = 1100.0

func enter() -> void:
	player = machine.get_parent()
	player.velocity.x = enterSpeed * player.direction
	player.breakRay.enabled = true
	player.set_collision_mask_value(4, false)
	player.breakRay.target_position = Vector2(player.breakRayMinReach * player.direction, 0.0)

func physics_update(delta) -> void:
	player.breakRay.target_position = Vector2(clampf(abs((player.velocity.x/4)) - 100, player.breakRayMinReach, INF) * player.direction, 0)
	if player.breakRay.is_colliding():
		var collider = player.breakRay.get_collider()
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
	player.breakRay.enabled = false
	player.set_collision_mask_value(4, true)
