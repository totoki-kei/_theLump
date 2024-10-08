extends GameObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# 移動速度
var SPEED = 1.0 / 64
var SPEED_SLOWMO = SPEED / 2.0
#var SPEED_TURBO = 3.0 / 64

# Called when the node enters the scene tree for the first time.
func _ready():
	forward_dir = Vector3.UP
	surface = Surface.from_vector(position)
	assert(surface != Surface.SURF_NONE) # どこかに乗っててほしい


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	var speed = SPEED_SLOWMO if Input.is_action_pressed("game_slowmo") \
		   else SPEED
	var dx = Input.get_axis("game_left", "game_right") * speed
	var dy = Input.get_axis("game_down", "game_up") * speed

	var dx2 = dx * forward_dir.cross(Surface.to_normal(surface))
	var dy2 = dy * forward_dir
	
	velocity = dx2 + dy2

	move_object()
	


func _on_Area_area_entered(area):
	print("[Player] Collision: ", area)
	pass # Replace with function body.
