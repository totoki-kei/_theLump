extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dx = Input.get_axis("game_left", "game_right") / 360
	var dy = Input.get_axis("game_down", "game_up") / 360
	
	self.translation = Basis(Vector3(dy, dx, 0)).xform(self.translation)
	self.look_at(Vector3.ZERO, Vector3.UP)
	
	pass

