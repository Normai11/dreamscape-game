@icon("res://assets/roomGen/RoomConfiguration.svg")
class_name RoomConfiguration
extends Resource

enum roomTypes {
	NORMAL = 0,
	TRIAL = 1,
	END = 2,
	SAFEROOM = 3
}

@export_category("Basic Information")
@export var flipGeneration : bool = false
## Forces the direction this room will generate in. -1 turns genDirection left, 1 turns right. Leave at 0 to have no effect.
@export_range(-1, 1) var forceGenDirection : int = 0
@export var roomSize : Vector2
@export var roomLinkPosition : Vector2
@export var roomEnterPosition : Vector2
@export_group("Identity")
@export var roomType = roomTypes.NORMAL
@export var roomScene : PackedScene
@export var zoneRestriction : Array[int]
@export var customMargin : Vector2
@export_range(0.0, 1.0, 0.1) var generationChance : float = 0.5
