class_name PlayerStateRun extends PlayerState

@export var speed: float = 120.0

@export var idle_state: PlayerStateIdle

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * speed
	if is_zero_approx(player.direction.x):
		return idle_state
	return null
