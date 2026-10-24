extends State

var player : Player
var bonkDirection : int

func enter() -> void:
	player = machine.get_parent()
	bonkDirection = -player.direction
	player.velocity.y = -600

func physics_update(delta) -> void:
	if player.get_input() != 0:
		player.direction = (1 if player.get_input() > 0 else -1)
	
	player.velocity.x = player.bonkVelocity * bonkDirection
	player.velocity.y += player.gravity * delta
	if !Input.is_action_pressed("jump") && !player.is_on_floor():
		player.velocity.y = lerp(player.velocity.y, player.gravity, 0.02)
	
	player.move_and_slide()
	check_transitions()

func check_transitions() -> void:
	if Input.is_action_just_pressed("crouch"):
		transitioned.emit(self, "slam")
	if player.is_on_floor():
		transitioned.emit(self, "move")
