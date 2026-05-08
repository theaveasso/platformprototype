class_name Player extends CharacterBody2D

signal state_changed(from_state: PlayerState, to_state: PlayerState)

const GRAVITY: float = 980.0
var gravity_multiplier: float = 1.0

@export var move_speed: float = 120.0
@export var jump_velocity: float = 360.0

@export var initial_state: PlayerState

var direction: Vector2 = Vector2.ZERO
var current_state: PlayerState
var previous_state: PlayerState

func _ready() -> void:
	state_changed.connect(on_state_changed)
	init_states()

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		transition_to(current_state.handle_input(event))

func _process(delta: float) -> void:
	update_direction()
	if current_state:
		transition_to(current_state.process(delta))

func _physics_process(delta: float) -> void:
	var next: PlayerState = null
	if current_state:
		next = current_state.physics_process(delta)
	velocity.y += GRAVITY * gravity_multiplier * delta
	move_and_slide()
	transition_to(next)

func init_states() -> void:
	var states: Array[PlayerState] = []
	for child in $States.get_children():
		if child is PlayerState:
			child.player = self
			states.append(child)

	if states.is_empty():
		push_error("Player has no PlayerState children under $States")
		return

	for state in states:
		state.init()

	current_state = initial_state if initial_state != null else states[0]
	current_state.enter()
	state_changed.emit(null, current_state)

func transition_to(next: PlayerState) -> void:
	if next == null or next == current_state:
		return
	current_state.exit()
	previous_state = current_state
	current_state = next
	current_state.enter()
	state_changed.emit(previous_state, current_state)

func on_state_changed(_from: PlayerState, to: PlayerState) -> void:
	if has_node("Debug/State"):
		$Debug/State.text = to.name

func update_direction() -> void:
	var axis_x = Input.get_axis("Left", "Right")
	var axis_y = Input.get_axis("Up", "Down")
	direction = Vector2(axis_x, axis_y)
