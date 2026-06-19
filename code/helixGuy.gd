extends Sprite2D

var target = null
func _process(delta):
	if target == null:
		target = global_position + Vector2(randi_range(-90,90),randi_range(-90,90))
	
	global_position += global_position.direction_to(target) * 60 * delta
	if global_position.distance_to(target) < 30:
		target = global_position + Vector2(randi_range(-90,90),randi_range(-90,90))

func _ready():
	$AnimationPlayer.play("main")
