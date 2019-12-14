tool
extends Node

class_name LSystem, "res://lsystem/icon.svg"

signal value_changed

export (String, FILE, '*.json') var _jsonfile: String setget _set_jsonfile
export (String) var axiom: String setget _set_axiom
export (Dictionary) var productions: Dictionary setget _set_productions
export (int) var iterations: int = 1 setget _set_iterations
export (float) var angle: float = 90 setget _set_angle
export (float) var length: float = 1 setget _set_length

var result: String setget ,_get_result
var points2d: Array setget ,_get_points2d
var points3d: Array setget ,_get_points3d


func _set_jsonfile(value: String) -> void:
	_jsonfile = value
	if Engine.editor_hint and _jsonfile:
		var file = File.new()
		file.open(value, file.READ)
		var json_result = JSON.parse(file.get_as_text()).result
		file.close()
		axiom = json_result['axiom']
		productions = json_result['productions']
		iterations = json_result['iterations']
		angle = json_result['angle']
		property_list_changed_notify()
		emit_signal("value_changed")

func _set_axiom(value: String) -> void:
	axiom = value
	emit_signal("value_changed")


func _set_productions(value: Dictionary) -> void:
	productions = value
	emit_signal("value_changed")


func _set_iterations(value: int) -> void:
	iterations = value
	emit_signal("value_changed")


func _set_angle(value: float) -> void:
	angle = value
	emit_signal("value_changed")


func _set_length(value: float) -> void:
	length = value
	emit_signal("value_changed")


func _get_result() -> String:
	result = self.axiom
	for _iter in range(self.iterations):
		var temp: String = ''
		for character in result:
			if character in self.productions:
				temp += self.productions[character]
			else:
				temp += character
		result = temp
	return result


func _get_points2d() -> Array:
	points2d = []
	var current_point: Vector2 = Vector2.ZERO
	var direction: Vector2 = Vector2(1, 0)
	var stack: Array = []
	for character in self.result:
		match character:
			'F':
				points2d.append(current_point)
				current_point += length * direction
				points2d.append(current_point)
			'f':
				current_point += length * direction
			'+':
				direction = direction.rotated(deg2rad(-self.angle))
			'-':
				direction = direction.rotated(deg2rad(self.angle))
			'[':
				stack.push_back(current_point)
				stack.push_back(direction)
			']':
				direction = stack.pop_back()
				current_point = stack.pop_back()
	return points2d


func _get_points3d() -> Array:
	points3d = []
	var current_point: Vector3 = Vector3.ZERO
	var direction: Vector3 = Vector3(1, 0, 0)
	var stack: Array = []
	for character in self.result:
		match character:
			'F':
				points3d.append(current_point)
				current_point += length * direction
				points3d.append(current_point)
			'f':
				current_point += length * direction
			'+':
				direction = direction.rotated(Vector3(0,0,1), deg2rad(self.angle))
			'-':
				direction = direction.rotated(Vector3(0,0,1), deg2rad(-self.angle))
			'^':
				pass
			'&':
				pass
			'\\':
				pass
			'/':
				pass
			'|':
				pass
			'[':
				stack.push_back(current_point)
				stack.push_back(direction)
			']':
				direction = stack.pop_back()
				current_point = stack.pop_back()
	return points3d

