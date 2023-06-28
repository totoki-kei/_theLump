extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rx := 0.0
var ry := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rx += delta * Input.get_axis("game_left", "game_right")
	ry += delta * Input.get_axis("game_up", "game_down")
	
	rx = wrapf(rx, -PI, PI)
	ry = clamp(ry, -PI / 2, PI / 2)
	
	#self.translation = Basis(Vector3(dy, dx, 0)).xform(self.translation)
	self.translation = Vector3(0, 0, 3).rotated(Vector3.RIGHT, ry).rotated(Vector3.UP, rx)
	self.look_at(Vector3.ZERO, Vector3.UP)
	
	pass

