extends State

var player : Player
var exitSpeed : float

func enter() -> void:
	player = machine.get_parent()
	exitSpeed = abs(player.velocity.x)
	player.velocity.y = player.gravity
	player.velocity.x = 275.0 * player.direction
	player.breakRay.enabled = true

func physics_update(delta) -> void:
	player.velocity.y += player.gravity * delta
	player.breakRay.target_position = Vector2(0, clampf(abs((player.velocity.y/6.5)) - 100, player.breakRayMinReach, INF))
	
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
	player.velocity.y = -player.jumpHeight/1.5
	player.velocity.x = exitSpeed * player.direction
	player.breakRay.enabled = false
