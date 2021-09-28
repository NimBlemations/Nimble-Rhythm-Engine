extends Node2D

onready var xmlThing : Sprite = get_node("XML")

func _ready():
	xmlThing.xmlRegionAnim("BF idle dance0", 24)
