extends BaseGene
class_name HomingGene

func preCalc(_ball : Ball, delta : float):
	var bricks : Array[Brick] = _ball.get_tree().current_scene.bricks
	var lowestDist = 99999
	var lowestBrick = null
	for i in bricks:
		if is_instance_valid(i):
			var distance = i.global_position.distance_to(_ball.global_position)
			if distance < lowestDist:
				lowestBrick = i
	
	if lowestBrick != null:
		var dir = _ball.global_position.direction_to(lowestBrick.global_position).normalized()
		_ball.calculatingVelocity += dir * 400
