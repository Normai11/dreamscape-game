extends ModifierEnemy

@onready var body : Node2D = $"."
@onready var window : PackedScene = preload("res://assets/objects/hex_window.tscn")

@export var stackMultiplier : float = 1.11
@export var appearInterval : float = 13.28
@export var windowExpireTimer : float = 1.52
@export var windowCount : int = 2
@export var windowBounds : Vector4 = Vector4(130, 1012, 130, 512)

var realAppearInterval : float = 13.28
var realWindowCount : int = 2
var hexState : int = 0
var curTimer : float = 0.0
var windowChildren : Array[HexWindow] = []

func _mod_reset() -> void:
	super()
	if !windowChildren.is_empty():
		for child in windowChildren:
			child.close()
		windowChildren.clear()
	realAppearInterval = appearInterval - (0.0 if curStack < 2 else curStack * stackMultiplier)
	realWindowCount = windowCount + (0 if curStack < 2 else curStack)
	curTimer = realAppearInterval
	hexState = 0

func _saferoom(entered : bool) -> void:
	super(entered)
	if !windowChildren.is_empty():
		for child in windowChildren:
			child.close()
		windowChildren.clear()

func _ready() -> void:
	_mod_reset()
	add_commands()

func add_commands() -> void:
	Console.add_command("set_hex_timer", set_timer, ["float"], 1)

func _process(delta: float) -> void:
	if paused:
		return
	
	match hexState:
		0:
			curTimer -= delta
			
			if curTimer <= 0:
				curTimer = 0
				for count in realWindowCount:
					spawn_window()
				hexState = 1
		1:
			curTimer += delta
			
			if Input.is_action_just_pressed("closeHexWindow"):
				if !windowChildren.is_empty():
					clear_window(windowChildren[0])
			
			if curTimer >= windowExpireTimer:
				curTimer = realAppearInterval
				hexState = 0
				if !windowChildren.is_empty():
					for child in windowChildren:
						child.close()
					windowChildren.clear()
					print("fail")
			for child in windowChildren:
				child.curTimer = curTimer

func spawn_window() -> void:
	var instance : HexWindow = window.instantiate()
	
	instance.position = Vector2(randf_range(windowBounds.x, windowBounds.y), randf_range(windowBounds.z, windowBounds.w))
	instance.expireTime = windowExpireTimer
	instance.windowRatio = randi_range(0, HexWindow.ratios.size()-1) as HexWindow.ratios
	instance.windowIndex = windowChildren.size()
	instance.closeWindow.connect(clear_window)
	
	get_parent().add_child(instance)
	windowChildren.append(instance)

func clear_window(object : HexWindow) -> void:
	windowChildren.erase(object)
	object.close()
	if windowChildren.is_empty():
		print("pass")

func set_timer(time : String) -> void:
	curTimer = float(time)
