extends Camera2D

@export var control_node: Control
var is_dragging: bool

func _get_configuration_warnings() -> PackedStringArray:
	if control_node != null:
		return ["Control node is missing."]
	return []

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_dragging:
		self.position -= event.relative / self.zoom
		var screen_size = get_viewport().size as Vector2
		self.control_node.position = self.position - screen_size / 2
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			self.is_dragging = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			self.zoom += Vector2(0.005, 0.005)
			self.zoom = clamp(zoom, Vector2(0.01, 0.01), Vector2(20.0, 20.0))
			self.control_node.scale = Vector2.ONE / self.zoom
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			self.zoom -= Vector2(0.005, 0.005)
			self.zoom = clamp(zoom, Vector2(0.1, 0.1), Vector2(20.0, 20.0))
			self.control_node.scale = Vector2.ONE / self.zoom
