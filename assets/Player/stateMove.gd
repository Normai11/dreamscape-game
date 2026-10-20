extends State

var player : Player

func enter() -> void:
	player = machine.get_parent()

func physics_update(delta) -> void:
	player.curCoyote -= 1
	var moveSpeed : float = (player.baseSpeed if !Input.is_action_pressed("sprint") else player.baseSprint)
	var velocityWeight : float = delta * (player.acceleration if player.get_input() else player.deceleration) * (player.airMultiplier if !player.is_on_floor() else 1.0)
	
	player.velocity.y += player.gravity * delta
	if Input.is_action_just_pressed("jump"):
		jump()
	if !Input.is_action_pressed("jump") && !player.is_on_floor():
		player.velocity.y = lerp(player.velocity.y, player.gravity, 0.02)
		if Input.is_action_pressed("sprint") && player.get_input():
			moveSpeed += player.bHopAdditive
	if player.is_on_floor():
		player.curCoyote = player.coyoteFrames
		player.abilityUsed = false
	
	if player.get_input() != 0:
		player.direction = (1 if player.get_input() > 0 else -1)
	player.velocity.x = lerp(player.velocity.x, player.get_input() * moveSpeed, velocityWeight)
	
	player.move_and_slide()
	check_transitions()

func check_transitions() -> void:
	if !player.get_input():
		transitioned.emit(self, "idle")
	if Input.is_action_pressed("crouch"):
		if Input.is_action_pressed("sprint") && player.is_on_floor():
			transitioned.emit(self, "slide")
		else:
			transitioned.emit(self, "crouch")
	if Input.is_action_just_pressed("ability") && player.get_can_ability():
		transitioned.emit(self, "dash")

func jump() -> void:
	if player.get_jump():
		player.curCoyote = -2
		player.velocity.y = -player.jumpHeight
