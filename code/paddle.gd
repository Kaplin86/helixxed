extends CharacterBody2D

@export var speed = 150

func _physics_process(delta):
	var dir := Input.get_axis("paddle_left", "paddle_right")
	velocity.x = dir * speed
	velocity.y = 0
	
	var ball = $"../Ball"
	var offsetBefore
	if ball.mounted:
		offsetBefore = ball.global_position - global_position
	
	move_and_slide()
	
	if ball.mounted:
		ball.global_position = global_position + offsetBefore
