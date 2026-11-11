class_name ModifierEnemy
extends Node

@export_enum("Scene Parent", "Canvas Node", "SubViewport") var path = 0
@export var dataName : String
@export var maxStack : int = 1
@export var paused : bool = false

var curStack : int = 1
var playerReference : Player

func _mod_reset() -> void:
	print("%s reset" % dataName)

func _saferoom(entered : bool) -> void:
	if entered:
		paused = true
	else:
		_mod_reset()
		paused = false
