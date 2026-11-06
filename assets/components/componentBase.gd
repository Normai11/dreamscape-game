class_name Component
extends Node

@export var oneshot : bool = true

func _ready() -> void:
	if oneshot:
		oneshot_action()
		queue_free()

func oneshot_action() -> void:
	pass
