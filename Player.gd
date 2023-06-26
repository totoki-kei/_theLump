extends GameObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# 移動速度
var speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	forward_dir = Vector3.UP
	surface = Surface.from_vector(translation)
	assert(surface != Surface.SURF_NONE) # どこかに乗っててほしい


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var dx = Input.get_axis("game_left", "game_right") / 30
	var dy = Input.get_axis("game_down", "game_up") / 30
	# var dx = 1.0 / 128
	# var dy = 1.5 / 128
	
	var dx2 = dx * forward_dir.cross(Surface.to_normal(surface))
	var dy2 = dy * forward_dir
	
	velocity = dx2 + dy2

	move_object()
	
	print(translation, " / ", surface)

