extends Node2D

@export var beamNumber : int = 3
@export var beamLength : float = 2500.0
@export var beamThickness : float = 15.0
@export_range(0, 359.9, 1.0) var beamAngle : float = 45.0
@export_range(-1, 1, 2) var beamDirection : int = 1

var playerReference : Player
var beams : Array[ShapeCast2D] = []
var lines : Array[Line2D] = []
var curRot : float = 0.0
var tween : Tween
var visualTween : Tween

var lingerTimer : float = -1.0

func _ready() -> void:
	playerReference = get_tree().current_scene.find_child("Player")
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	
	rotation_degrees = clampf(beamAngle - 45, 0.0, 180.0) #* beamDirection
	create_beams()
	
	tween.tween_property(self, "rotation_degrees", beamAngle, 1.2)

func _process(delta: float) -> void:
	lingerTimer -= delta
	if lingerTimer >= 0.0:
		for beam in beams:
			if beam.is_colliding():
				# damage function
				print("Beam Hit!")
				#playerReference.damage_player()

func create_beams() -> void:
	var beamShape = CircleShape2D.new()
	beamShape.radius = beamThickness * 0.6
	visualTween = get_tree().create_tween()
	visualTween.set_ease(Tween.EASE_OUT)
	visualTween.set_trans(Tween.TRANS_EXPO)
	visualTween.set_parallel(true)
	
	for i in range(beamNumber):
		var beamVisual = Line2D.new()
		var beam = ShapeCast2D.new()
		var angle : float = curRot + (i * (2 * PI / beamNumber))
		var endPoint : Vector2 = Vector2(cos(angle), sin(angle)) * beamLength
		
		beam.target_position = endPoint
		beam.shape = beamShape.duplicate()
		beam.set_collision_mask_value(1, false)
		beam.set_collision_mask_value(2, true)
		
		beamVisual.add_point(Vector2.ZERO, 0)
		beamVisual.add_point(endPoint, 1)
		beamVisual.width = 0.1
		beamVisual.modulate.a = 0.75
		visualTween.tween_property(beamVisual, "width", beamThickness, 0.75)
		
		beam.visible = false
		add_child(beamVisual)
		add_child(beam)
		beams.append(beam)
		lines.append(beamVisual)

func _beam_expire() -> void:
	visualTween.kill()
	lingerTimer = 0.1
	$Center.visible = false
	
	tween.kill()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_parallel(true)
	
	for line in lines:
		line.width = beamThickness * 5.5
		line.modulate.a = 1
		tween.tween_property(line, "width", 0, 0.4)
	
	await tween.finished
	queue_free()
