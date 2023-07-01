extends GameObject
class_name Bullet

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var material : Material setget set_material
var color    : Color    setget set_color
var state    : Dictionary = {}
#var behavior : FuncRef
var behavior : GDScriptFunctionState

var turn_count : int

var velocity2d : Vector2

func initialize_bullet(surf : int, pos : Vector3, forward : Vector3, beh : GDScriptFunctionState = null, initial_states : Dictionary = {}):
	surface = surf
	translation = pos
	forward_dir = forward

	behavior = beh
	state = initial_states
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_material(m : Material) -> void:
	material = m
	$BulletModel/obj1.material_override = material 
	var sm := material as SpatialMaterial
	if sm:
		color = sm.albedo_color 

func set_color(c : Color) -> void:
	color = c
	if material == null:
		# モデルのobj1のマテリアルを独自のものに置き換える
		material = $BulletModel/obj1.mesh.surface_get_material(0).duplicate()
		$BulletModel/obj1.material_override = material 
		
	var sm := material as SpatialMaterial
	if sm:
		sm.albedo_color = c
	pass

func update_direction():
	var dir := velocity.normalized()
	var cross := Vector3.FORWARD.cross(dir).normalized()
	var dot := Vector3.FORWARD.dot(dir)

	var sin_half = sqrt((1 - dot) / 2.0);
	var cos_half = sqrt((1 + dot) / 2.0);

	transform.basis = Basis(Quat(cross.x * sin_half, cross.y * sin_half, cross.z * sin_half, cos_half))

	# XMStoreFloat4x4(&rotMatrix, XMMatrixRotationQuaternion(q));

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if behavior and behavior.is_valid():
		var co_ret = behavior.resume(delta)
		behavior = co_ret as GDScriptFunctionState
		# コルーチンが return した場合はGDScriptFunctionState以外の型が返るためそこで終了となる
	
	var new_velocity := get_vector(velocity2d)
	if velocity != new_velocity:
		velocity = new_velocity
		update_direction()

	turn_count += move_object()
	pass


func _on_Area_area_entered(area):
	print("[Bullet] Collision: ", area)
	pass # Replace with function body.
