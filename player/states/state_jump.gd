class_name PlayerStateJump extends PlayerState

@export var fall_state: PlayerStateFall

func enter() -> void:
	player.velocity.y = -player.jump_velocity

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.velocity.y >= 0.0:
		return fall_state
	return null
