extends GateTrigger

func _ready() -> void:
	if activated:
		$texture.texture.region = Rect2(160, 0, 160, 160)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		activated = true
		triggerActivated.emit()
		$texture.texture.region = Rect2(160, 0, 160, 160)
