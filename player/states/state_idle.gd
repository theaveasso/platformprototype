class_name PlayerStateIdle extends PlayerState

@export var run_state: PlayerStateRun

func enter() -> void:
	player.velocity.x = 0.0

func physics_process(_delta: float) -> PlayerState:
	if not is_zero_approx(player.direction.x):
		return run_state
	return null
