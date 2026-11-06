extends Node2D

@onready var beam : PackedScene = preload("res://assets/objects/disco_beam.tscn")

@export var appearInterval : float = 20.37
@export var beamNumber : int = 3
@export var beamLength : float = 2500.0

func _ready() -> void:
	add_commands()

func add_commands() -> void:
	Console.add_command("set_disco_beamNumber", set_disco_beamNumber, ["int"], 1, "Sets the number of beams that shoot out per shot fired")

func summon_beam() -> void:
	var spawn = beam.instantiate()
	
	spawn.beamNumber = beamNumber
	spawn.beamLength = beamLength
	spawn.beamDirection = (true if randi_range(0, 1) == 1 else false)
	spawn.beamAngle = randf_range(0.0, 350.0)
	spawn.global_position = get_2D_position()
	
	get_tree().current_scene.add_child(spawn)

func get_2D_position() -> Vector2:
	var screenPos: Vector2 = self.get_global_transform_with_canvas().origin
	
	var worldTransform: Transform2D = get_tree().current_scene.get_viewport().get_canvas_transform().affine_inverse()
	var worldPos: Vector2 = worldTransform * screenPos# + Vector2(120, 130)
	return worldPos

func set_disco_beamNumber(num : String) -> void:
	beamNumber = int(num)
	Console.print_info("Set Disco beam amount to %d" % beamNumber)
