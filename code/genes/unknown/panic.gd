extends BaseGene
class_name PanicGene

var desc = "The ball suddenly gains velocity near bricks, but will change direction unpredictably"
var texture = "res://assets/sprites/genes/PanicGene.png"

func preCalc(_ball : Ball, _delta : float):
	var bricks : Array[Brick] = _ball.get_tree().current_scene.bricks
	var valid = false
	for i in bricks:
		if is_instance_valid(i):
			var distance = i.global_position.distance_to(_ball.global_position)
			if distance < 300:
				valid = true
				break
	
	if valid:
		_ball.calculatingVelocity *= 1.5
		var angle = randf_range(-10,10)
		_ball.velocity = _ball.velocity.rotated(deg_to_rad(angle))
