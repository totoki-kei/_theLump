extends BulletBehavior
class_name TestBulletBehavior

var last_turn_count : int

func _init(b : Bullet, vel : Vector2):
	super(b)
	b.velocity2d = vel
	last_turn_count = b.turn_count


func step(delta):
	if bullet.turn_count != last_turn_count:
		last_turn_count = bullet.turn_count
	return State.RUNNING
	
