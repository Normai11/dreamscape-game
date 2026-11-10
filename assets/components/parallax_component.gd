extends Component

@export var parallaxMultiplier : float = 0.05
@export var offset : Vector2 = Vector2.ZERO
var parent : Control
var origin : Vector2
var centerPoint : Vector2

func _ready() -> void:
	parent = get_parent()
	origin = parent.position

func _process(_delta: float) -> void:
	if !parent.is_node_ready():
		return
	centerPoint = parent.get_viewport_rect().size / 2
	var mousePos : Vector2 = parent.get_local_mouse_position()
	var target = ((mousePos - centerPoint) * -1)#.clamp(Vector2(-400, -400), Vector2(400, 400))
	
	parent.position = lerp(origin, target + offset, parallaxMultiplier)
