class_name Room
extends Node2D

#@export var roomConfiguration : RoomConfiguration
@export var generationDetectArea : Area2D
@export var deleteObjects : bool = true
@export var editorObjects : Array[Node]
@export var linkObj : Marker2D

func _ready() -> void:
	if deleteObjects:
		for obj in editorObjects:
			obj.queue_free()
	#if roomConfiguration.flipGeneration:
		#scale.x = -1

func free_generation_object() -> void:
	if generationDetectArea:
		generationDetectArea.queue_free()
