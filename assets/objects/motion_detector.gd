extends GateTrigger

func _ready() -> void:
	if activated:
		$texture.texture.region = Rect2(160, 0, 160, 160)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		trigger()
		$texture.texture.region = Rect2(160, 0, 160, 160)
