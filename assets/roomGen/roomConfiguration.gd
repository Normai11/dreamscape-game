@icon("res://assets/roomGen/RoomConfiguration.svg")
class_name RoomConfiguration
extends Resource

@export_category("Basic Information")
@export var flipGeneration : bool = false
@export var roomSize : Vector2
@export var roomLinkPosition : Vector2
@export var roomEnterPosition : Vector2
@export_group("Identity")
@export var roomScene : PackedScene
@export var zoneRestriction : Array[int]
@export var customMargin : Vector2
@export_range(0.0, 1.0, 0.1) var generationChance : float = 0.5
