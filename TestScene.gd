extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bullet_res := preload("res://Bullet.tscn")

func dummy_bullet_behavior(b : Bullet, delta : float):
	if b.state.has("velocity"):
		var new_velocity := b.get_vector(b.state["velocity"] as Vector2)
		if b.velocity != new_velocity:
			b.velocity = new_velocity
			b.update_direction()
	#print(b.translation, " / ", b.velocity, " : ", b.surface)
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
	
	for i in range(360):
		var b := bullet_res.instance() as Bullet
		b.initialize_bullet( \
			Surface.SURF_XPLUS, \
			Surface.to_vector(b.surface), \
			Vector3.UP, \
			funcref(self, "dummy_bullet_behavior"), \
			{ "velocity" : Vector2(0, 1 / 254.0).rotated(i * 2 * PI / 360)} \
		)
		b.color = Color.from_hsv(i / 360.0, 0.75, 1, 0.25)
		b.add_to_group("bullets")
		self.add_child(b)
		pass

	pass # Replace with function body.

var n = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	n += delta;
	if n > 1.0: n -= 1.0
	#$Bullet2.color = Color(n, 1 - n, n)
	pass
