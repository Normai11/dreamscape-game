class_name Destroyable
extends PhysicsBody2D
signal _destroyed

@onready var destroyParticle = preload("res://assets/particles/GPU/destroy_test.tscn")

@export var requiredStateName : String = "dash"

var canBreak : bool = true

func destroy() -> void:
	if !canBreak:
		return
	var particle = destroyParticle.instantiate()
	particle.global_position = self.global_position
	particle.emitting = true
	particle.finished.connect(particle.queue_free)
	get_tree().current_scene.add_child(particle)
	_destroyed.emit()
	
	#set_collision_layer_value(0, false)
	queue_free()
