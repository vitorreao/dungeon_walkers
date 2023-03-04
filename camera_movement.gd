extends Camera3D

@export var target: Node3D
@export var distance_to_target: Vector3 = Vector3(0.0, 9.0, 7.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(target != null)

func _physics_process(delta):
	global_position = target.global_position + distance_to_target
