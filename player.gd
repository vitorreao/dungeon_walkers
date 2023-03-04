@icon("icon.svg")
extends CharacterBody3D
class_name Player

signal navigation_finished()

@export var movement_speed : float = 3.0
@export var turn_speed: float = 2.0

@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D

var _is_navigating: bool = false
var _curr_dest_position: Vector3 = Vector3.ZERO
var _rotation_t: float = 0.0
var _curr_src_rotation: Basis
var _curr_dest_rotation: Basis

func _on_new_nav_target(node: NavArea, position: Vector3):
	navigation_agent.set_target_position(position)
	navigation_agent.target_desired_distance = node.target_desired_distance
	navigation_agent.path_desired_distance = node.path_desired_distance

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		if _is_navigating: # was navigating
			navigation_finished.emit()
		_is_navigating = false
		return
	_set_new_velocity()
	_look_at_target(delta)

func _look_at_target(delta):
	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	if _curr_dest_position != next_path_position:
		_rotation_t = 0.0
		_curr_dest_position = next_path_position
		_curr_src_rotation = transform.basis
		_curr_dest_rotation = transform.looking_at(next_path_position, Vector3.UP).basis
	_rotation_t = min(_rotation_t + delta * turn_speed, 1.0)
	transform.basis = _curr_src_rotation.slerp(_curr_dest_rotation, _rotation_t)

func _set_new_velocity():
	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	var current_agent_position : Vector3 = global_transform.origin
	var new_velocity : Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed
	if new_velocity.length() > 0:
		_is_navigating = true
	navigation_agent.set_velocity(new_velocity)

func _on_NavigationAgent3D_velocity_computed(safe_velocity : Vector3):
	# Move CharacterBody3D with the computed `safe_velocity` to avoid dynamic obstacles.
	set_velocity(safe_velocity)
	move_and_slide()
