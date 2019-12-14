tool
extends ImmediateGeometry


func _ready():
	if Engine.editor_hint:
		draw()

func draw():
	var points = get_parent().get_node("LSystem").points3d
	clear()
	begin(Mesh.PRIMITIVE_LINES)
	for point in points:
		add_vertex(point)
	end()

func _on_LSystem_value_changed():
	draw()
