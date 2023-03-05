extends Node
class_name PlayerMovement

signal new_nav_target(node: NavTarget, world_position: Vector3)

var _current_target_node: NavTarget = null
var _current_target_position: Vector3 = Vector3.ZERO
var _current_target_normal: Vector3 = Vector3.ZERO
var _current_target_height: float = 0.0
var _has_current_target_position: bool = false

func _set_nav_target():
	var position = (
		_current_target_position +
		_current_target_node.transform.basis.y.normalized() *
		_current_target_height
	)
	_show_target_at(position, _current_target_height)
	new_nav_target.emit(_current_target_node, _current_target_position)

func _physics_process(delta):
	if _has_current_target_position and Input.is_action_pressed("Interact"):
		_set_nav_target()

func _on_player_reached_target():
	_hide_target()
	_current_target_position = Vector3.ZERO
	_current_target_node = null
	_current_target_height = 0.0
	_current_target_normal = Vector3.ZERO
	_has_current_target_position = false

func _on_target_mouse_motion(
	is_hovering: bool,
	node: NavTarget,
	event: InputEventMouse,
	position: Vector3,
	normal: Vector3,
	height: float
):
	$Marker.set_global_position(position)
	$Marker.set_visible(is_hovering)
	_current_target_position = position
	_current_target_node = node
	_current_target_height = height
	_current_target_normal = normal.normalized()
	_has_current_target_position = true

func _show_target_at(position: Vector3, height: float):
	$Target.set_global_position(position)
	$Target.set_visible(true)
	$Target/Arrow/AnimationPlayer.play("spin")

func _hide_target():
	$Target/Arrow/AnimationPlayer.stop()
	$Target.set_visible(false)
