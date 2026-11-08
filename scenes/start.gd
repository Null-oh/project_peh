extends CanvasLayer

func _on_scheme_pressed():
	get_tree().change_scene_to_file("res://scenes/schema.tscn")

func _on_furnace_pressed():
	get_tree().change_scene_to_file("res://scenes/control.tscn")

func _on_exit_pressed():
	get_tree().quit()
