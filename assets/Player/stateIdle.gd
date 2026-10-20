extends State

var player : Player

func enter() -> void:
	player = machine.get_parent()

func physics_update(delta) -> void:
	player.curCoyote -= 1
	if player.is_on_floor():
		player.curCoyote = player.coyoteFrames
		player.abilityUsed = false
	
	player.velocity.y += player.gravity * delta
	player.velocity.x = lerp(player.velocity.x, 0.0, player.deceleration * (player.airMultiplier if !player.is_on_floor() else 1.0) * delta)
	if Input.is_action_just_pressed("jump"):
		jump()
	if !Input.is_action_pressed("jump") && !player.is_on_floor():
		player.velocity.y = lerp(player.velocity.y, player.gravity, 0.02)
	
	player.move_and_slide()
	check_transitions()

func check_transitions() -> void:
	if player.get_input():
		transitioned.emit(self, "move")
	if Input.is_action_pressed("crouch"):
		transitioned.emit(self, "crouch")
	if Input.is_action_just_pressed("ability") && player.get_can_ability():
		transitioned.emit(self, "dash")

func jump() -> void:
	if player.get_jump():
		player.velocity.y = -player.jumpHeight
