extends CharacterBody3D
class_name Player

signal navigation_finished()

@export var movement_speed : float = 4.0
@export var turn_speed: float = 3.0

@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D

var _target: NavTarget
var _target_position: Vector3

func _on_new_nav_target(node: NavTarget, position: Vector3):
	navigation_agent.set_target_position(position)
	navigation_agent.target_desired_distance = node.target_desired_distance
	navigation_agent.path_desired_distance = node.path_desired_distance
	_target = node
	_target_position = position

func _physics_process(delta):
	if not _should_stop_navigating():
		_set_new_velocity()
	_look_at_target(delta)

func _look_at_target(delta):
	var target_position = _get_target_position()
	var target_rotation_y = atan2(
		global_position.x - target_position.x,
		global_position.z - target_position.z
	)
	rotation.y = lerp_angle(rotation.y, target_rotation_y, turn_speed * delta)

func _set_new_velocity():
	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	var new_velocity : Vector3 = next_path_position - global_transform.origin
	new_velocity = new_velocity.normalized() * movement_speed
	navigation_agent.set_velocity(new_velocity)

func _on_NavigationAgent3D_velocity_computed(safe_velocity : Vector3):
	# Move CharacterBody3D with the computed `safe_velocity` to avoid dynamic obstacles.
	set_velocity(safe_velocity)
	move_and_slide()

func _on_navigation_agent_3d_navigation_finished():
	navigation_finished.emit()

func _get_target_position():
	if not navigation_agent.is_navigation_finished():
		return navigation_agent.get_next_path_position()
	if _target != null:
		return _target_position
	return global_position

func _should_stop_navigating():
	if navigation_agent.is_navigation_finished():
		return true
	if navigation_agent.is_target_reached() and _target.interactable:
		navigation_agent.set_target_position(global_position)
		return true
	return false
