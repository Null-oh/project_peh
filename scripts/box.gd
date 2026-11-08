extends CheckBox

@onready var image = $"image"
var mendeleev

@onready var screenshot_node = $"../../../../../formula"
@onready var screenshot_label = $"../../../../../source"
@export var screenshot_image : Texture2D
@export var source_text : String

func _ready():
	image.visible = false
	mendeleev = image.find_child("mendeleev")
	if mendeleev:
		mendeleev.visible = false
	
	if !screenshot_node:
		print("On box ", self.name, " image node not found")
		print("=====")
	else:
		#screenshot_label = screenshot_node.find_child("source")
		if !screenshot_label:
			print("On box ", self.name, " label node not found")
			print("=====")
	

func _process(delta):
	#if self.button_pressed:
		#image.visible = true
	#else:
		#image.visible = false
	pass

func _on_button_down():
	if !screenshot_node:
		return
	if ! screenshot_image:
		return
	
	screenshot_node.texture = screenshot_image
	screenshot_label.text = source_text

func _on_button_up():
	pass # Replace with function body.

#менделеев хихи хаха
func _on_image_pressed():
	var sound = $"image/AudioStreamPlayer2D"
	if sound:
		sound.playing = true
	
	var tween : Tween = create_tween()
	mendeleev.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	mendeleev.visible = true
	tween.tween_property(mendeleev, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.4)
	tween.tween_property(mendeleev, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.4)
