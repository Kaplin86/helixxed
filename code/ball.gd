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

var soundCooldown = 0

var bouncesSinceLastHit = 0

func _process(delta):
	soundCooldown += delta
	if soundCooldown > 0.5:
		soundPitch = 1.0
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
		bouncesSinceLastHit += 1
		hitSound()
		
		speed += 0.05
		velocity = velocity.bounce(col.get_normal())
		velocity = velocity.normalized() * speed
		bounce.emit()
		
		# genes part 2
		for I in genes:
			I.onGeneralBounce(self)
		
		if col.get_collider() is Brick:
			bouncesSinceLastHit = 0
			# genes part 2
			for I in genes:
				I.onBrickHit(self,col.get_collider())
			
			onBrickImpact(col.get_collider())
		elif col.get_collider() is Paddle:
			bouncesSinceLastHit = 0
			# genes part 3
			for I in genes:
				I.onPaddleHit(self)
		print(bouncesSinceLastHit)
		if bouncesSinceLastHit > 8:
			velocity = velocity.rotated(deg_to_rad(30))

func onBrickImpact(brick : Brick):
	
	calculatingDamage = damage
	for I in genes:
		I.calculateDamage(self)
	
	brick.hp -= round(calculatingDamage)

var soundPitch = 1.0

func hitSound():
	soundCooldown = 0
	soundPitch += 0.1
	var newSoundPlayer = AudioStreamPlayer.new()
	add_child(newSoundPlayer)
	newSoundPlayer.stream = load("res://assets/audio/button-24.mp3")
	newSoundPlayer.play()
	newSoundPlayer.pitch_scale = soundPitch
	await newSoundPlayer.finished
	newSoundPlayer.queue_free()
