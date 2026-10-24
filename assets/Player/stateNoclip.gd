extends State

var player : Player

func enter() -> void:
	player = machine.get_parent()
	player.collisionCrouch.disabled = true
	player.collisionStand.disabled = true

func physics_update(delta) -> void:
	player.velocity.x = player.get_input() * player.noclipSpeed
	player.velocity.y = Input.get_axis("jump", "crouch") * player.noclipSpeed
	
	player.move_and_slide()
	check_transitions()

func check_transitions() -> void:
	if Input.is_action_just_pressed("ability"):
		transitioned.emit(self, "idle")

func exit() -> void:
	#player.collisionCrouch.disabled = false
	player.collisionStand.disabled = false
