extends PhysicsBody3D
class_name NavTarget

signal mouse_motion(
	is_hovering: bool,
	node: CollisionObject3D,
	event: InputEventMouseMotion,
	position: Vector3,
	normal: Vector3,
	height: float
)

@export var target_desired_distance = 1.0
@export var path_desired_distance = 1.0
@export var height: float = 0.0

func _input_event(camera, event, position, normal, shape_idx):
	if not event is InputEventMouse:
		return
	mouse_motion.emit(true, self, event, global_position, normal, height)

func _mouse_exit():
	mouse_motion.emit(false, self, null, Vector3.ZERO, Vector3.ZERO, 0.0)
