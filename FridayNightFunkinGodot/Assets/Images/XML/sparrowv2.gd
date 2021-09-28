tool

extends Sprite

var xml = XMLParser.new()
var txtOffset = File.new()

export var spriteXml : String = String("res://Assets/Images/XML/Spritesheet")
export var spriteXmlOffset : String = String("res://Assets/Images/XML/Spritesheet")
export var spriteXmlThumbnail : String

func xmlRegion():
	
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
					xmlRegion()
					finished = true
					print("Finished region")
				else:
					xml.read()
		print("Finished code")
	else:
		printerr("You forgot to input an XML or Region Image.")

func xmlRegionAnim(node : String, time : float):
	if ".xml" in spriteXml and not node == null:
		xml.open(spriteXml)
		var finished : bool = bool(false)
		while not finished == true:
			if not xml.get_node_name() == "SubTexture":
				print(xml.get_node_name())
				xml.read()
			else:
				if node in xml.get_attribute_value(0):
					xmlRegion()
					print(Engine.get_frames_per_second() / (time * Engine.get_frames_per_second()))
					while node in xml.get_attribute_value(0):
						yield(get_tree().create_timer(Engine.get_frames_per_second() / (time * Engine.get_frames_per_second())), "timeout")
						xmlRegion()
						print("Fard", xml.get_current_line())
					finished = true
					print("Finished animation")
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
					xmlRegion()
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
	if ".txt" in spriteXmlOffset:
		txtOffset.open(spriteXmlOffset)
	xmlThumbnailImage()
