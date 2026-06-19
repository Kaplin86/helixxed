extends BaseGene
class_name MisstepGene

var desc = "The Ball will bounce in random directions, but damage is increased by 3"

func onGeneralBounce(_ball : Ball):
	var angle = randf_range(-90,90)
	_ball.velocity = _ball.velocity.rotated(deg_to_rad(angle))

func calculateDamage(_ball : Ball):
	_ball.calculatingDamage += 3
