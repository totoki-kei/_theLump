#extends Node
extends Object
class_name Surface

enum {
	SURF_XPLUS,
	SURF_XMINUS,
	SURF_YPLUS,
	SURF_YMINUS,
	SURF_ZPLUS,
	SURF_ZMINUS,
	SURF_NONE = -1,
}



static func invert(surf : int) -> int:
	return surf ^ 0x01

static func is_paralell(a : int, b : int) -> bool:
	return (a & 0xFE) == (b & 0xFE)

static func to_plus(surf: int) -> int:
	return surf & (~0x01)

static func to_minus(surf: int) -> int:
	return surf | 0x01

static func get_random_point(surf : int) -> Vector3:
	# 稜線に近すぎると問題が起きるため少し間隔を空ける
	var a = rand_range(-0.95, 0.95)
	var b = rand_range(-0.95, 0.95)

	if surf == SURF_NONE:
		surf = randi() % 6

	match surf:
		SURF_XPLUS, SURF_XMINUS:
			return Vector3(0, a, b) + to_normal(surf)
		SURF_YPLUS, SURF_YMINUS:
			return Vector3(b ,0, a) + to_normal(surf)
		SURF_ZPLUS, SURF_ZMINUS:
			return Vector3(a, b, 0) + to_normal(surf)
		_:
			return Vector3.ZERO


static func to_plane(surf : int) -> Plane:
	return Plane(to_normal(surf), 1)

static func to_vector(surf : int) -> Vector3:
	match surf:
		SURF_XPLUS: return Vector3(1, 0, 0)
		SURF_YPLUS: return Vector3(0, 1, 0)
		SURF_ZPLUS: return Vector3(0, 0, 1)
		SURF_XMINUS: return Vector3(-1, 0, 0)
		SURF_YMINUS: return Vector3(0, -1, 0)
		SURF_ZMINUS: return Vector3(0, 0, -1)
		_: return Vector3.ZERO # TODO

static func to_normal(surf : int) -> Vector3:
	return to_vector(surf)

static func from_vector(pos : Vector3) -> int:
	if pos.x == 1.0: return SURF_XPLUS
	if pos.y == 1.0: return SURF_YPLUS
	if pos.z == 1.0: return SURF_ZPLUS
	if pos.x == 1.0: return SURF_XMINUS
	if pos.y == 1.0: return SURF_YMINUS
	if pos.z == 1.0: return SURF_ZMINUS
	return SURF_NONE # TODO

static func v2_to_v3(dir : Vector2) -> Vector3:
	assert(false, "not implemented")
	return Vector3.ZERO # TODO

static func get_neighbors(surf : int) -> Array:
	match surf:
		SURF_XPLUS, SURF_XMINUS: return [SURF_YPLUS, SURF_YMINUS, SURF_ZPLUS, SURF_ZMINUS]
		SURF_YPLUS, SURF_YMINUS: return [SURF_ZPLUS, SURF_ZMINUS, SURF_XPLUS, SURF_XMINUS]
		SURF_ZPLUS, SURF_ZMINUS: return [SURF_XPLUS, SURF_XMINUS, SURF_YPLUS, SURF_YMINUS]
		_: return []

static func get_turn_basis(from : int, to : int) -> Basis:
	var axis := to_normal(from).cross(to_normal(to))
	match axis:
		Vector3.RIGHT:
			# 1, 0, 0
			return Basis(Vector3.RIGHT, Vector3.BACK, Vector3.DOWN)
			pass
		Vector3.LEFT:
			# -1, 0, 0
			return Basis(Vector3.RIGHT, Vector3.FORWARD, Vector3.UP)
			pass
		Vector3.UP:
			# 0, 1, 0
			return Basis(Vector3.FORWARD, Vector3.UP, Vector3.RIGHT)
			pass
		Vector3.DOWN:
			# 0, -1, 0
			return Basis(Vector3.BACK, Vector3.UP, Vector3.LEFT)
			pass
		Vector3.BACK:
			# 0, 0, 1
			return Basis(Vector3.UP, Vector3.LEFT, Vector3.BACK)
			pass
		Vector3.FORWARD:
			# 0, 0, -1
			return Basis(Vector3.DOWN, Vector3.RIGHT, Vector3.BACK)
			pass
	assert(false)
	return Basis.IDENTITY
