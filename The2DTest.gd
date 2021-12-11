extends Node2D

onready var xmlThing : Sprite = get_node("XML")

func _physics_process(_delta):
	var prevAnim : String
	if xmlThing.xmlShiftAnim == prevAnim:
		SpriteUtils.switch_anim(xmlThing, "BF idle dance0", 24)
	prevAnim = xmlThing.xmlShiftAnim
	SpriteUtils.wait_anim_amount(xmlThing)
