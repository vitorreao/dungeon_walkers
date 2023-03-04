extends StaticBody3D
class_name NavArea

signal mouse_over(
	is_over: bool,
	node: NavArea,
	event: InputEventMouse,
	position: Vector3,
	normal: Vector3
)

@export var target_desired_distance = 1.0
@export var path_desired_distance = 1.0

var _navRegion3D: NavigationRegion3D = null

func _ready():
	for child in get_children():
		if child is NavigationRegion3D:
			_navRegion3D = child
	assert(_navRegion3D != null)

func get_nav_region() -> NavigationRegion3D:
	return _navRegion3D

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouse:
		mouse_over.emit(true, self, event, position, normal)

func _mouse_exit():
	mouse_over.emit(false, self, null, Vector3.ZERO, Vector3.ZERO)
