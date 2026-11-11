extends Node

var modFiles : Array[PackedScene] = [
	preload("res://assets/mods/stoplyte.tscn"),
	preload("res://assets/mods/hex.tscn"),
	preload("res://assets/mods/disco.tscn"),
]
# Format is {Name : [Instance, Count, MaxStack]}
var instantiatedModScenes : Dictionary[String, Array]
var scenePlayer : Player
var sceneCanvas : CanvasLayer
var sceneScreenies : SubViewport

func update_sceneVitals() -> void:
	for node in get_tree().current_scene.get_children():
		if node is Player:
			scenePlayer = node
		elif node is CanvasLayer:
			sceneCanvas = node
			for child in node.find_children("*", "", true):
				if child is SubViewport:
					sceneScreenies = child

func _ready() -> void:
	update_sceneVitals()
	add_commands()

func add_commands() -> void:
	Console.add_command("set_fps", set_fps, ["int"], 1)
	Console.add_command("add_mod", add_mod, ["String"], 1)

func saferoom_trigger(enter : bool) -> void:
	for enemy in instantiatedModScenes:
		var scene = instantiatedModScenes[enemy][0]
		if scene is ModifierEnemy:
			scene._saferoom(enter)

func set_fps(cap : String) -> void:
	Engine.max_fps = int(cap)
	Console.print_info("Framerate limit set to %s" % [cap])

func add_all_mods() -> void:
	pass #will be used in a for loop when modifier resource files are added

func add_mod(modName : String) -> void:
	update_sceneVitals()
	var fixedName : String = modName.to_lower()
	
	match fixedName:
		"stoplyte", "lyte":
			if !instantiatedModScenes.has("lyte"):
				add_to_scene(modFiles[0])
			else:
				var data : Array = instantiatedModScenes["lyte"]
				if data[1] >= data[2]:
					Console.print_error("Max stack reached!")
				else:
					data[1] += 1
					data[0].curStack = data[1]
					data[0]._mod_reset()
		"disco":
			if !instantiatedModScenes.has("disco"):
				add_to_scene(modFiles[2])
			else:
				var data : Array = instantiatedModScenes["disco"]
				if data[1] >= data[2]:
					Console.print_error("Max stack reached!")
				else:
					data[1] += 1
					data[0].curStack = data[1]
					data[0]._mod_reset()
		"hex":
			if !instantiatedModScenes.has("hex"):
				add_to_scene(modFiles[1])
			else:
				var data : Array = instantiatedModScenes["hex"]
				if data[1] >= data[2]:
					Console.print_error("Max stack reached!")
				else:
					data[1] += 1
					data[0].curStack = data[1]
					data[0]._mod_reset()

func add_to_scene(instance : PackedScene) -> void:
			var scene : ModifierEnemy = instance.instantiate()
			var path : int = scene.path
			var dictKey : String = scene.dataName
			var maxStack : int = scene.maxStack
			
			scene.playerReference = scenePlayer
			if path == 1:
				sceneCanvas.add_child.call_deferred(scene)
			elif path == 2:
				sceneScreenies.add_child.call_deferred(scene)
			else:
				get_tree().current_scene.add_child.call_deferred(scene)
			
			instantiatedModScenes[dictKey] = [scene, 1, maxStack]
