class_name Interactable
extends Node2D

@export var interactPrompt : String = ""
@export var oneshot : bool = false

var disabled : bool = false

func _interacted() -> void:
	print("Object with prompt %s has been interacted!" % [interactPrompt])
	if oneshot:
		disable_object()

func disable_object() -> void:
	disabled = true

func get_prompt() -> String:
	return interactPrompt
