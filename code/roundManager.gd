extends Node2D

@export var brickGenerator : BrickGenerator

@export var ballScene : PackedScene
@export var paddle : Node

@export var dispManager : DisplayManager

var bricks : Array[Brick]

signal allBricksBroken
var difficulty = 0.0
var round = 0

@export var bgm : AudioStreamPlayer

signal newBallRequest
var win = false

@export var equipedGenes : Array[BaseGene]

@export var geneShop : GeneShop

var money = 999:
	set(new_value):
		money = new_value
		dispManager.showMoney(money)

func _doRound():
	win = false
	difficulty += 0.5
	bricks = brickGenerator._generate(difficulty)
	
	for I in bricks:
		I.die.connect(onBrickDie)
	
	
	
	
	allBricksBroken.connect(func(): win = true)
	allBricksBroken.connect(func(): newBallRequest.emit())
	var shotsRemaining = 5
	var balls = []
	
	while !win and shotsRemaining > 0:
		
		for I in balls:
			I.queue_free()
		balls.clear()
		
		shotsRemaining -= 1
		var newBall : Ball = ballScene.instantiate()
		add_child(newBall)
		newBall.mounted = true
		paddle.ball = newBall
		newBall.global_position = paddle.global_position - Vector2(0,50)
		newBall.ballDead.connect(func(): 
				newBallRequest.emit())
		$Camera2D.ball = newBall
		dispManager.showShots(shotsRemaining)
		balls.append(newBall)
		newBall.isMain = true
		newBall.genes = equipedGenes
		await newBallRequest
	
	await get_tree().create_timer(0.3).timeout
	process_mode = Node.PROCESS_MODE_DISABLED
	
	
	for I in balls:
		if is_instance_valid(I):
			I.queue_free()
	balls.clear()
	
	for I in bricks:
		if is_instance_valid(I): I.queue_free()
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	

func _doShop():
	await geneShop.doShop()

func onBrickDie():
	await get_tree().process_frame
	bricks = bricks.filter(func(obj): return is_instance_valid(obj))
	if bricks.size() == 0:
		allBricksBroken.emit()
signal forever

func _ready():
	dispManager.showGenes(equipedGenes)
	money = 0
	while true:
		round += 1
		dispManager.showRound(round)
		$Flavortext.flavortext(round)
		bgm.bus = "master"
		await _doRound()
		if !win:
			$Death.visible = true
			await forever
		bgm.bus = "shop"
		money += randi_range(5,10)
		await _doShop()


func _on_retry_pressed():
	Transition.toScene("res://scenes/main.tscn")
