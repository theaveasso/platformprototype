class_name PlayerStateRun extends PlayerState

@export var idle_state: PlayerStateIdle
@export var jump_state: PlayerStateJump
@export var fall_state: PlayerStateFall

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		return jump_state
	if not player.is_on_floor():
		return fall_state
	if is_zero_approx(player.direction.x):
		return idle_state
	return null
