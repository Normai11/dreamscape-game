class_name Player
extends CharacterBody2D

@onready var stateMachine : StateMachine = $StateMachine
@onready var collisionStand : CollisionShape2D = $Stand
@onready var collisionCrouch : CollisionShape2D = $Crouch

@export var gravity : float = 1785.0
@export var maxHits : int = 3
@export var health : int = 1
@export var coyoteFrames : int = 4
@export_group("Movement")
@export var acceleration : float = 10.0
@export var deceleration : float = 10.0
@export var airMultiplier : float = 0.177
@export var baseSpeed : float = 462.5
@export var baseSprint : float = 800.0
@export var bHopAdditive : float = 88.0
@export var jumpHeight : float = 720.0
@export_group("State Exports")
@export var crouchSpeed : float = 325.0
@export var crouchSprint : float = 462.5
@export var slideStartMin : float = 900.5
## Constant speed when in Dash state.
@export var dashSpeed : float = 830.0
@export var dashDuration : float = 0.42

var direction : int = 1
var curCoyote : int = 0
var abilityUsed : bool = false

func _ready() -> void:
	stateMachine.body_active()

func _process(_delta: float) -> void:
	$debugSpeed.text = str(velocity)

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
