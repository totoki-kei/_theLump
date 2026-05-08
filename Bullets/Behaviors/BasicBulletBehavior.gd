extends BulletBehavior
class_name BasicBulletBehavior

## 基本的なBulletの動作を定義するクラス
## 動作はBulletBehaviorの既定の動作を継承する(直線運動)

func _init(b : Bullet, vel : Vector2):
	super(b)
	b.velocity2d = vel

#func step(delta) -> State :
	#return super(delta)
	
