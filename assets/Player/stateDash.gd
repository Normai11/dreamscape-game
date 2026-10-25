extends State

var player : Player
var dashTimer : float = 0.0
var transToSlam : bool = false

func enter() -> void:
	dashTimer = 0.0
	player = machine.get_parent()
	player.abilityUsed = true
	player.breakRay.enabled = true
	player.set_collision_mask_value(4, false)
	player.breakRay.target_position = Vector2(player.breakRayMinReach * player.direction, 0.0)

func physics_update(delta) -> void:
	player.breakRay.target_position = Vector2(clampf(abs((player.velocity.x/4)) - 100, player.breakRayMinReach, INF) * player.direction, 0)
	if player.breakRay.is_colliding():
		var collider = player.breakRay.get_collider()
		if collider is Destroyable:
			collider.destroy()
	
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
	player.breakRay.enabled = false
	if !transToSlam:
		player.set_collision_mask_value(4, true)
	transToSlam = false
