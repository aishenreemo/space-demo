extends Line2D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	self.width = 1.0 / $/root/Main/Camera2D.zoom.x
