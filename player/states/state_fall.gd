class_name PlayerStateFall extends PlayerState

@export var idle_state: PlayerStateIdle
@export var run_state: PlayerStateRun
@export var jump_state: PlayerStateJump

@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.15
@export var fall_gravity_multiplier: float = 1.165

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

func enter() -> void:
	player.gravity_multiplier = fall_gravity_multiplier
	# Coyote only when we got here by walking off a ledge, not after a jump.
	coyote_timer = 0.0 if player.previous_state == jump_state else coyote_time

func exit() -> void:
	player.gravity_multiplier = 1.0

func physics_process(delta: float) -> PlayerState:
	coyote_timer = maxf(0.0, coyote_timer - delta)
	jump_buffer_timer = maxf(0.0, jump_buffer_timer - delta)

	player.velocity.x = player.direction.x * player.move_speed

	if Input.is_action_just_pressed("Jump"):
		if coyote_timer > 0.0:
			return jump_state
		jump_buffer_timer = jump_buffer_time

	if player.is_on_floor():
		if jump_buffer_timer > 0.0:
			return jump_state
		return run_state if not is_zero_approx(player.direction.x) else idle_state

	return null
