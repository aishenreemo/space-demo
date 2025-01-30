extends Node2D

func _ready() -> void:
	get_tree().paused = true
	$CanvasLayer.show()

func _process(delta: float) -> void:
	pass
