extends Camera2D

@export var maximum_zoom: Vector2 = Vector2(64.0, 64.0)
@export var minimum_zoom: Vector2 = Vector2(1.0 / 64.0, 1 / 64.0)
var is_dragging: bool

func _ready() -> void:
	var screen_size = get_viewport().size as Vector2
	var limit_rect = Vector2(
		self.limit_right - self.limit_left,
		self.limit_bottom - self.limit_top
	)
	
	self.maximum_zoom.x = min(self.maximum_zoom.x, (limit_rect / screen_size).x)
	self.maximum_zoom.y = min(self.maximum_zoom.y, (limit_rect / screen_size).y)
	self.minimum_zoom.x = max(self.minimum_zoom.x, (screen_size / limit_rect).x)
	self.minimum_zoom.y = max(self.minimum_zoom.y, (screen_size / limit_rect).y)

func _process(_delta: float) -> void:
	var screen_size = get_viewport().size
	var minimum_position = Vector2(
		0.5 * screen_size.x * (1.0 / self.zoom.x) + self.limit_left,
		0.5 * screen_size.y * (1.0 / self.zoom.y) + self.limit_top,
	)
	var maximum_position = Vector2(
		-0.5 * screen_size.x * (1.0 / self.zoom.x) + self.limit_right,
		-0.5 * screen_size.y * (1.0 / self.zoom.y) + self.limit_bottom,
	)
	
	self.position.x = clamp(self.position.x, minimum_position.x, maximum_position.x)
	self.position.y = clamp(self.position.y, minimum_position.y, maximum_position.y)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_dragging:
		self.position -= event.relative / self.zoom
	
	var delta_zoom = 1.05
	var old_position = get_global_mouse_position()
	var is_zoomed = false
	
	if event is InputEventMouseButton:
		if event.shift_pressed:
			delta_zoom = 1.1
		
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			self.is_dragging = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			self.zoom *= delta_zoom
			is_zoomed = true
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			self.zoom /= delta_zoom
			is_zoomed = true
	
	if !is_zoomed:
		return
	
	var new_position = get_global_mouse_position()
	if self.zoom * 1.00001 < self.maximum_zoom:
		self.global_position += old_position - new_position
	
	self.zoom = clamp(self.zoom, self.minimum_zoom, self.maximum_zoom)
