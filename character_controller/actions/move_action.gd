extends Action
class_name MoveAction

var _character: CharacterMovement
var _target: PlayerTarget
var _position: Vector3

func _init(character: CharacterMovement, target: PlayerTarget, position: Vector3):
	_character = character
	_target = target
	_position = position

func start():
	_character.move_to_target(_target, _position)
	_character.navigation_agent.navigation_finished.connect(finish)
	super()
