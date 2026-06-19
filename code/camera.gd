extends Camera2D

@export var ball : Node2D

func _ready():
	if ball:
		ball.bounce.connect(shake)

func _process(delta):
	var targetPosition = Vector2(576.0,324.0)
	if ball:
		if !ball.mounted:
			targetPosition = lerp(targetPosition,ball.global_position,0.05)
	
	global_position = lerp(global_position,targetPosition,delta*3)
	global_rotation = lerp(global_rotation,0.0,delta*3)
func shake():
	global_position += randf_range(-1,1) * Vector2.ONE 
	global_rotation += randf_range(-1,1) * 1
