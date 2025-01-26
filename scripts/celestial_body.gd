@tool
extends Node2D
class_name CelestialBody

@export var mass: float = 10:
	set(new_mass):
		mass = new_mass
		$RigidBody2D.mass = new_mass
		
@export var radius: float = 50:
	set(new_radius):
		radius = new_radius
		$RigidBody2D/CollisionShape2D.shape = CircleShape2D.new()
		$RigidBody2D/CollisionShape2D.shape.radius = new_radius
		$RigidBody2D/MeshInstance2D.mesh = SphereMesh.new()
		$RigidBody2D/MeshInstance2D.mesh.radius = new_radius
		$RigidBody2D/MeshInstance2D.mesh.height = new_radius * 2
		
@export var initial_velocity: Vector2

func _ready() -> void:
	$RigidBody2D.mass = self.mass
	$RigidBody2D.linear_velocity = self.initial_velocity
	$RigidBody2D/CollisionShape2D.shape = CircleShape2D.new()
	$RigidBody2D/CollisionShape2D.shape.radius = self.radius
	$RigidBody2D/MeshInstance2D.mesh = SphereMesh.new()
	$RigidBody2D/MeshInstance2D.mesh.radius = self.radius
	$RigidBody2D/MeshInstance2D.mesh.height = self.radius * 2
