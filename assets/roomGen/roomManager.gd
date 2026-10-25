@tool
class_name RoomManager
extends Node2D

const searchPath : String = "res://assets/roomGen/rooms/roomCFG/"

@onready var posMarker : Marker2D = $posMarker

@export var generateOnReady : bool = false
@export var generationPosition : Vector2 = Vector2.ZERO
@export var setSeed : bool = false
@export var genSeed : int
@export var doRegularCleanup : bool = false
@export var maxAttempts : int = 32
@export var roomNum : int = 5

var RNG : RandomNumberGenerator = RandomNumberGenerator.new()
var spaceState : PhysicsDirectSpaceState2D
var roomCFGlist : Array[RoomConfiguration] = []
var roomWeights : Array[float] = []
var instantiatedRoomList : Array[Room] = []
var existentRoomList : Array[Room] = []
var drawshapelist : Array[Rect2]
var drawFill : bool = false
var genDirection : int = 1

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if setSeed:
		RNG.seed = genSeed
	
	spaceState = get_world_2d().direct_space_state
	roomCFGlist = get_roomCFGs()
	for room in roomCFGlist:
		roomWeights.append(room.generationChance)
	
	add_commands()
	
	if generateOnReady:
		generate_rooms()

func add_commands() -> void:
	Console.add_command("generate_rooms", generate_rooms, [], 0, "Calls the RoomManager to start generating rooms")
	Console.add_command("set_genPos", set_marker_pos, ["x", "y"], 2, "butt")

func roll_room() -> RoomConfiguration:
	if roomCFGlist:
		return roomCFGlist[RNG.rand_weighted(roomWeights)]
	else:
		return null

func generate_rooms() -> void:
	if instantiatedRoomList:
		for room in instantiatedRoomList:
			room.queue_free()
		instantiatedRoomList.clear()
	
	Console.print_info("Generating rooms... maxAttempts: %d | roomNum: %d" % [maxAttempts, roomNum])
	
	var successes : int = 0
	for room in roomNum:
		var roomReference : RoomConfiguration = roll_room()
		var calcFinalPos : Vector2 = Vector2.ZERO
		calcFinalPos = calculate_final_pos(roomReference)
		var physicsQuery = set_query_data(roomReference, calcFinalPos)
		#printerr(genDirection)
		
		var attempts : int = 0
		var result = spaceState.intersect_shape(physicsQuery)
		while result:
			attempts += 1
			if attempts > maxAttempts:
				break
			#print(attempts)
			
			if attempts <= roomCFGlist.size() - 1:
				roomReference = roomCFGlist[attempts]
			else:
				break
			calcFinalPos = calculate_final_pos(roomReference)
			physicsQuery = set_query_data(roomReference, calcFinalPos)
			
			result = spaceState.intersect_shape(physicsQuery)
			await get_tree().process_frame
		
		if !result:
			place_room(roomReference)
			successes += 1
			drawFill = false
		else:
			drawFill = true
		#print(result)
		var drawRect = Rect2((posMarker.position + calcFinalPos) - roomReference.roomSize/2, physicsQuery.shape.size)
		drawshapelist.append(drawRect)
		queue_redraw()
	Console.print_info("Generation finished! Rooms placed: %d / %d" % [successes, roomNum])
	
	cleanup_room_areas()

func cleanup_room_areas() -> void:
	for room in instantiatedRoomList:
		room.free_generation_object()

func set_query_data(roomReference : RoomConfiguration, calculated : Vector2) -> PhysicsShapeQueryParameters2D:
	var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	var queryShape : RectangleShape2D = RectangleShape2D.new()
	query.collision_mask = 1 << 9
	
	#shape setting
	queryShape.size = roomReference.roomSize
	query.shape = queryShape
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	#set pos
	if genDirection == 1:
		query.transform.origin = to_global(posMarker.position) + (calculated)# if genDirection == 1 else -calculated)
	else:
		query.transform.origin = to_global(posMarker.position) + (calculated)# if genDirection == 1 else -calculated)
	
	return query

func calculate_final_pos(roomReference : RoomConfiguration) -> Vector2:
	if genDirection == 1:
		return Vector2(roomReference.roomSize.x/2, -roomReference.roomSize.y/2) + Vector2(roomReference.customMargin.x, roomReference.customMargin.y)
	else:
		return Vector2(-roomReference.roomSize.x/2, -roomReference.roomSize.y/2) + Vector2(-roomReference.customMargin.x, roomReference.customMargin.y)

func place_room(data : RoomConfiguration) -> void:
	var instance : Room = data.roomScene.instantiate()
	instance.global_position = posMarker.position - data.roomEnterPosition# * genDirection
	if genDirection == -1:
		instance.scale.x = -1
	add_child(instance)
	instantiatedRoomList.append(instance)
	
	posMarker.global_position = instance.linkObj.global_position
	if data.flipGeneration:
		genDirection = -genDirection
		if doRegularCleanup:
			cleanup_room_areas()

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

func set_marker_pos(x : String, y : String) -> void:
	posMarker.global_position = Vector2(float(x), float(y))

func _draw() -> void:
	for i in drawshapelist:
		draw_rect(i, Color.RED, drawFill)
	drawshapelist.clear()
