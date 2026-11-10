extends Node

var modFiles : Array[PackedScene] = [
	preload("res://assets/mods/stoplyte.tscn"),
	preload("res://assets/mods/hex.tscn"),
	preload("res://assets/mods/disco.tscn"),
]
# Format is {Scene : StackCount}
var instantiatedModScenes : Dictionary[Node, int]
var treeChildren : Array = []

func update_treeChildren() -> void:
	treeChildren.clear()
	treeChildren = get_tree().current_scene.get_children()

func _ready() -> void:
	update_treeChildren()
	add_commands()

func add_commands() -> void:
	Console.add_command("set_fps", set_fps, ["int"], 1)
	Console.add_command("add_mod", add_mod, ["String"], 1)

func set_fps(cap : String) -> void:
	Engine.max_fps = int(cap)
	Console.print_info("Framerate limit set to %s" % [cap])

func add_mod(modName : String) -> void:
	update_treeChildren()
	var fixedName : String = modName.to_lower()
	
	match fixedName:
		"stoplyte", "lyte":
			var lyteScene : Node2D = modFiles[0].instantiate()
			
			for search in treeChildren:
				if search is CanvasLayer:
					search.get_child(0).get_child(0).add_child(lyteScene)
		_:
			Console.print_error("Modifier does not exist (could not find name)", true)
