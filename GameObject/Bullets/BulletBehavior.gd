extends RefCounted
class_name BulletBehavior

enum State {
	UNDEFINED = 0,
	INITIALIZED,
	RUNNING,
	FINISHED,
	ERROR,
}

var bullet : Bullet
var state : State = State.UNDEFINED

func _init(b : Bullet):
	bullet = b
	state = State.INITIALIZED

func step(delta) -> State:
	return state

func is_valid() -> bool:
	match state:
		State.INITIALIZED: return true
		State.RUNNING: return true
		_ : return false
