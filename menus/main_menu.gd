extends Control

@onready var background : TextureRect = $bg
@onready var middleground : TextureRect = $mg
@onready var foreground : Control = $fg

func _process(_delta: float) -> void:
	if get_local_mouse_position().y <= self.size.y*2/3:
		foreground.modulate.a = lerp(foreground.modulate.a, 0.3, 0.05)
		$fg/parallaxComponent.offset.y = lerp($fg/parallaxComponent.offset.y, 450.0, 0.05)
	else:
		foreground.modulate.a = lerp(foreground.modulate.a, 1.0, 0.2)
		$fg/parallaxComponent.offset.y = lerp($fg/parallaxComponent.offset.y, 0.0, 0.0777)
