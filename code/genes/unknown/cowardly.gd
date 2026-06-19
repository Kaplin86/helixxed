extends BaseGene
class_name CowardlyGene

var desc = "The ball will slightly move AWAY any nearby bricks. The power of the cowardice is dependent on the ball speed"

func preCalc(_ball : Ball, _delta : float):
	var bricks : Array[Brick] = _ball.get_tree().current_scene.bricks
	var lowestDist = 999999999999999
	var lowestBrick = null
	for i in bricks:
		if is_instance_valid(i):
			var distance = i.global_position.distance_to(_ball.global_position)
			if distance < lowestDist:
				lowestBrick = i
				lowestDist = distance
	
	if lowestBrick != null:
		var dir = _ball.global_position.direction_to(lowestBrick.global_position)
		print(lowestDist)
		if lowestDist < 200:
			_ball.calculatingVelocity -= dir * _ball.speed *0.2
