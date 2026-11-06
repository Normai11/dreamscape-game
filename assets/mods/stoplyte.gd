extends Node2D

@onready var head : TextureRect = $Head
@onready var headChain : RigidBody2D = $chain2
@onready var light : ColorRect = $Head/light
@onready var anims : AnimationPlayer = $AnimationPlayer

@export var playerReference : Player
@export_group("Timers")
@export var appearInterval : float = 17.95
@export var warnDuration : float = 1
@export var attackLeeway : float = 0.3
@export_group("Phase Colors")
@export var phaseOff : Color
@export var phaseWake : Color
@export var phaseWarn : Color
@export var phaseAttack : Color

var targetPos : Vector2 = Vector2.ZERO
var phaseTimer : float = 0.0
var lightPhase : int = 0

func _ready() -> void:
	phaseTimer = appearInterval
	add_commands()

func add_commands() -> void:
	Console.add_command("set_stoplyte_timer", set_time, ["value"], 1, "Sets current phase timer")

func _process(delta: float) -> void:
	phaseTimer -= delta
	#$lock.position = lerp($lock.position, targetPos, 0.1)
	#head.position = headChain.position - Vector2(head.size.x/2, 0)
	#head.rotation_degrees = headChain.rotation_degrees
	
	match lightPhase:
		0:
			if phaseTimer <= 0.33 && !anims.is_playing():
				anims.play("drop")
			if phaseTimer <= 0:
				phaseTimer = warnDuration
				lightPhase = 1
		1:
			if phaseTimer <= 0:
				phaseTimer = attackLeeway
				lightPhase = 2
				set_color(3)
			else:
				if phaseTimer <= warnDuration/3:
					set_color(2)
				elif phaseTimer <= warnDuration*2/3:
					set_color(1)
				elif phaseTimer <= warnDuration:
					set_color(0)
		2:
			#light.color.v = (phaseTimer/attackLeeway)
			if phaseTimer <= 0 or !playerReference.is_moving():
				#light.color.v = 0.14486655592918
				if playerReference.is_moving():
					print("stoplyte Hit! Hit state: " + str(playerReference.stateMachine.currentState))
				phaseTimer = appearInterval
				lightPhase = 0
				anims.play("rise")

func set_color(index : int) -> void:
	if index <= 3:
		light.color = [phaseOff, phaseWake, phaseWarn, phaseAttack][index]

func set_time(time : String) -> void:
	phaseTimer = float(time)
	Console.print_info("Time set to %d/%d" % [float(time), appearInterval])
