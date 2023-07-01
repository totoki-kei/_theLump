extends Spatial
class_name GameObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# 移動方向
var velocity : Vector3

# 入力における上方向 (正規化されたベクトル)
var forward_dir : Vector3

# 現在このオブジェクトが乗っている平面
var surface : int



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



# velocityに従ってオブジェクトを移動させる
# 発生した折り返し回数を戻り値とする
func move_object() -> int:
	# 現在の位置
	var location := self.translation
	# 目標到達地点(仮設定:折り返し処理で随時更新)
	var destination := location + velocity

	#var plane_surf = surface

	var turn_count = 0
	
	var finished := false

	# 隣接面導出 -> 隣接面移動判定 -> 移動 を繰り返し実行するループ
	while true:
		# 現在の面から、判定対象となる隣接面を列挙
		#var plane_list := Surface.get_neighbors(surface)
		
		var surf_list = []
		
		if destination.x < -1.0:
			surf_list.append(Surface.SURF_XMINUS)
		if destination.x >  1.0:
			surf_list.append(Surface.SURF_XPLUS)
		if destination.y < -1.0:
			surf_list.append(Surface.SURF_YMINUS)
		if destination.y >  1.0:
			surf_list.append(Surface.SURF_YPLUS)
		if destination.z < -1.0:
			surf_list.append(Surface.SURF_ZMINUS)
		if destination.z >  1.0:
			surf_list.append(Surface.SURF_ZPLUS)

		if surf_list.empty():
			break

		var has_collision : bool = false
		var nearest_length_squared : float = INF
		var nearest_collision_point : Vector3
		var nearest_collision_surface : int
		for s in surf_list:
			var p := Surface.to_plane(s)
			var c := p.intersects_segment(location, destination)
			if c == null:
				continue
			var length_squared := (c - location).length_squared()
			if length_squared < nearest_length_squared:
				has_collision = true
				nearest_length_squared = length_squared
				nearest_collision_point = c
				nearest_collision_surface = s

		if has_collision:
			# ここにターン処理を追加
			# 衝突地点からオーバーランしている部分のベクトル(Vector3)
			var rest := destination - (nearest_collision_point as Vector3)
			
			# オーバーラン部分が完全にゼロベクトルである場合は
			# 移動予測地点が判定対象の平面にちょうど乗る位置になっている
			# その場合は、現在の平面と判定対称の平面の両方に属した稜線上にあるとみなし
			# この時点で判定を終わりにする
			if rest == Vector3.ZERO:
				break
			
			#var rotation_axis := Surface.to_normal(surface).cross(Surface.to_normal(plane_surf))
			var rotation_basis := Surface.get_turn_basis(surface, nearest_collision_surface)

			# オーバーラン部分のベクトルを稜線に従って折り曲げる
			#rest = rest.rotated(rotation_axis, PI / 2)
			rest = rotation_basis.xform(rest)

			# 折り曲げたベクトルで予想移動経路線分を更新
			location = nearest_collision_point
			destination = nearest_collision_point + rest		

			# 面を移動したため、前方向ベクトルを更新する
			#forward_dir = forward_dir.rotated(rotation_axis, PI / 2)
			forward_dir = rotation_basis.xform(forward_dir)

			# 現在属している平面を更新
			surface = nearest_collision_surface

			# 座標補正
			# 方向転換時にベクトルの計算誤差が発生するためそれを補正する
			# (get_turn_basis の導入で発生しなくなるはずなのだがまだ起きるので続ける)
			match surface:
				Surface.SURF_XPLUS: destination.x = 1.0
				Surface.SURF_XMINUS: destination.x = -1.0
				Surface.SURF_YPLUS: destination.y = 1.0
				Surface.SURF_YMINUS: destination.y = -1.0
				Surface.SURF_ZPLUS: destination.z = 1.0
				Surface.SURF_ZMINUS: destination.z = -1.0

			# 折り返し回数加算
			turn_count += 1

			pass

		
		# 完了していればそこで終了		
		if finished : break
		
		pass # もう一度隣接面の導出から

	

	# 座標更新
	self.translation = destination
	
	assert( -1.0 <= destination.x and destination.x <= 1.0 \
		and -1.0 <= destination.y and destination.y <= 1.0 \
		and -1.0 <= destination.z and destination.z <= 1.0 \
	)
	
	return turn_count
	

func get_vector(v2d : Vector2) -> Vector3:
	var ydir = forward_dir
	var xdir = Surface.to_normal(surface).cross(forward_dir)
	return xdir * v2d.x + ydir * v2d.y

