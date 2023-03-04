extends Node
class_name PlayerMovement

signal new_nav_target(node: NavArea, world_position: Vector3)

var _current_target_node: CollisionObject3D = null
var _current_target_position: Vector3 = Vector3.ZERO
var _has_current_target_position: bool = false

func _set_nav_target(node: CollisionObject3D, position: Vector3):
	$Target.set_global_position(position)
	$Target.set_visible(true)
	new_nav_target.emit(node, position)

func _physics_process(delta):
	if _has_current_target_position and Input.is_action_pressed("Interact"):
		_set_nav_target(_current_target_node, _current_target_position)

func _on_player_reached_target():
	$Target.set_visible(false)
	_current_target_position = Vector3.ZERO
	_current_target_node = null
	_has_current_target_position = false

func _on_target_mouse_motion(
	is_hovering: bool,
	node: CollisionObject3D,
	event: InputEventMouse,
	position: Vector3,
	normal: Vector3
):
	$Marker.set_global_position(position)
	$Marker.set_visible(is_hovering)
	_current_target_position = position
	_current_target_node = node
	_has_current_target_position = true
