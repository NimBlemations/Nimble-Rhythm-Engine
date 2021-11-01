extends Node2D

export(String, "Left", "Right") var whichSide
export var songJsonPath : String = String("res://Assets/Songs/")

onready var arrowLeft : Sprite = get_node("ArrowLeft")
onready var arrowDown : Sprite = get_node("ArrowDown")
onready var arrowUp : Sprite = get_node("ArrowUp")
onready var arrowRight : Sprite = get_node("ArrowRight")
onready var jsonFile = File.new()
onready var configControlsPath = String("user://NimbleRhythmEngine/Config/controls.cfg")
onready var config = ConfigFile.new()

func _ready():
	var controlLeft : int
	var controlDown : int
	var controlUp : int
	var controlRight : int
	var controls : int
	#To use configged controls
	if whichSide == "Right":
		controls = config.load(configControlsPath)
		if controls == OK:
			controlLeft = config.get_value("otherKeys","controlLeft",65)
			controlDown = config.get_value("otherKeys","controlDown",83)
			controlUp = config.get_value("otherKeys","controlUp",87)
			controlRight = config.get_value("otherKeys","controlRight",68)
		else:
			var file = File.new()
			if file.file_exists(configControlsPath) == false:
				config.set_value("otherKeys","controlLeft",65)
				config.set_value("otherKeys","controlDown",83)
				config.set_value("otherKeys","controlUp",87)
				config.set_value("otherKeys","controlRight",68)
				config.save(configControlsPath)
	
	var jsonDictionary : Dictionary
	jsonFile.open(songJsonPath, File.READ)
	
	jsonDictionary = JSON.parse(jsonFile.get_as_text()).result
	var notes : Array = jsonDictionary.get("song").get("notes")
