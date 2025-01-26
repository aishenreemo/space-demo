extends Node2D
class_name NBodySimulation

@export var prediction_duration: float = 5.0
@export var gravitational_constant: float = 100

func _ready() -> void:
	await owner.ready
	for body in self.get_children() as Array[CelestialBody]:
		await body.ready

func _physics_process(delta: float) -> void:
	var bodies = self.get_children() as Array[CelestialBody]
	var trj_map_fn = func(b): return b.get_node("Trajectory2D") as Line2D
	var trajectories = bodies.map(trj_map_fn)
	var time_step = delta * 0.5
	
	if bodies.size() != trajectories.size():
		push_error("Body and trajectory sizes mismatch.")
	
	if bodies.size() == 0: # No celestial bodies yet
		push_warning("No celestial bodies on the simulation yet.")
		return
	
	if trajectories.all(func(t): return t.points.size() != 0):
		return
		
	var current_time = 0.0
	var rmap_fn = func(b): return b.get_node("RigidBody2D") as RigidBody2D
	var mmap_fn = func(b: CelestialBody): return float(b.mass) as float
	var pmap_fn = func(r: RigidBody2D): return r.global_position as Vector2
	var vmap_fn = func(r: RigidBody2D): return r.linear_velocity as Vector2
	var rbodies = bodies.map(rmap_fn)
	var masses = bodies.map(mmap_fn)
	var positions = rbodies.map(pmap_fn)
	var velocities = rbodies.map(vmap_fn)
	
	while current_time < self.prediction_duration:
		var forces = NBodySimulation.calculate_forces(
			self.gravitational_constant,
			masses,
			positions
		)
		for i in forces.size():
			velocities[i] += (forces[i] / masses[i]) * time_step
			positions[i] += velocities[i] * delta
			trajectories[i].add_point(positions[i])
		
		current_time += time_step

static func calculate_forces(
	gc: float,
	masses: Array,
	positions: Array,
) -> Array[Vector2]:
	var length = masses.size()
	var out: Array[Vector2] = []
	
	if masses.size() != positions.size():
		push_error("Positions and masses array size mismatch.")
	
	for a in length:
		var mass_a = masses[a]
		var pos_a = positions[a]
		var force = Vector2.ZERO
		
		for b in length:
			var mass_b = masses[b]
			var pos_b = positions[b]
			
			if a == b:
				continue
			
			force += NBodySimulation.calculate_force(gc, mass_a, mass_b, pos_a, pos_b)
		
		out.push_back(force)
		
	if out.size() != positions.size():
		push_error("Output size mismatch.")
		
	return out

static func calculate_force(
	gc: float,
	mass_a: float,
	mass_b: float,
	pos_a: Vector2,
	pos_b: Vector2,
) -> Vector2:
	var distance_sqrd = pos_b.distance_squared_to(pos_a)
	var direction = (pos_b - pos_a).normalized()
	return direction * ((gc * mass_b * mass_a) / distance_sqrd)
