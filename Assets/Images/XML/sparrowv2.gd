tool

extends Sprite

onready var textureResourcePath = texture.resource_path

var xmlSprite : String

var xmlShiftAnim : String
var xmlShiftFrame = Engine.get_frames_per_second()
var xmlShift = false

var xmlRegions : Array = Array()

func xmlScan():
	var xmlScanner = XMLParser.new()
	if ".xml" in xmlSprite:
		xmlScanner.open(xmlSprite)
		var sword : int
		while sword <= 1:
			if xmlScanner.get_node_name() == "TextureAtlas":
				sword += 1
			if xmlScanner.get_node_name() == "SubTexture":
				if xmlScanner.get_attribute_count() < 7:
					xmlRegions.insert(xmlRegions.size(), [xmlScanner.get_attribute_value(0), xmlScanner.get_attribute_value(1), xmlScanner.get_attribute_value(2), xmlScanner.get_attribute_value(3), xmlScanner.get_attribute_value(4)])
				else:
					xmlRegions.insert(xmlRegions.size(), [xmlScanner.get_attribute_value(0), xmlScanner.get_attribute_value(1), xmlScanner.get_attribute_value(2), xmlScanner.get_attribute_value(3), xmlScanner.get_attribute_value(4), xmlScanner.get_attribute_value(5), xmlScanner.get_attribute_value(6)])
			xmlScanner.read()

func xmlAnim(node : String, time : float):
	xmlShiftFrame = Engine.get_frames_per_second() / (time * Engine.get_frames_per_second())
	if not ".xml" in xmlSprite:
		print(xmlSprite)
		print("You don't have the xml dumbass")
		return
	print(xmlRegions.size())
	if xmlRegions.size() == 0:
		xmlSprite = textureResourcePath.replace(".png", ".xml")
		xmlScan()
		print("Scanny")
	print(xmlRegions.size(), ", hopefully not 0.")
	var ready = false
	var frameint = null
	for i in xmlRegions.size() - 1:
		if node in xmlRegions[i][0]:
			if ready != true:
				ready = true
			if frameint == null:
				frameint = i
	if ready == true:
		xmlShift = true
		while node in xmlRegions[frameint][0] and xmlShift == true:
			if xmlShift == false:
				return
			self.region_rect = Rect2(Vector2(xmlRegions[frameint][1], xmlRegions[frameint][2]), Vector2(xmlRegions[frameint][3], xmlRegions[frameint][4]))
			if xmlRegions[frameint].size() >= 6:
				self.offset.x = -(int(xmlRegions[frameint][5]) if flip_h != true else int(xmlRegions[frameint][5]) * -1)
				self.offset.y = -(int(xmlRegions[frameint][6]) if flip_v != true else int(xmlRegions[frameint][6]) * -1)
			xmlShiftAnim = xmlRegions[frameint][0]
			frameint += 1
			yield(get_tree().create_timer(Engine.get_frames_per_second() / (time * Engine.get_frames_per_second())), "timeout")
		print("Finished .xml anim")
	else:
		printerr("Not ready, fuckass")

func _ready():
	xmlSprite = textureResourcePath.replace(".png", ".xml")
	xmlScan()
