extends CheckBox

@onready var image = $"image"
var mendeleev

func _ready():
	image.visible = false
	mendeleev = image.find_child("mendeleev")
	if mendeleev:
		mendeleev.visible = false

func _process(delta):
	if self.button_pressed:
		image.visible = true
	else:
		image.visible = false

func _on_image_pressed():
	var sound = $"image/AudioStreamPlayer2D"
	if sound:
		sound.playing = true
	
	var tween : Tween = create_tween()
	mendeleev.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	mendeleev.visible = true
	tween.tween_property(mendeleev, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.4)
	tween.tween_property(mendeleev, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.4)
