extends BulletBehavior
class_name BasicBulletBehavior

func _init(b : Bullet, vel : Vector2):
	super(b)
	b.velocity2d = vel

#func step(delta) -> State :
	#return super(delta)
	
