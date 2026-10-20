extends Node
class_name State
signal transitioned(current, target)

var machine : StateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(delta) -> void:
	pass

func physics_update(delta) -> void:
	pass
