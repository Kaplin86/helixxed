extends CharacterBody2D
class_name Paddle

@export var speed = 150
@export var ball : Node

@onready var startY = global_position.y

func _physics_process(delta):
	var dir := Input.get_axis("paddle_left", "paddle_right")
	velocity.x = dir * speed
	velocity.y = 0
	var offsetBefore
	
	if ball:
		if ball.mounted:
			offsetBefore = ball.global_position - global_position
	
	move_and_slide()
	
	if ball:
		if ball.mounted:
			ball.global_position = global_position + offsetBefore
	
	global_position.y = startY
