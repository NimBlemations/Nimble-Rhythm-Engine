extends Node2D

export(String, "Left", "Right") var whichSide
export var songJsonPath : String = String("res://Assets/Songs/")
export var spritePlayer : NodePath

export var playerLeft : String
export var playerDown : String
export var playerUp : String
export var playerRight : String

onready var spritePlayerGet : Sprite = (get_node(spritePlayer) if spritePlayer != null else null)  
onready var arrowLeft : Sprite = get_node("ArrowLeft")
onready var arrowDown : Sprite = get_node("ArrowDown")
onready var arrowUp : Sprite = get_node("ArrowUp")
onready var arrowRight : Sprite = get_node("ArrowRight")
onready var jsonFile = File.new()
onready var configControlsPath = String("user://Godot/NimbleRhythmEngine/Config/controls.cfg")
onready var config = ConfigFile.new()

var currentAnim : String
var arrowWindowApart : int = 20
var arrowApart : int = 150
var arrowWindowApartRightMultiplier : int = 7

var sectionNumber : int = 0
var sectionNotes : Array

var switchingAnim : bool = false

var controlLeft : int
var controlDown : int
var controlUp : int
var controlRight : int
var controls

func arrow_positional():
	if whichSide == "Left":
		arrowLeft.transform.origin = Vector2(arrowWindowApart, arrowWindowApart)
		arrowDown.transform.origin = Vector2(arrowWindowApart + arrowApart, arrowWindowApart)
		arrowUp.transform.origin = Vector2(arrowWindowApart + (arrowApart * 2), arrowWindowApart)
		arrowRight.transform.origin = Vector2(arrowWindowApart + (arrowApart * 3), arrowWindowApart)
	else:
		if whichSide == "Right":
			arrowRight.transform.origin = Vector2(OS.window_size.x - (arrowWindowApart * arrowWindowApartRightMultiplier), arrowWindowApart)
			arrowUp.transform.origin = Vector2(OS.window_size.x - ((arrowWindowApart * arrowWindowApartRightMultiplier) + arrowApart), arrowWindowApart)
			arrowDown.transform.origin = Vector2(OS.window_size.x - ((arrowWindowApart * arrowWindowApartRightMultiplier) + (arrowApart * 2)), arrowWindowApart)
			arrowLeft.transform.origin = Vector2(OS.window_size.x - ((arrowWindowApart * arrowWindowApartRightMultiplier) + (arrowApart * 3)), arrowWindowApart)

func wait_anim_amount(arrow : Sprite):
	yield(get_tree().create_timer(arrow.xmlShiftFrame), "timeout")

func switch_anim(arrow : Sprite, anim : String, time : int):
	switchingAnim = true
	if arrow.xmlShift == true:
		arrow.xmlShift = false
		yield(get_tree().create_timer(arrow.xmlShiftFrame), "timeout")
		arrow.xmlAnim(anim, time)
	else:
		arrow.xmlAnim(anim, time)
	switchingAnim = false

func _ready():
	print(spritePlayer, "\n", spritePlayerGet)
	arrow_positional()
	#To use configged controls
	if whichSide == "Right":
		controls = config.load(configControlsPath)
		if controls == OK:
			controlLeft = config.get_value("otherKeys","controlLeft",KEY_LEFT)
			controlDown = config.get_value("otherKeys","controlDown",KEY_DOWN)
			controlUp = config.get_value("otherKeys","controlUp",KEY_UP)
			controlRight = config.get_value("otherKeys","controlRight",KEY_RIGHT)
			print("Loaded controls!")
		else:
			var file = File.new()
			if file.file_exists(configControlsPath) == false:
				config.set_value("otherKeys","controlLeft",KEY_LEFT)
				config.set_value("otherKeys","controlDown",KEY_DOWN)
				config.set_value("otherKeys","controlUp",KEY_UP)
				config.set_value("otherKeys","controlRight",KEY_RIGHT)
				controlLeft = KEY_LEFT
				controlDown = KEY_DOWN
				controlUp = KEY_UP
				controlRight = KEY_RIGHT
				config.save(configControlsPath)
				print("Saved controls!")
	
	var jsonDictionary : Dictionary
	jsonFile.open(songJsonPath, File.READ)
	print("Loading .json: ", jsonFile.get_path())
	
	jsonDictionary = JSON.parse(jsonFile.get_as_text()).result
	var notes : Array = jsonDictionary.get("song").get("notes")
	sectionNotes = notes[sectionNumber].get("sectionNotes")

func _input(event):
	if event is InputEventAction:
		if Input.is_action_just_pressed("ui_left"):
			print("Leg")
			SpriteUtils.switch_anim(spritePlayerGet, playerLeft, 24)

func _physics_process(_delta):
	if whichSide == "Right":
		# Left arrow
		if Input.is_action_pressed("ui_left"):
			if not "left press0" in arrowLeft.xmlShiftAnim:
				switch_anim(arrowLeft, "left press0", 24)
		else:
			if not switchingAnim and not "arrowLEFT0" in arrowLeft.xmlShiftAnim:
				switch_anim(arrowLeft, "arrowLEFT0", 24)
		# Down arrow
		if Input.is_action_pressed("ui_down"):
			if not "down press0" in arrowDown.xmlShiftAnim:
				switch_anim(arrowDown, "down press0", 24)
		else:
			if not switchingAnim and not "arrowDOWN0" in arrowDown.xmlShiftAnim:
				switch_anim(arrowDown, "arrowDOWN0", 24)
		# Up arrow
		if Input.is_action_pressed("ui_up"):
			if not "up press0" in arrowUp.xmlShiftAnim:
				switch_anim(arrowUp, "up press0", 24)
		else:
			if not switchingAnim and not "arrowUP0" in arrowUp.xmlShiftAnim:
				switch_anim(arrowUp, "arrowUP0", 24)
		# Right Arrow
		if Input.is_action_pressed("ui_right"):
			if not "right press0" in arrowRight.xmlShiftAnim:
				switch_anim(arrowRight, "right press0", 24)
		else:
			if not switchingAnim and not "arrowRIGHT0" in arrowRight.xmlShiftAnim:
				switch_anim(arrowRight, "arrowRIGHT0", 24)
