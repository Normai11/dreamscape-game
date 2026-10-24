extends Node2D

@export var target_position : Vector2
var drawshapelist : Array[Rect2]
const searchPath : String = "res://assets/roomGen/rooms/roomCFG/"

func _ready() -> void:
	#var getthirdroomtest = get_roomCFGs()[2]
	#var space_state = get_world_2d().direct_space_state
	#var squareShape : RectangleShape2D = RectangleShape2D.new()
	#squareShape.size = getthirdroomtest.roomSize
	#var query = PhysicsShapeQueryParameters2D.new()
	#query.collide_with_areas = true
	#query.shape = squareShape
	#var getextents = query.shape.extents
	#drawshapelist.append(Rect2(-getextents, getextents * 2))
	#print(query.transform)
	#var result = space_state.intersect_shape(query)
	#
	#if result:
		#print("Hit object: ", result[0])
	#queue_redraw()
	pass

func get_roomCFGs() -> Array[RoomConfiguration]:
	var search := DirAccess.open(searchPath)
	var files := search.get_files()
	var returningArray : Array[RoomConfiguration]
	for file in files:
		var loadCheck = load(searchPath + "/" + file)
		if loadCheck is RoomConfiguration:
			returningArray.append(loadCheck)
		else:
			loadCheck.free()
	return returningArray

func _draw() -> void:
	for i in drawshapelist:
		draw_rect(i, Color.RED, false)
	drawshapelist.clear()
