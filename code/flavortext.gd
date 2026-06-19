extends RichTextLabel

var textDef : Dictionary[int,Array] = {
	1:["And so, The next ultimate organism experiment begins...","'Here is the new prototype! I hope it evolves into something... satisfactory, this time!'","The organism looks happy to be here.","You feel the urge to protect the organism."],
	3:["The perfect minimum wage experience: Destroying bricks with ultimate prototypes","So far, so good.","'Thank you!!!'. You could not find where the voice came from."],
	5:["You start to wonder if the prototype enjoys breaking bricks","The gene display shines quietly...","..."],
	8:["Perhaps a promotion is due after getting this far, no?","Evolution. Extinction. Its all the same, isnt it?"],
	10:["'This prototype has potential. Keep up the good work, kid.'","10. What a milestone."],
	25:["'Hi!! Tank u so much mister cyan tist!! I feel so strong with these jeans!!'. You could not find where the voice came from."]
}

func flavortext(round):
	if textDef.has(round):
		var texty= textDef[round].pick_random() 
		modulate = Color.WHITE
		text = "[wave amp=25.0 freq=5.0 connected=1]"+texty+ "[/wave]"
		await get_tree().create_timer(texty.length() * 0.06).timeout
		var newTween = create_tween()
		newTween.tween_property(self,"modulate",Color.TRANSPARENT,0.5)
