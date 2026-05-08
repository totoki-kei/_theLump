extends GPUParticles3D
class_name ExplosionParticle

var started := false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$OmniLight3D.light_energy -= delta * 2
	if started == true and emitting == false:
		queue_free()
	pass

func start(pos : Vector3, light_color : Color, particle_material : Material, particle_num : int = 32):
	self.position = pos
	if particle_material != null:
		self.draw_pass_1.surface_set_material(0, particle_material)
	self.amount = particle_num

	self.emitting = true
	started = true;
	pass
