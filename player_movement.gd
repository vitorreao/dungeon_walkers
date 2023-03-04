extends Node
class_name PlayerMovement

signal new_nav_target(node: NavArea, world_position: Vector3)

var _current_target: Vector3 = Vector3.ZERO
var _has_current_target: bool = false
var _is_currently_pressed: bool = false

func _on_player_reached_target():
	$Target.set_visible(false)

func _on_nav_area_mouse_over(
	is_over: bool,
	node: NavArea,
	event: InputEventMouse,
	position: Vector3,
	normal: Vector3
):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_is_currently_pressed = true
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_is_currently_pressed = false

	$Marker.set_global_position(position)
	$Marker.set_visible(is_over)
	if _is_currently_pressed:
		$Target.set_global_position(position)
		$Target.set_visible(true)
		new_nav_target.emit(node, position)
