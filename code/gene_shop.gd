extends Panel
class_name GeneShop

@export var shopArea : Container

var basicGenes : Array[BaseGene] = [
	BoostGene.new(),
	BouncyGene.new(),
	FloatyGene.new(),
	#PaddleFreezeGene.new(),
	HomingGene.new(),
	MomentumGene.new()
]

var unknownGene : Array[BaseGene] = [
	CowardlyGene.new(),
	MisstepGene.new(),
	PanicGene.new()
]

signal shopClose

func doShop():
	
	$HBoxContainer/VBoxContainer3/Panel2/Button2.disabled = false
	
	visible = true
	var shoppingGenes = {}
	for I in shopArea.get_children(): I.queue_free()
	for I in 3:
		var gene : BaseGene = basicGenes.pick_random().duplicate(true)
		gene.resource_local_to_scene = true
		var price = randi_range(1,20)
		var newButton = Button.new()
		if gene.texture == null:
			newButton.icon = load("res://assets/sprites/genes/BouncyGene.png")
		else:
			newButton.icon = load(gene.texture)
		newButton.expand_icon = true
		newButton.text = gene.get_script().get_global_name() + "\n ($" + str(price) + ")"
		newButton.tooltip_text = str(gene)+"\n"+gene.desc
		shopArea.add_child(newButton)
		newButton.size_flags_vertical = Control.SIZE_EXPAND_FILL
		newButton.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		newButton.pressed.connect(shopButtonPressed.bind(gene,price,newButton))
	
	await shopClose
	visible = false

func shopButtonPressed(gene : BaseGene,cost : int,button : Button):
	if $"..".money >= cost:
		button.queue_free()
		$"..".money -= cost
		$"..".equipedGenes.append(gene)
		$"../ColorRect".showGenes($"..".equipedGenes)
		$HBoxContainer/VBoxContainer3/Panel2/Button2.disabled = true
	else:
		pass

func CharityPressed():
	var newGenePool = []
	newGenePool.append_array(basicGenes)
	newGenePool.append_array(unknownGene)
	newGenePool.append_array(unknownGene)
	newGenePool.append_array(unknownGene)
	newGenePool.append_array(unknownGene)
	var newGene = newGenePool.pick_random().duplicate(true)
	$"..".equipedGenes.append(newGene)
	$"../ColorRect".showGenes($"..".equipedGenes)
	shopClose.emit()


func _on_continue_pressed():
	shopClose.emit()
