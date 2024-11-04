extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bullet_res := preload("res://GameObject/Bullets/Bullet.tscn")
var particle_res = preload("res://ExplosionParticle.tscn")


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
	
	var cube = $Cube as Cube
	cube.inner_color = Color.TRANSPARENT
	cube.middle_color = Color.TRANSPARENT
	cube.outer_color = Color.WHITE
	cube.surface_color = Color.TRANSPARENT

	#$Bullet2.material = SpatialMaterial.new()
	

	pass # Replace with function body.

var n = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
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


var camera_tween : Tween;

func _unhandled_input(event):
	if event.is_action(&"game_put"):
#		var particle := particle_res.instantiate() as Node3D
#		particle.position = $Player.position
#		add_child(particle)
		var cam := $Camera3D as Camera3D
		print_rich(cam.unproject_position($Player.position))
	if event.is_action_pressed("game_slowmo"):
		var cam := $Camera3D as Camera3D

		if camera_tween:
			camera_tween.kill()
		var tw := self.create_tween()
		tw.tween_property(cam, "fov", 30.0, 0.2)
		tw.set_ease(tw.EASE_OUT)
		tw.set_trans(tw.TRANS_QUAD)
		tw.play()
		camera_tween = tw;
	elif event.is_action_released("game_slowmo"):
		var cam := $Camera3D as Camera3D

		if camera_tween:
			camera_tween.kill()
		var tw := self.create_tween()
		tw.tween_property(cam, "fov", 60.0, 0.2)
		tw.set_ease(tw.EASE_OUT)
		tw.set_trans(tw.TRANS_QUAD)
		tw.play()
		camera_tween = tw;

	var key_event := event as InputEventKey
	if key_event && key_event.pressed && key_event.keycode == KEY_X:
		var particle = particle_res.instantiate() as ExplosionParticle
		particle.start($Player.position, Color.RED, assult_material, 16)
		self.add_child(particle)
		pass
	pass


func _on_spawn_timer_timeout():
	var surf := Surface.invert(($Player as GameObject).surface)
	assert(surf != Surface.SURF_NONE)
	var pos := Surface.get_random_point(surf);

	var vel := Vector2.UP.rotated(randf_range(0, 360)) / 120.0;

	var forward = Vector3.UP
	if surf == Surface.SURF_YPLUS or surf == Surface.SURF_YMINUS:
		forward = Vector3.LEFT

	var b : Bullet = bullet_res.instantiate()
	#b.initialize_bullet(surf, pos, forward, TestBulletBehavior.new(b, vel), {})
	b.initialize_bullet(surf, pos, forward, HomingBulletBehavior.new(b, vel), {})
	b.material = default_material
	b.add_to_group("bullets")
	self.add_child(b)
	pass # Replace with function body.
