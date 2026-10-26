extends StaticBody2D

@export var triggers : Array[GateTrigger]
@export var open : bool = false

func _ready() -> void:
	for obj in triggers:
		obj.gateParent = self
		obj.triggerActivated.connect(check_triggers)

func check_triggers() -> void:
	var canOpen : bool = true
	for obj in triggers:
		if !obj.activated:
			canOpen = false
	if canOpen:
		open = true
		$collision.set_deferred("disabled", true)
