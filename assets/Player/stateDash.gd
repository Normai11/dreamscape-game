extends State

var player : Player
var dashTimer : float = 0.0

func enter() -> void:
	dashTimer = 0.0
	player = machine.get_parent()
	player.abilityUsed = true

func physics_update(delta) -> void:
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
			transitioned.emit(self, "slam")
	if dashTimer >= player.dashDuration:
		transitioned.emit(self, "move")
