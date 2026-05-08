class_name PlayerState extends Node

var player: Player

func init() -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass

# Return another PlayerState to transition; return null to stay.
func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	return null
