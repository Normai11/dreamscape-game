extends Node
class_name StateMachine

signal changeError(output)

@export var initialState : State
@export var debugLabel : Label

var states : Dictionary = {}
var currentState : State
var previousState : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(change_state)
			child.machine = self

func _process(delta: float) -> void:
	if currentState:
		currentState.update(delta)
	if debugLabel:
		debugLabel.text = str(currentState)

func _physics_process(delta: float) -> void:
	if currentState:
		currentState.physics_update(delta)

func change_state(state, newStateNode) -> void:
	if state != currentState:
		return
	
	var newState = states.get(newStateNode.to_lower())
	if !newState:
		return
	
	if currentState:
		currentState.exit()
	newState.enter()
	
	previousState = currentState
	currentState = newState

func body_active() -> void:
	if initialState:
		initialState.enter()
		currentState = initialState
