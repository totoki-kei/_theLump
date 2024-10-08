extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	($Timer as Timer).connect("timeout", Callable(self, "_on_timer_timeout"))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://TestScene.tscn")
	
