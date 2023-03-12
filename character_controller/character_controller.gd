extends Node
class_name CharacterController

signal action_finished(action: Action)

@export var character_movement: CharacterMovement

@onready var action_queue: Array = []
var current_action: Action

func _ready():
	if character_movement == null:
		var parent: Node = get_parent()
		if parent is CharacterMovement:
			character_movement = parent as CharacterMovement
	assert(character_movement != null)

func push_move_action(target: PlayerTarget, position: Vector3):
	var action: MoveAction = MoveAction.new(character_movement, target, position)
	action_queue.push_front(action)

func stop_current_action():
	_stop_or_finish_current_action()

func clear_action_queue():
	action_queue.clear()

func _process(delta):
	if current_action == null:
		_start_next_action()
	if current_action != null and current_action.has_finished:
		_stop_or_finish_current_action()
	if current_action != null and not current_action.has_started:
		_start_action()

func _start_next_action():
	if len(action_queue) > 0:
		current_action = action_queue.pop_front()
		_start_action()

func _start_action():
	current_action.start()

func _stop_or_finish_current_action():
	if current_action != null:
		action_finished.emit(current_action)
		current_action = null
