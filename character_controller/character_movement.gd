extends CharacterBody3D
class_name CharacterMovement

signal navigation_finished()

@export var movement_speed : float = 4.0
@export var turn_speed: float = 3.0

@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D

func _on_new_nav_target(node: PlayerTarget, position: Vector3):
	navigation_agent.set_target_position(position)
	navigation_agent.target_desired_distance = node.target_desired_distance
	navigation_agent.path_desired_distance = node.path_desired_distance

func _physics_process(delta):
	if not navigation_agent.is_navigation_finished():
		_set_new_velocity()
	_look_at_target(delta)

func _look_at_target(delta):
	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	var target_rotation_y = atan2(
		global_position.x - next_path_position.x,
		global_position.z - next_path_position.z
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
