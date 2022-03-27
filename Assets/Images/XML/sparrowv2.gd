tool

extends Sprite

onready var textureResourcePath = texture.resource_path

var loggerFile = File.new()
var loggerString = SpriteUtils.loggerString

var xmlSprite : String

var xmlShiftAnim : String
var xmlShiftFrame = Engine.get_frames_per_second()
var xmlShift = false

var xmlAnimating = false

var xmlRegions : Array = Array()

func xmlScan():
	var xmlScanner = XMLParser.new()
	if ".xml" in xmlSprite:
		xmlScanner.open(xmlSprite)
		var sword : int = 0
		while sword < 1:
			if xmlScanner.get_node_type() == xmlScanner.NODE_ELEMENT_END:
				if xmlScanner.get_node_name() == "TextureAtlas":
					print("TexAtlasPass")
					loggerString.insert(loggerString.length(), "Texture atlas pass\n")
					sword += 1
			if xmlScanner.get_node_type() == xmlScanner.NODE_ELEMENT:
				if xmlScanner.get_node_name() == "SubTexture":
					if xmlScanner.get_attribute_count() < 7:
						xmlRegions.insert(xmlRegions.size(), [xmlScanner.get_attribute_value(0), xmlScanner.get_attribute_value(1), xmlScanner.get_attribute_value(2), xmlScanner.get_attribute_value(3), xmlScanner.get_attribute_value(4)])
					else:
						xmlRegions.insert(xmlRegions.size(), [xmlScanner.get_attribute_value(0), xmlScanner.get_attribute_value(1), xmlScanner.get_attribute_value(2), xmlScanner.get_attribute_value(3), xmlScanner.get_attribute_value(4), xmlScanner.get_attribute_value(5), xmlScanner.get_attribute_value(6)])
			if xmlScanner.get_node_type() == xmlScanner.NODE_TEXT:
				SpriteUtils.xmlErrorAmount += 1
				if OS.is_debug_build():
					printerr("Scan error amount: ", SpriteUtils.xmlErrorAmount)
			xmlScanner.read()

func xmlAnim(node : String, time : float = 30):
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
	print(xmlRegions.size(), ", hopefully not 0.", (str("\n", xmlRegions.size() - 1, " is the known maximum index.") if xmlRegions.size() != 0 else "\nYou're fucked."))
	var ready = false
	var frameint = null
	for i in xmlRegions.size() - 1:
		if node in xmlRegions[i][0]:
			if ready != true:
				ready = true
			if frameint == null:
				frameint = i
	if ready == true and xmlShift != true and xmlAnimating != true:
		xmlShift = true
		xmlAnimating = true
		while node in xmlRegions[frameint][0] and xmlShift == true and xmlAnimating == true:
			if xmlRegions[frameint]:
				if xmlShift == false and xmlAnimating == false:
					print("Braking!")
					return
				self.region_rect = Rect2(Vector2(xmlRegions[frameint][1], xmlRegions[frameint][2]), Vector2(xmlRegions[frameint][3], xmlRegions[frameint][4]))
				if xmlRegions[frameint].size() >= 6:
					self.offset.x = -(int(xmlRegions[frameint][5]) if flip_h != true else int(xmlRegions[frameint][5]) * -1)
					self.offset.y = -(int(xmlRegions[frameint][6]) if flip_v != true else int(xmlRegions[frameint][6]) * -1)
				xmlShiftAnim = xmlRegions[frameint][0]
			# Successful failsafe!
			if not frameint + 1 > xmlRegions.size() - 1:
				frameint += 1
			yield(get_tree().create_timer(Engine.get_frames_per_second() / (time * Engine.get_frames_per_second())), "timeout")
		print("Finished .xml anim")
		xmlShift = false
		xmlAnimating = false
	else:
		if xmlShift != true:
			printerr("Not ready, fuckass")
		else:
			print("Braked")

func _ready():
	xmlSprite = textureResourcePath.replace("." + textureResourcePath.get_extension(), ".xml")
	xmlScan()
