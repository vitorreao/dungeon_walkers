extends PhysicsBody3D
class_name NavTarget

signal mouse_motion(
	is_hovering: bool,
	node: NavTarget,
	event: InputEventMouseMotion,
	position: Vector3,
	normal: Vector3,
	height: float
)

@export var target_desired_distance = 1.0
@export var path_desired_distance = 1.0
@export var height: float = 0.0
@export var interactable: bool = false

func _input_event(camera, event, position, normal, shape_idx):
	if not event is InputEventMouse:
		return
	var target_position = position if not interactable else global_position
	mouse_motion.emit(true, self, event, target_position, normal, height)

func _mouse_exit():
	mouse_motion.emit(false, self, null, Vector3.ZERO, Vector3.ZERO, 0.0)
