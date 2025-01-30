extends RigidBody2D

func _ready() -> void:
	await owner.ready
	self.position = owner.position
	owner.position = Vector2.ZERO

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var parent = owner.get_parent() as NBodySimulation
	var bodies = parent.get_children() as Array[CelestialBody]
	var rbodies = bodies.map(func(b): return b.get_node("RigidBody2D") as RigidBody2D)
	var force = Vector2.ZERO
	
	for body in rbodies:
		if self == body:
			continue
			
		force += NBodySimulation.calculate_force(
			parent.gravitational_constant,
			self.mass,
			body.mass,
			self.position,
			body.position
		)

	state.linear_velocity += (force / self.mass) * state.step
