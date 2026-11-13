extends State

var player : Player
var dashTimer : float = 0.0
var transToSlam : bool = false

func enter() -> void:
	dashTimer = 0.0
	player = machine.get_parent()
	player.abilityUsed = true
	player.breakDetect.monitoring = true
	player.set_collision_mask_value(4, false)

func physics_update(delta) -> void:
	player.breakDetect.get_child(0).shape.size = Vector2(clampf(abs(player.velocity.x/6.5) - 100, player.minBreakSize.x, INF), player.minBreakSize.y)
	if player.breakDetect.has_overlapping_bodies():
		var collider = player.breakDetect.get_overlapping_bodies()[0]
		if collider is Destroyable:
			if collider.requiredStateName.to_lower() == self.name.to_lower():
				collider.destroy()
			else:
				player.set_collision_mask_value(4, true)
	
	dashTimer += delta
	
	player.velocity.y = 0.0
	player.velocity.x = (player.dashSpeed if abs(player.velocity.x) <= player.dashSpeed else abs(player.velocity.x)) * player.direction
	
	player.move_and_slide()
	check_transitions()

func check_transitions() -> void:
	if Input.is_action_just_pressed("ability"):
		transitioned.emit(self, "move")
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "dashjump")
	if Input.is_action_just_pressed("crouch"):
		if player.is_on_floor() && Input.is_action_pressed("sprint"):
			transitioned.emit(self, "slide")
		else:
			transToSlam = true
			transitioned.emit(self, "slam")
	if player.is_on_wall():
		transitioned.emit(self, "bonk")
	if dashTimer >= player.dashDuration:
		transitioned.emit(self, "move")

func exit() -> void:
	player.breakDetect.monitoring = false
	if !transToSlam:
		player.set_collision_mask_value(4, true)
	transToSlam = false
