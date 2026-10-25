class_name Destroyable
extends PhysicsBody2D

@onready var destroyParticle = preload("res://assets/particles/GPU/destroy_test.tscn")

func destroy() -> void:
	var particle = destroyParticle.instantiate()
	particle.global_position = self.global_position
	particle.emitting = true
	particle.finished.connect(particle.queue_free)
	get_tree().current_scene.add_child(particle)
	
	#set_collision_layer_value(0, false)
	queue_free()
