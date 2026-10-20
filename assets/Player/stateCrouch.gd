extends State

var player : Player

func enter() -> void:
	player = machine.get_parent()
	player.collisionCrouch.disabled = false
	player.collisionStand.disabled = true

func physics_update(delta) -> void:
	player.curCoyote -= 1
	var moveSpeed : float = (player.crouchSpeed if !Input.is_action_pressed("sprint") else player.crouchSprint)
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
	if !Input.is_action_pressed("crouch"):
		transitioned.emit(self, "move")

func jump() -> void:
	if player.get_jump():
		player.curCoyote = -2
		player.velocity.y = -player.jumpHeight/1.777

func exit() -> void:
	player.collisionCrouch.disabled = true
	player.collisionStand.disabled = false
