extends Control

var sliders
var variable_labels
var results_labels
var boxes
@onready var fuel_choice = $NinePatchRect/MarginContainer/HBoxContainer/VBoxContainer/header/fuel
@onready var q_text = $NinePatchRect/MarginContainer/HBoxContainer/VBoxContainer/vars/MarginContainer/vbox/q/TextEdit
@onready var fuel_icon = $NinePatchRect/MarginContainer/HBoxContainer/VBoxContainer/header/icon

@export var coal_icon = preload("res://img/Coal_JE4_BE3.png")
@export var wood_icon = preload("res://img/Birch_Planks.png")

@onready var overflow: Label = $NinePatchRect/MarginContainer/HBoxContainer/VBoxContainer/header/overflow

func _ready():
	sliders = find_children("*", "HSlider", true, false)
	for i in sliders:
		i.value_changed.connect(update_values_on_screen)
	
	variable_labels = find_children("value", "Label", true, false)
	results_labels = find_children("result", "Label", true, false)
	
	boxes = find_children("box", "CheckBox", true, false)
	
	q_text.text = str(snapped(Global.variables["q"], 0.1))
	
	overflow.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	Global.overflow.connect(on_overflow)

func on_overflow():
	overflow.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(overflow, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	tween.tween_property(overflow, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.1)
	tween.tween_property(overflow, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	tween.tween_property(overflow, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.1)
	

func update_values_on_screen(_new_value : float):
	for k in sliders:
		Global.read(k.get_parent())
	
	Global.count()
	
	for i in variable_labels:
		Global.write(i)
	
	for j in results_labels:
		Global.write(j)

func _on_fuel_item_selected(index):
	Global.fuel = fuel_choice.get_item_text(index)
	
	match fuel_choice.get_item_text(index):
		"coal": fuel_icon.texture = coal_icon
		"wood": fuel_icon.texture = wood_icon
	
	Global.set_fuel()
	for i in sliders:
		Global.apply_bounds(i)

func _on_text_edit_text_changed():
	Global.read(q_text.get_parent())
	Global.count()
