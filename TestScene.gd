extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bullet_res := preload("res://GameObject/Bullets/Bullet.tscn")

var default_material := load("res://Materials/bullet_default.material")
var assult_material := load("res://Materials/bullet_assult.material")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera3D.set("followee", $Player)
	$Camera3D.set("following", true)
	
#	($Cube.inner_material as StandardMaterial3D).albedo_color = Color.WHITE
#	($Cube.middle_material as StandardMaterial3D).albedo_color = Color.WHITE
#	($Cube.outer_material as StandardMaterial3D).albedo_color = Color.TRANSPARENT
#	($Cube.surface_material as StandardMaterial3D).albedo_color = Color.TRANSPARENT
	
#	var cube = $Cube as Cube
#	cube.inner_color = Color.TRANSPARENT
#	cube.middle_color = Color.TRANSPARENT
#	cube.outer_color = Color.TRANSPARENT
#	cube.surface_color = Color.WHITE

	#$Bullet2.material = SpatialMaterial.new()
	

	pass # Replace with function body.

var n = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	n += delta;
	if n > 1.0: n -= 1.0
	#$Bullet2.color = Color(n, 1 - n, n)
	if Input.is_action_just_pressed("ui_accept"):
		shoot(256)
	if Input.is_action_just_pressed("ui_cancel"):
		clear_bullets()
	pass

func shoot(n : int) :
	for i in range(n):
		var b := bullet_res.instantiate() as Bullet
		b.initialize_bullet( \
			Surface.SURF_XPLUS, \
			Surface.to_vector(b.surface), \
			Vector3.UP, \
			TestBulletBehavior.new(b, Vector2(0, 1 / 254.0).rotated(i * 2 * PI / n)), \
			{} \
		)
#		b.color = Color.from_hsv(i / float(n), 1, 1.0, 0.25)
#		b.color = Color.WHITE if i % 2 == 0 else Color.RED
#		b.material = default_material
		b.material = default_material if i % 2 == 0 else assult_material
		b.add_to_group("bullets")
		self.add_child(b)
		pass

func clear_bullets():
	get_tree().notify_group("bullets", Bullet.NOTIFICATION_VANISH)
