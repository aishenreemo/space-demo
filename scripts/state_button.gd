extends Button

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	var tree = get_tree()
	self.text = "PAUSE" if tree.paused else "CONTINUE"
	get_tree().paused = !tree.paused
	
	var simulation = owner.get_node("Simulation")
	var bodies = simulation.get_children()
	for body in bodies:
		var trajectory = body.get_node("Trajectory2D")
		trajectory.visible = tree.paused
		if tree.paused:
			trajectory.clear_points()
