extends State

var player : Player
var curSpeed : float

func enter() -> void:
	player = machine.get_parent()
	player.collisionCrouch.disabled = false
	player.collisionStand.disabled = true
	player.breakDetect.monitoring = true
	player.set_collision_mask_value(4, false)
	if abs(player.velocity.x) <= player.slideStartMin:
		curSpeed = player.slideStartMin
	else:
		curSpeed = abs(player.velocity.x)
	player.velocity.x = curSpeed * player.direction
	#print(str(curSpeed) + str(player.velocity.x))
	player.abilityUsed = false

func physics_update(delta) -> void:
	player.curCoyote -= 1
	
	player.breakDetect.get_child(0).shape.size = Vector2(clampf(abs(player.velocity.x/6.5) - 100, player.minBreakSize.x, INF), player.minBreakSize.y)
	if player.breakDetect.has_overlapping_bodies():
		var collider = player.breakDetect.get_overlapping_bodies()[0]
		if collider is Destroyable:
			if collider.requiredStateName.to_lower() == self.name.to_lower():
				collider.destroy()
			else:
				player.set_collision_mask_value(4, true)
	
	if player.is_on_wall():
		if player.doBonkPenalty:
			curSpeed = (abs(curSpeed) - player.bonkPenaltyAmt)
		player.direction = -player.direction
		#curSpeed = -curSpeed
	player.velocity.x = curSpeed * player.direction
	player.velocity.y += player.gravity * delta
	if !Input.is_action_pressed("jump") && !player.is_on_floor():
		player.velocity.y = lerp(player.velocity.y, player.gravity, 0.02)
	if Input.is_action_just_pressed("jump"):
		jump()
	
	if player.is_on_floor():
		player.curCoyote = player.coyoteFrames
		
		var slopeAngle = roundi(rad_to_deg(player.get_floor_angle()))
		if slopeAngle >= 20:
			var climbing : int = (1 if player.get_real_velocity().y < 0 else -1)
			curSpeed -= ((slopeAngle * 0.37) * climbing)# * -player.direction
			if abs(player.velocity.x) <= player.crouchSpeed:
				transitioned.emit(self, "crouch")
	
	player.move_and_slide()
	check_transitions()

func check_transitions() -> void:
	if !Input.is_action_pressed("crouch"):
		transitioned.emit(self, "move")

func jump() -> void:
	if player.get_jump():
		player.curCoyote = -2
		player.velocity.y = -player.jumpHeight/1.333
		curSpeed += player.bHopAdditive/2 #* player.direction

func exit() -> void:
	player.collisionCrouch.disabled = true
	player.collisionStand.disabled = false
	player.set_collision_mask_value(4, true)
	player.breakDetect.monitoring = true
