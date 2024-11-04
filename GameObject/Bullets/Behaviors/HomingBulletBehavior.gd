extends BulletBehavior
class_name HomingBulletBehavior

const HOMING_VELOCITY_MULTIPLIER := 0.8;
const ANGLE_DELTA := PI / 120.0

var in_chase := false
var base_speed : float

func _init(b : Bullet, vel : Vector2):
	super(b)
	base_speed = vel.length()

	bullet.angle2d = vel.angle()
	bullet.speed2d = base_speed
	bullet.angle_and_speed_mode = true

func step(delta) -> State :
	var player = Player.get_current_instance()
	var on_same_surface : bool = (player != null) and (player.surface == bullet.surface)
	
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
		# bullet基準で見た時のベクトル
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

	
	return super(delta)
	
