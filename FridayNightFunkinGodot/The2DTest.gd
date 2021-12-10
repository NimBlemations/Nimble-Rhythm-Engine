extends Node2D

onready var xmlThing : Sprite = get_node("XML")

func _ready():
	xmlThing.xmlAnim("BF idle dance0", 24)
