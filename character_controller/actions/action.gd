extends RefCounted
class_name Action

var has_started: bool = false
var has_finished: bool = false

func start():
	has_started = true

func finish():
	has_finished = true
