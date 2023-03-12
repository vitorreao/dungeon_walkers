extends Node
class_name CharacterMovement

signal navigation_finished()

@export var movement_speed : float = 4.0
@export var turn_speed: float = 3.0
@export var navigation_agent : NavigationAgent3D

var character_body: CharacterBody3D

func _ready():
	var parent: Node = get_parent()
	assert(parent is CharacterBody3D)
	character_body = parent as CharacterBody3D
	assert(navigation_agent != null)
	navigation_agent.velocity_computed.connect(_on_NavigationAgent3D_velocity_computed)
	navigation_agent.navigation_finished.connect(_on_navigation_agent_3d_navigation_finished)

func move_to_target(node: PlayerTarget, position: Vector3):
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
		character_body.global_position.x - next_path_position.x,
		character_body.global_position.z - next_path_position.z
	)
	character_body.rotation.y = lerp_angle(
		character_body.rotation.y,
		target_rotation_y,
		turn_speed * delta
	)

func _set_new_velocity():
	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	var new_velocity : Vector3 = next_path_position - character_body.global_transform.origin
	new_velocity = new_velocity.normalized() * movement_speed
	navigation_agent.set_velocity(new_velocity)

func _on_NavigationAgent3D_velocity_computed(safe_velocity : Vector3):
	# Move CharacterBody3D with the computed `safe_velocity` to avoid dynamic obstacles.
	character_body.set_velocity(safe_velocity)
	character_body.move_and_slide()

func _on_navigation_agent_3d_navigation_finished():
	navigation_finished.emit()
