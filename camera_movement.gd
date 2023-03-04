extends Camera3D

@export var target: Node3D
@export var distance_to_target: float = 9
@export var sensitivity: float = 0.01

var _start_mouse_position: Vector2
var _axis: Vector2
var _is_rotating: bool = false
var _yaw: float
var _pitch: float

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(target != null)

func _process(delta):
	if Input.is_action_just_pressed("Orbit"):
		_start_mouse_position = get_viewport().get_mouse_position()
	if Input.is_action_pressed("Orbit"):
		_axis = get_viewport().get_mouse_position() - _start_mouse_position
	if Input.is_action_just_released("Orbit"):
		_axis = Vector2.ZERO

func _physics_process(delta):
	_yaw -= _axis.x * sensitivity
	_pitch -= _axis.y * sensitivity
	_pitch = clamp(_pitch, -85, -20)
	var target_rotation = Vector3(_pitch, _yaw, 0)
	rotation_degrees = target_rotation
	global_position = target.global_position + global_transform.basis.z * distance_to_target
