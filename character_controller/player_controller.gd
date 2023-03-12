extends CharacterBody3D
class_name PlayerController

signal navigation_finished()

@onready var character_controller: CharacterController = $CharacterController

func _ready():
	assert(character_controller != null)
	character_controller.action_finished.connect(_on_character_controller_action_finished)

func _on_new_interaction(node: PlayerTarget, world_position: Vector3):
	character_controller.stop_current_action()
	character_controller.clear_action_queue()
	character_controller.push_move_action(node, world_position)

func _on_character_controller_action_finished(action: Action):
	if action is MoveAction:
		navigation_finished.emit()
