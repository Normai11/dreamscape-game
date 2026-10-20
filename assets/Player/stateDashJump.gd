extends State

var player : Player

func enter() -> void:
	player = machine.get_parent()
	player.velocity.y = -player.jumpHeight/1.25

func physics_update(delta) -> void:
	player.velocity.y += player.gravity * delta
	if !Input.is_action_pressed("jump") && !player.is_on_floor():
		player.velocity.y = lerp(player.velocity.y, player.gravity, 0.02)
	
	player.move_and_slide()
	check_transitions()

func check_transitions() -> void:
	if player.is_on_floor():
		transitioned.emit(self, "move")
	if Input.is_action_just_pressed("crouch"):
		transitioned.emit(self, "slam")
