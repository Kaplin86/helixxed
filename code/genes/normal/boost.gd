extends BaseGene
class_name BoostGene

var desc = "Every 3 seconds, the ball will gain extra speed for 1 second. It will also deal extra damage."
var time = 0.0
var boost = false

func preCalc(_ball : Ball, delta : float):
	
	if !_ball.has_meta("afterimage"):
		_ball.set_meta("afterimage",_ball.find_child("Afterimage"))
	
	var afterimage : CPUParticles2D = _ball.get_meta("afterimage")
	
	time += delta
	if boost:
		
		_ball.calculatingVelocity *= 2.0
		
		if time >= 1:
			boost = false
			print("dec damage")
			time = 0
			afterimage.set_meta("weight",afterimage.get_meta("weight",0) - 1)
			if afterimage.get_meta("weight") <= 0:
				afterimage.emitting = false
	else:
		if time >= 3:
			time = 0
			boost = true
			print("inc damage")
			afterimage.set_meta("weight",afterimage.get_meta("weight",0) + 1)
			afterimage.emitting = true

func calculateDamage(_ball : Ball):
	if boost:
		_ball.calculatingDamage += 3
