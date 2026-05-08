class_name Player extends CharacterBody2D


const SPEED = 300.0
const GRAVITY = 980


func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.y = velocity.y + GRAVITY * delta

	move_and_slide()
