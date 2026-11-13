extends Interactable

@onready var doorTamper : Destroyable = $solid
@onready var doorCollision : CollisionShape2D = $solid/CollisionShape2D
@onready var countdown : Timer = $Timer

enum doorTypes {
	NORMAL = -1,
	TAMPERED = 0,
	GENERATE = 1
}

@export var doorType : doorTypes = doorTypes.NORMAL
@export var generateDoorCountdown : float = 1.0

func _ready() -> void:
	countdown.wait_time = generateDoorCountdown
	doorTamper.canBreak = false
	set_door_properties()

func _interacted() -> void:
	if disabled:
		return
	super()
	
	match doorType:
		doorTypes.NORMAL:
			doorCollision.disabled = true
		doorTypes.TAMPERED:
			print("This is a tampered door. No function attached.")
		doorTypes.GENERATE:
			countdown.start()
			GameManager.saferoom_trigger(false)
			for node in get_tree().current_scene.get_children():
				if node is RoomManager:
					node.generate_rooms()
					#break

func set_door_properties() -> void:
	match doorType:
		doorTypes.TAMPERED:
			doorTamper.collision_layer = 1 << 3
			doorTamper.canBreak = true

func _countdown_end() -> void:
	doorCollision.disabled = true
