extends CharacterBody2D
class_name Ball

@export var speed : float = 500.0
@export var mounted = true
@export var damage = 1

signal bounce
signal ballDead

@export var genes : Array[BaseGene]

var calculatingVelocity
var calculatingDamage

var isMain = false

func _ready():
	velocity = Vector2.RIGHT.rotated(deg_to_rad(70)) * speed

func _process(delta):
	if mounted:
		$Line2D.visible = true
		var pos = to_local(get_global_mouse_position())
		pos = pos.normalized()
		$Line2D.set_point_position(1,pos * speed * 0.5)
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			unmount()
		
	else:
		$Line2D.visible = false
	
	if global_position.y > 679:
		queue_free()
		ballDead.emit()

func unmount():
	var pos = to_local(get_global_mouse_position())
	var angle = pos.normalized()
	velocity = angle * speed
	mounted = false

func _physics_process(delta):
	if mounted:
		return
	
	calculatingVelocity = velocity
	
	# genes part 1
	for I in genes:
		I.preCalc(self,delta)
	
	var col = move_and_collide(calculatingVelocity * delta)
	
	if col:
		speed += 0.05
		velocity = velocity.bounce(col.get_normal())
		velocity = velocity.normalized() * speed
		bounce.emit()
		
		# genes part 2
		for I in genes:
			I.onGeneralBounce(self)
		
		if col.get_collider() is Brick:
			# genes part 2
			for I in genes:
				I.onBrickHit(self,col.get_collider())
			
			onBrickImpact(col.get_collider())
		elif col.get_collider() is Paddle:
			# genes part 3
			for I in genes:
				I.onPaddleHit(self)

func onBrickImpact(brick : Brick):
	
	calculatingDamage = damage
	for I in genes:
		I.calculateDamage(self)
	
	brick.hp -= round(calculatingDamage)
	print(round(calculatingDamage))
