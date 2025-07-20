extends Area2D

@export var speed: float = 800.0
@export var damage: int = 10  # ✅ Arrow damage amount

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var start_position: Vector2

const COLLISION_LAYER_MASK = 1 << 11  # Same as your terrain layer

func _ready() -> void:
	start_position = global_position

func _process(delta: float) -> void:
	position += velocity * delta

	if global_position.distance_to(start_position) > 1200:
		queue_free()

	if should_reset():
		queue_free()

func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()
	velocity = direction * speed
	rotation = dir.angle()

func should_reset() -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = global_position + direction * 20
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.collision_mask = COLLISION_LAYER_MASK
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result:
		print("Arrow hit wall: ", result.collider)
		return true
	return false

func _on_body_entered(body: Node2D) -> void:
	print("Body entered:", body.name)

	if body.is_in_group("player"):
		var health_node = body.get_node_or_null("Health")
		if health_node:
			print("Player hit! Taking damage.")
			health_node.take_damage(damage)
		else:
			print("Player has no Health node.")
		queue_free()  # Destroy the arrow
