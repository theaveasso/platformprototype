class_name PlayerStateIdle extends PlayerState

@export var run_state: PlayerStateRun
@export var jump_state: PlayerStateJump
@export var fall_state: PlayerStateFall

func enter() -> void:
	player.velocity.x = 0.0

func physics_process(_delta: float) -> PlayerState:
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		return jump_state
	if not player.is_on_floor():
		return fall_state
	if not is_zero_approx(player.direction.x):
		return run_state
	return null
