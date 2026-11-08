class_name HexWindow
extends Control
signal closeWindow

enum ratios {
	ONE_TO_ONE = 0,
	ONE_TO_TWO = 1,
	TWO_TO_ONE = 2,
	DOUBLE = 3
}

const baseWindowSize : float = 400.0

@onready var visual : NinePatchRect = $NinePatchRect

@export var shrinkCurve : Curve
@export var expireTime : float = 1.0
@export var windowRatio : ratios = ratios.ONE_TO_ONE

var windowIndex : int = 0
var curTimer : float = 0.0
var mouseOver : bool = false
var closed : bool = false

func _ready() -> void:
	visual.mouse_entered.connect(set_mouseOver.bind(true))
	visual.mouse_exited.connect(set_mouseOver.bind(false))
	
	match windowRatio:
		ratios.ONE_TO_ONE:
			visual.size = Vector2(baseWindowSize, baseWindowSize)
			#pivot_offset_ratio = Vector2(0.0, 0.0)
		ratios.ONE_TO_TWO:
			visual.size = Vector2(baseWindowSize, baseWindowSize*1.5)
			#pivot_offset_ratio = Vector2(0.0, 1)
		ratios.TWO_TO_ONE:
			visual.size = Vector2(baseWindowSize*1.5, baseWindowSize)
			#pivot_offset_ratio = Vector2(1, 0.0)
		ratios.DOUBLE:
			visual.size = Vector2(baseWindowSize*1.5, baseWindowSize*1.5)
			#pivot_offset_ratio = Vector2(1, 1)
	visual.position = -Vector2(visual.size.x, visual.size.y)/2
	visual.pivot_offset = visual.size/2

func _process(_delta: float) -> void:
	#curTimer += delta
	
	if shrinkCurve:
		var time = clamp(curTimer / expireTime, 0.0, 1.0)
		var curveValue = shrinkCurve.sample(time)
		#print(curveValue)
		scale = Vector2.ONE * curveValue
	
	#if curTimer >= expireTime:
		#close(false)
	if !closed:
		if (mouseOver && Input.is_action_just_pressed("LMB")):
			closeWindow.emit(self)

func set_mouseOver(value : bool) -> void:
	mouseOver = value

func close() -> void:
	closed = true
	queue_free()
