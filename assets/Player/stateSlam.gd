extends State

var player : Player

func enter() -> void:
	player = machine.get_parent()
	player.velocity.y = player.gravity
	player.velocity.x = 275.0 * player.direction

func physics_update(delta) -> void:
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
	player.velocity.y = -player.jumpHeight/1.5
