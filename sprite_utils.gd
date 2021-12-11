extends Node

export var xmlErrorAmount : int = 0
export var loggerString : String = ""

func switch_anim(sprite : Sprite, anim : String, time : int):
	if sprite.xmlShift == true:
		sprite.xmlShift = false
		yield(get_tree().create_timer(sprite.xmlShiftFrame), "timeout")
		sprite.xmlAnim(anim, time)
	else:
		sprite.xmlAnim(anim, time)

func wait_anim_amount(sprite : Sprite):
	yield(get_tree().create_timer(sprite.xmlShiftFrame), "timeout")
