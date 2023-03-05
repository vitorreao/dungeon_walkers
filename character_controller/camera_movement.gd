extends Camera3D

@export var target: Node3D
@export var distance_to_target: float = 9
@export var sensitivity: float = 0.01
@export var starting_pitch: float = -50
@export var rotation_speed: float = 3.0
@export var max_pitch: float = -20.0
@export var min_pitch: float = -85
@export var max_distance_to_target: float = 15
@export var min_distance_to_target: float = 5

var _start_mouse_position: Vector2
var _axis: Vector2
var _is_rotating: bool = false
var _yaw: float
var _pitch: float

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(target != null)
	rotation_degrees = Vector3(starting_pitch, _yaw, 0)
	_pitch = starting_pitch

func _process(delta):
	if Input.is_action_just_pressed("Orbit"):
		_start_mouse_position = get_viewport().get_mouse_position()
	if Input.is_action_pressed("Orbit"):
		_axis = get_viewport().get_mouse_position() - _start_mouse_position
	if Input.is_action_just_released("Orbit"):
		_axis = Vector2.ZERO
	if Input.is_action_just_released("Zoom In"):
		distance_to_target = clamp(
			distance_to_target - 1,
			min_distance_to_target,
			max_distance_to_target
		)
	if Input.is_action_just_released("Zoom Out"):
		distance_to_target = clamp(
			distance_to_target + 1,
			min_distance_to_target,
			max_distance_to_target
		)

func _physics_process(delta):
	_yaw -= _axis.x * sensitivity
	_pitch -= _axis.y * sensitivity
	_pitch = clamp(_pitch, min_pitch, max_pitch)
	var target_rotation = Quaternion.from_euler(Vector3(deg_to_rad(_pitch), deg_to_rad(_yaw), 0))
	var new_rotation = Quaternion(transform.basis).slerp(target_rotation, rotation_speed * delta)
	transform.basis = Basis(new_rotation)
	global_position = target.global_position + global_transform.basis.z * distance_to_target
