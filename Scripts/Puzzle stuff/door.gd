extends Area2D


func _ready():
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D):
	print("Body entered:", body.name)

	if body.is_in_group("player"):
		print("Player entered door. Going to next level...")
		LevelManager.go_to_next_level()
