tool

extends Sprite

var xml = XMLParser.new()
var txtOffset = File.new()

export var spriteXml : String = String("res://Assets/Images/XML/Spritesheet")
export var spriteXmlOffset : String = String("res://Assets/Images/XML/Spritesheet")
export var spriteXmlThumbnail : String
export var spriteXmlFrameRate : int = int(24)

func xmlRegion(node : int):
	
	xml.seek(node)
	self.region_rect = Rect2(xml.get_attribute_value(1), xml.get_attribute_value(2), xml.get_attribute_value(3), xml.get_attribute_value(4))
	if xml.get_attribute_count() >= 7:
		if self.flip_h == false:
			self.offset = -Vector2(xml.get_attribute_value(5), xml.get_attribute_value(6))
		else:
			self.offset = -Vector2(-float(xml.get_attribute_value(5)), xml.get_attribute_value(6))
	xml.read()

func xmlRegionExec(node : String):
	if ".xml" in spriteXml and not node == null:
		var finished : bool = bool(false)
		while not finished == true:
			if not xml.get_node_name() == "SubTexture":
				print(xml.get_node_name())
				xml.read()
			else:
				if node in xml.get_attribute_value(0):
					xmlRegion(xml.get_current_line())
					finished = true
					print("Finished region")
				else:
					xml.read()
		print("Finished code")
	else:
		printerr("You forgot to input an XML or Region Image.")
		

func xmlThumbnailImage():
	if ".xml" in spriteXml and not spriteXmlThumbnail == null:
		var finished : bool = bool(false)
		while not finished == true:
			if not xml.get_node_name() == "SubTexture":
				print(xml.get_node_name())
				xml.read()
			else:
				if spriteXmlThumbnail in xml.get_attribute_value(0):
					xmlRegion(xml.get_current_line())
					finished = true
					print("Finished region")
				else:
					xml.read()
		print("Finished code")
	else:
		printerr("You forgot to input an XML or Region Image.")

func _ready():
	print(xml)
	xml.open(spriteXml)
	txtOffset.open(spriteXmlOffset)
	xmlThumbnailImage()
