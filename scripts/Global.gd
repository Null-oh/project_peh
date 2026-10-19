extends Node

var fuel : String

var bounds = {
	"cpmin" : 0.0,
	"cpmax" : 0.0,
	"hpmin" : 0.0,
	"hpmax" : 0.0,
	"opmin" : 0.0,
	"opmax" : 0.0,
	"spmin" : 0.0,
	"spmax" : 0.0,
	"npmin" : 0.0,
	"npmax" : 0.0,
	"wpmin" : 0.0,
	"wpmax" : 0.0,
	"omegamax" : 10.0,
	"omegamin" : 0.5,
	"numax" : 100.0,
	"numin" : 0.0,
}

var material_stats = {
	"cp": 0.0,
	"hp": 0.0,
	"op": 0.0,
	"sp": 0.0,
	"np": 0.0,
	"wp": 0.0
}

var variables = {
	"q": 20.0,
	"omega": 0.1,
	"nu": 0.1
}

var results = {
	"v0v" : 0.0,
	"v0g" : 0.0,
	"qpn" : 0.0,
	"b" : 0.0,
	"v" : 0.0,
	"f" : 0.0
}

func apply_bounds(slider : HSlider): #по сигналу изменения переменной топлива
	print("Global.apply_bounds() called on: ", slider.get_parent().name)
	
	var parent = slider.get_parent()
	
	if bounds.has(parent.name + "max"):
		slider.max_value = bounds[parent.name + "max"]
	if bounds.has(parent.name + "min"):
		slider.min_value = bounds[parent.name + "min"]
	
	print("Set bounds: max = ", slider.max_value, ", min = ", slider.min_value)
	print("==========")

func set_fuel(): 
	print("Global.set_fuel() called")
	match fuel:
		"coal": 
			bounds["cpmin"] = 75.0
			bounds["cpmax"] = 92.0
			
			bounds["hpmin"] = 2.5
			bounds["hpmax"] = 5.7
			
			bounds["opmin"] = 1.5
			bounds["opmax"] = 15.0
			
			bounds["spmin"] = 0.0
			bounds["spmax"] = 4.0
			
			bounds["npmin"] = 1.0
			bounds["npmax"] = 3.0
			
			bounds["wpmin"] = 6.0
			bounds["wpmax"] = 18.0
		"wood":  
			bounds["cpmin"] = 49.0
			bounds["cpmax"] = 51.0
			
			bounds["hpmin"] = 6.0
			bounds["hpmax"] = 7.0
			
			bounds["opmin"] = 42.0
			bounds["opmax"] = 44.0
			
			bounds["spmin"] = 0.0
			bounds["spmax"] = 0.0
			
			bounds["npmin"] = 0.1
			bounds["npmax"] = 0.7
			
			bounds["wpmin"] = 0.0
			bounds["wpmax"] = 80.0
	
	print("==========")

signal overflow

func read(parent): #считать значение со слайдера или строки
	#var variable = parent.name #имя переменной
	
	for i in parent.get_children():
		
		if i.name == "HSlider": #слайдер со значением
			if material_stats.has(parent.name): #имя переменной
				material_stats[parent.name] = i.value
			
			elif variables.has(parent.name): #если слайдер - точно не q
				variables[parent.name] = i.value #значение переменной
		
		elif i.name == "TextEdit": #q
			if i.text.is_valid_float():
				variables[parent.name] = float(i.text)
		
		if check_overflow():
			overflow.emit()

func check_overflow() -> bool:
	var sum : float = 0.0
	for i in material_stats:
		sum += material_stats[i]
	sum -= material_stats["wp"]
	
	if sum >= 100.0:
		return true
	return false

func write(label: Label):
	var parent = label.get_parent()
	
	if material_stats.has(parent.name):
		label.text = str(snapped(material_stats[parent.name], 0.1)) + "%"
	
	if variables.has(parent.name):
		match parent.name:
			"q": label.text = str(snapped(variables[parent.name], 0.1)) + " кВт"
			"omega": label.text = str(snapped(variables[parent.name], 0.1)) + " м/с"
			"nu": label.text = str(snapped(variables[parent.name], 0.1)) + "%"
		
	
	if results.has(parent.name):
		match(parent.name):
			"v0v" : label.text = str(snapped(results[parent.name], 0.001))
			"v0g" : label.text = str(snapped(results[parent.name], 0.001))
			"qpn" : label.text = str(snapped(results[parent.name], 0.001))
			"b" : label.text = str(snapped(results[parent.name] * 3600, 0.001))
			"v" : label.text = str(snapped(results[parent.name], 0.001))
			"f" : label.text = str(snapped(results[parent.name] * 10000, 0.001))

func count():
	results["v0v"] = 0.0889 * (material_stats["cp"] + 0.375 * material_stats["sp"]) + 0.265 * material_stats["hp"] - 0.0333 * material_stats["op"]
	
	results["v0g"] = 0.0187 * (material_stats["cp"] + 0.375 * material_stats["sp"]) + \
	0.79 * results["v0v"] + 0.008 * material_stats["np"] + \
	0.111 * material_stats["hp"] + 0.0124 * material_stats["wp"] + 0.0161 * results["v0v"]
	
	results["qpn"] = 339.4 * material_stats["cp"] + 1257.0 * material_stats["hp"] - \
	108.9 * (material_stats["op"] + material_stats["np"] - material_stats["sp"]) - \
	25.1 * (9.0 * material_stats["hp"] + material_stats["wp"])
	
	results["b"] = variables["q"] / (results["qpn"] * (variables["nu"] / 100.0))
	
	results["v"] = results["b"] * results["v0g"]
	
	results["f"] = results["v"] / variables["omega"]
	
	print("Global: counted")
	print(results)
	print("==========")
	
	
