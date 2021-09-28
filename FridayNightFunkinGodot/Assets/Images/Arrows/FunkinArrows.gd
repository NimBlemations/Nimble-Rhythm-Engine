extends Node2D

export(String, "Left", "Right") var whichSide
export var songJsonPath : String = String("res://Assets/Songs/")

onready var arrowLeft : Sprite = get_node("ArrowLeft")
onready var arrowDown : Sprite = get_node("ArrowDown")
onready var arrowUp : Sprite = get_node("ArrowUp")
onready var arrowRight : Sprite = get_node("ArrowRight")
onready var jsonFile = File.new()

func _ready():
	var jsonDictionary : Dictionary
	jsonFile.open(songJsonPath, File.READ)
	print(JSON.parse(jsonFile.get_as_text()).result)
	
	jsonDictionary = JSON.parse(jsonFile.get_as_text()).result
