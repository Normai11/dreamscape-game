class_name GateTrigger
extends Node2D
signal triggerActivated

@export var activated : bool = false
var gateParent : PhysicsBody2D

func trigger() -> void:
	activated = true
	triggerActivated.emit()
