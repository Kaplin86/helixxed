extends Resource
class_name BaseGene



func onGeneralBounce(_ball : Ball):
	pass

func onBrickHit(_ball : Ball,_brick : Brick):
	pass

func onPaddleHit(_ball : Ball):
	pass

func preCalc(_ball : Ball, delta : float):
	pass

func calculateDamage(_ball : Ball):
	return

func _to_string():
	return str(get_script().get_global_name())
