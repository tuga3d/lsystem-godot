tool
extends Node2D


func _draw():
	var points = get_parent().get_node("LSystem").points2d
	draw_multiline(points, Color(0, 0, 0))


func _on_LSystem_value_changed():
	update()
