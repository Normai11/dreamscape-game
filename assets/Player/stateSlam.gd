extends State

var player : Player
var exitSpeed : float

func enter() -> void:
	player = machine.get_parent()
	exitSpeed = abs(player.velocity.x)
	player.velocity.y = player.gravity
	player.velocity.x = 275.0 * player.direction
	player.breakDetect.monitoring = true
	player.set_collision_mask_value(4, false)

func physics_update(delta) -> void:
	player.breakDetect.get_child(0).shape.size = Vector2(player.minBreakSize.x, clampf(abs(player.velocity.y/6.5) - 100, player.minBreakSize.y, INF))
	if player.breakDetect.has_overlapping_bodies():
		var collider = player.breakDetect.get_overlapping_bodies()[0]
		if collider is Destroyable:
			if collider.requiredStateName.to_lower() == self.name.to_lower():
				collider.destroy()
			else:
				player.set_collision_mask_value(4, true)
		elif collider is GateTrigger:
			collider.trigger()
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	check_transitions()

func check_transitions() -> void:
	if player.is_on_floor():
		if Input.is_action_pressed("crouch"):
			transitioned.emit(self, "slide")
		else:
			transitioned.emit(self, "move")
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "move")

func exit() -> void:
	#player.velocity.y = -player.jumpHeight/1.5
	player.velocity.x = exitSpeed * player.direction
	player.breakDetect.monitoring = true
	player.set_collision_mask_value(4, true)
