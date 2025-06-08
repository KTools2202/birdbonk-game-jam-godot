extends Area2D

@export_file("*.tscn") var next_level_scene : String  # Drag your next level scene here

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		Levelmanager.go_to_next_level()
