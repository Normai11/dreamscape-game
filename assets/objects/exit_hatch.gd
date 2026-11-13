extends Interactable

@onready var solid : CollisionShape2D = $solid/CollisionShape2D

func _interacted() -> void:
	if disabled:
		return
	super()
	solid.set_deferred("disabled", true)
	GameManager.saferoom_trigger(true)

func _hatch_destroy() -> void:
	GameManager.saferoom_trigger(true)
