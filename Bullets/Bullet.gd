extends GameObject
class_name Bullet

var material : Material: set = set_material
var color    : Color: set = set_color
var state    : Dictionary = {}
var behavior : BulletBehavior

var turn_count : int

## 移動ベクトルを angle2d と speed2d から生成する場合は true
## 移動ベクトルとして velocity2d を直接使用する場合は false
var angle_and_speed_mode : bool = false

var velocity2d : Vector2
var angle2d : float
var speed2d : float

const NOTIFICATION_VANISH = 0x1000_0001

signal bullet_collide(bullet : Bullet, opposite : Area3D)

## Bulletを初期化する
## surf : 初期Surface
## pos : 初期座標 必ずsurf上の点である必要がある
## forward : 前方向を表すベクトル 必ずsurfと平行である必要がある
## beh : (optional)ビヘイビア
## initial_state : (optional)初期内部ステート
func initialize_bullet(surf : int, pos : Vector3, forward : Vector3, beh : BulletBehavior = null, initial_states : Dictionary = {}):
	surface = surf
	position = pos
	forward_dir = forward

	behavior = beh
	state = initial_states
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
#	var anim = $AnimationPlayer as AnimationPlayer
#	anim.play("Idle")
	
	pass # Replace with function body.

## Bulletのマテリアルを設定
func set_material(m : Material) -> void:
	material = m
	$BulletModel/obj1.material_override = material 
	var sm := material as StandardMaterial3D
	if sm:
		color = sm.albedo_color 

## 色を指定してBulletのマテリアルを設定
func set_color(c : Color) -> void:
	color = c
	if material == null:
		# モデルのobj1のマテリアルを独自のものに置き換える
		material = $BulletModel/obj1.mesh.surface_get_material(0).duplicate()
		$BulletModel/obj1.material_override = material 
		
	var sm := material as StandardMaterial3D
	if sm:
		sm.albedo_color = c
	pass

## 回転アニメーションの速度を設定する
func set_rotation_speed(multiplier : float):
	$AnimationPlayer.speed_scale = multiplier

# 3Dモデルの回転Basisを更新する
func update_direction():
	var dir := velocity.normalized()
	var cross := Vector3.FORWARD.cross(dir).normalized()
	var dot := Vector3.FORWARD.dot(dir)

	var sin_half = sqrt((1 - dot) / 2.0);
	var cos_half = sqrt((1 + dot) / 2.0);

	transform.basis = Basis(Quaternion(cross.x * sin_half, cross.y * sin_half, cross.z * sin_half, cos_half))

	# XMStoreFloat4x4(&rotMatrix, XMMatrixRotationQuaternion(q));

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# ビヘイビアのステップ実行
	if behavior and behavior.is_valid():
		behavior.step(delta)
	
	var new_velocity := get_vector_from_angle_length(angle2d, speed2d) if angle_and_speed_mode \
				   else get_vector(velocity2d)
	if velocity != new_velocity:
		velocity = new_velocity
		update_direction()

	turn_count += move_object()
	pass


func _on_Area_area_entered(area: Area3D):
	print("[Bullet] Collision: ", area)
	emit_signal(&"bullet_collide", self, area)
	pass # Replace with function body.

func _notification(what):
	if what == NOTIFICATION_VANISH:
		# 必要に応じてここにパーティクル生成などを追加
		self.queue_free()
