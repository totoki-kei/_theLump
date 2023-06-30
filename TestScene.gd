extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bullet_res := preload("res://Bullet.tscn")

static func dummy_bullet_behavior(b : Bullet, vel : Vector2):
	b.velocity2d = vel
	var last_turn_count = b.turn_count
	while true:
		var _delta = yield()
		if b.turn_count != last_turn_count:
			last_turn_count = b.turn_count
			b.velocity2d *= 3.0 / 2.0
			if b.velocity2d.length() > 0.5:
				b.velocity2d = b.velocity2d.normalized() * 0.5
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera.set("followee", $Player)
	$Camera.set("following", true)
	
	# ($Cube.inner_material as SpatialMaterial).albedo_color = Color.white
	# ($Cube.middle_material as SpatialMaterial).albedo_color = Color.white
	# ($Cube.outer_material as SpatialMaterial).albedo_color = Color.transparent
	# ($Cube.surface_material as SpatialMaterial).albedo_color = Color.transparent

	#$Bullet2.material = SpatialMaterial.new()
	

	pass # Replace with function body.

var n = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	n += delta;
	if n > 1.0: n -= 1.0
	#$Bullet2.color = Color(n, 1 - n, n)
	if Input.is_action_just_pressed("ui_accept"):
		shoot(6)
	pass

func shoot(n : int) :
	for i in range(n):
		var b := bullet_res.instance() as Bullet
		b.initialize_bullet( \
			Surface.SURF_XPLUS, \
			Surface.to_vector(b.surface), \
			Vector3.UP, \
			dummy_bullet_behavior(b, Vector2(0, 1 / 254.0).rotated(i * 2 * PI / n)) as GDScriptFunctionState, \
			{} \
		)
		b.color = Color.from_hsv(i / float(n), 0.75, 1, 0.25)
		b.add_to_group("bullets")
		self.add_child(b)
		pass
