extends Node2D

@onready var beam : PackedScene = preload("res://assets/objects/disco_beam.tscn")

@export var screenRange : Vector2 = Vector2(150, 1000)
@export var appearInterval : float = 20.37
@export var dropDuration : float = 0.667
@export var fireCount : int = 3
@export var fireCooldown : float = 0.55
@export var beamNumber : int = 4
@export var beamLength : float = 2500.0
@export var shiftDir : int = 1

var curState : int = 0
var beamsFired : int = 0
var stateTimer : float = 0.0
var targetPos : float = 0.0

func _mod_reset() -> void:
	stateTimer = appearInterval
	targetPos = screenRange.y
	beamsFired = 0
	curState = 0

func _ready() -> void:
	_mod_reset()
	add_commands()

func _process(delta: float) -> void:
	stateTimer -= delta
	position.x = lerp(position.x, targetPos, 0.05)
	
	match curState:
		0:
			modulate.a = 0.33
			if stateTimer <= 0:
				stateTimer = dropDuration
				curState = 1
		1:
			#do dropping sequence or whatever
			modulate.a = 1
			if stateTimer <= 0:
				curState = 2
		2: # CHECK state
			if stateTimer <= 0:
				if beamsFired < fireCount:
					stateTimer = fireCooldown/2
					shift_position()
					curState = 3
				else:
					stateTimer = appearInterval
					beamsFired = 0
					curState = 0
		3: # SHIFT state
			if stateTimer <= 0:
				stateTimer = fireCooldown/2
				summon_beam()
				beamsFired += 1
				curState = 4
		4: # FIRE state
			if stateTimer <= 0:
				curState = 2

func add_commands() -> void:
	Console.add_command("set_disco_beamNumber", set_disco_beamNumber, ["int"], 1, "Sets the number of beams that shoot out per shot fired")
	Console.add_command("set_disco_time", set_disco_timer, ["float"], 1, "Sets current state's timer")

func shift_position(customX : float = -1000.0) -> void:
	var randPos : float = randf_range(screenRange.x, screenRange.y)
	if customX != -1000.0:
		shiftDir = (sign(targetPos - customX) if sign(targetPos - customX) != 0.0 else 1)
		targetPos = customX
	else:
		shiftDir = (sign(targetPos - randPos) if sign(targetPos - randPos) != 0.0 else 1)
		targetPos = randPos
	
	$AnimationPlayer.play("spin")
	$body.flip_h = (true if shiftDir == -1 else false)

func summon_beam() -> void:
	var spawn = beam.instantiate()
	
	spawn.beamNumber = beamNumber
	spawn.beamLength = beamLength
	spawn.beamDirection = (true if randi_range(0, 1) == 1 else false)
	spawn.beamAngle = randf_range(0.0, 350.0)
	spawn.global_position = get_2D_position()
	
	get_tree().current_scene.add_child(spawn)

func get_2D_position() -> Vector2:
	var screenPos: Vector2 = self.get_global_transform_with_canvas().origin
	
	var worldTransform: Transform2D = get_tree().current_scene.get_viewport().get_canvas_transform().affine_inverse()
	var worldPos: Vector2 = worldTransform * screenPos# + Vector2(120, 130)
	return worldPos

func set_disco_beamNumber(num : String) -> void:
	beamNumber = int(num)
	Console.print_info("Set Disco beam amount to %d" % beamNumber)

func set_disco_timer(time : String) -> void:
	stateTimer = float(time)
	Console.print_info("Set Disco stateTimer (state=%s) to %s." % [curState, time])
