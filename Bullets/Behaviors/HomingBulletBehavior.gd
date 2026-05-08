extends BulletBehavior
class_name HomingBulletBehavior

## ホーミング弾の動作を定義するクラス
## 基本的な動作はBasicBulletBehaviorを継承する
## プレイヤーが同一平面上にいる場合にホーミング動作を行う

## ホーミング中の速度倍率
const HOMING_VELOCITY_MULTIPLIER := 0.8;
## ホーミング中の回頭速度(radian)
const ANGLE_DELTA := PI / 120.0

var in_chase := false
var base_speed : float

func _init(b : Bullet, vel : Vector2):
	super(b)
	base_speed = vel.length()
	
	# 速さの変更と回頭動作があるため、角度と速さで設定
	bullet.angle2d = vel.angle()
	bullet.speed2d = base_speed
	bullet.angle_and_speed_mode = true

func step(delta) -> void :
	var player = Player.get_current_instance()
	var on_same_surface : bool = (player != null) and (player.surface == bullet.surface)

	# ホーミング状態の更新
	if on_same_surface and not in_chase:
		# ホーミング開始
		print(self, "start homing")
		in_chase = true
		bullet.set_rotation_speed(3.0)
		bullet.speed2d = base_speed * HOMING_VELOCITY_MULTIPLIER
	elif not on_same_surface and in_chase:
		# ホーミング解除
		print(self, "end homing")
		in_chase = false
		bullet.set_rotation_speed(1.0)
		bullet.speed2d = base_speed
	
	if in_chase and player:
		var direction = bullet.get_vector2d_from_3d(player.position - bullet.position)
		var angle := direction.angle()
		var angle_delta := angle_difference(bullet.angle2d, angle)
		
		if angle_delta < -ANGLE_DELTA:
			#print("%s {%2.3f, %2.3f} (%2.3f, %2.3f) ANGLE--" % [self, direction.x, direction.y, angle, bullet.angle2d])
			bullet.angle2d -= ANGLE_DELTA
		elif ANGLE_DELTA < angle_delta:
			#print("%s {%2.3f, %2.3f} (%2.3f, %2.3f) ANGLE++" % [self, direction.x, direction.y,angle, bullet.angle2d])
			bullet.angle2d += ANGLE_DELTA
		else:
			#print("%s {%2.3f, %2.3f} (%2.3f, %2.3f) ANGLE==" % [self, direction.x, direction.y,angle, bullet.angle2d])
			bullet.angle2d = angle

	super(delta)
	
