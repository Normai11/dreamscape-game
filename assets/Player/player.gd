class_name Player
extends CharacterBody2D

@onready var stateMachine : StateMachine = $StateMachine
@onready var collisionStand : CollisionShape2D = $Stand
@onready var collisionCrouch : CollisionShape2D = $Crouch
@onready var breakRay : RayCast2D = $breakRay
@onready var interactRay : RayCast2D = $interactRay

@export var gravity : float = 1785.0
@export var maxHits : int = 3
@export var health : int = 1
@export var coyoteFrames : int = 4
@export_group("Movement")
@export var acceleration : float = 10.0
@export var deceleration : float = 10.0
@export var airMultiplier : float = 0.122
@export var baseSpeed : float = 462.5
@export var baseSprint : float = 800.0
@export var bHopAdditive : float = 42.0
@export var jumpHeight : float = 720.0
@export_group("State Exports")
@export var movingStates : Array[State]
@export var interactionStates : Array[State]
@export var noclipSpeed : float = 600
@export var crouchSpeed : float = 325.0
@export var crouchSprint : float = 462.5
@export var bonkVelocity : float = 500
@export var slideStartMin : float = 900.5
@export var doBonkPenalty : bool = false
@export var bonkPenaltyAmt : float = 35.0
## Constant speed when in Dash state.
@export var dashSpeed : float = 877.0
@export var dashDuration : float = 0.42
@export var crouchTrackStartDur : float = 0.85

const breakRayMinReach : float = 64.0
const interactRayLength : float = 80.0

var direction : int = 1
var curCoyote : int = 0
var abilityUsed : bool = false

func _ready() -> void:
	stateMachine.body_active()
	set_debugTexture_visible("no")
	add_commands()

func add_commands() -> void:
	Console.pause_enabled = true
	Console.add_command("set_state", change_state, ["stateName"], 1, "Set player state")
	Console.add_command_autocomplete_list("set_state", stateMachine.states.keys())
	Console.add_command("set_stat", set_attribute, ["statName", "value", "type"], 3, "Set specific player attribute value")
	Console.add_command_autocomplete_list("set_stat", get_property_names())
	Console.add_command("set_debugPlayer", set_debugTexture_visible, ["boolean"], 1, "Sets visibility of player testing texture.")

func _physics_process(_delta: float) -> void:
	debug_junk()
	
	interactRay.target_position.x = interactRayLength * direction
	
	if get_can_interact():
		var collider = interactRay.get_collider()
		if collider:
			if collider is Interactable:
				if Input.is_action_just_pressed("interact"):
					collider._interacted()

func debug_junk() -> void:
	$debugSpeed.text = str(velocity) + "\ntrackstart : " + str($StateMachine/Crouch.trackStartTime > crouchTrackStartDur)
	$debugRays.text = "[color=blue]breakRay : %s\n[color=cyan]interactRay : %s" % [breakRay.enabled, get_can_interact() && interactRay.is_colliding()]
	$TextureRect.flip_h = (true if direction == -1 else false)

func is_moving() -> bool:
	if movingStates.has(stateMachine.currentState):
		return true
	else:
		return false

func get_can_interact() -> bool:
	if interactionStates.has(stateMachine.currentState):
		return true
	else:
		return false

func get_jump() -> bool:
	if is_on_floor() or curCoyote >= 0:
		return true
	else:
		return false

func get_input() -> float:
	return Input.get_axis("moveLeft", "moveRight")

func get_can_ability() -> bool:
	if abilityUsed:
		return false
	else:
		return true

func change_state(stateName : String) -> void:
	if !stateMachine.states.get(stateName.to_lower()):
		Console.print_error("Failed to set state; State does not exist in Player")
		return
	stateMachine.change_state(stateMachine.currentState, stateName)
	Console.print_line("Set state to %s" % stateName)

func get_property_names() -> Array[String]:
	return get_property_list().map(func(prop):return prop.name)

func set_attribute(statName : String, value : String, type : String) -> void:
	var nameList = get_property_names()
	if !nameList.has(statName):
		Console.print_error("Failed to set attribute; Property does not exist in Player")
		return
	
	match type:
		"int":
			set(statName, int(value))
		"float":
			set(statName, float(value))
		"bool", "boolean":
			if value.to_lower() == "true":
				set(statName, true)
			else:
				set(statName, false)

func set_debugTexture_visible(on : String) -> void:
	if on.to_lower() == "true":
		$TextureRect.visible = true
	else:
		$TextureRect.visible = false

func _entered_saferoom(area: Area2D) -> void:
	GameManager.saferoom_trigger(true)

func _exited_saferoom(area: Area2D) -> void:
	GameManager.saferoom_trigger(false)
