extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# ($Timer as Timer).connect("timeout", Callable(self, "_on_timer_timeout"))
	
	ResourceLoader.load_threaded_request("res://TestScene.tscn", "PackedScene")
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var state = ResourceLoader.load_threaded_get_status("res://TestScene.tscn")
	if state == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get("res://TestScene.tscn") as PackedScene)
	pass
