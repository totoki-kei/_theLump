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
		var plane_list := Surface.get_neighbors(surface)
		# 番兵としてSURF_NONEを追加
		plane_list.append(Surface.SURF_NONE)
		
		for plane_surf in plane_list:
			assert (typeof(plane_surf) == TYPE_INT)
			
			# 平面がSURF_NONE(番兵)の場合、必要な面はすべて完了したことになる
			# 判定処理を終了する
			if plane_surf == Surface.SURF_NONE:
				finished = true
				break
			
			#
			# 平面との衝突チェック	
			#
			
			# p : Plane型
			var p := Surface.to_plane(plane_surf)

			# 移動ベクトルの始点がチェック対象平面上にあった場合、移動によって平面の上に飛び出す場合のみ処理を続行する
			# それ以外(稜線上を移動、もしくは今所属している平面の上に戻る方向の移動の場合)は折り返し処理をしない
			if p.has_point(location, 0):
				if not p.is_point_over(destination):
					continue

			# Planeと移動経路ベクトルの衝突する場所を導出
			var corride_at := p.intersects_segment(location, destination)
			# 衝突しなかった場合は次の平面との判定へ
			if corride_at == null : continue
			# if corride_at == location : continue
			if corride_at == destination : continue
			
			# 衝突地点からオーバーランしている部分のベクトル(Vector3)
			var rest := destination - (corride_at as Vector3)
			
			# オーバーラン部分が完全にゼロベクトルである場合は
			# 移動予測地点が判定対象の平面にちょうど乗る位置になっている
			# その場合は、現在の平面と判定対称の平面の両方に属した稜線上にあるとみなし
			# この時点で判定を終わりにする
			if rest == Vector3.ZERO:
				break
			
			#var rotation_axis := Surface.to_normal(surface).cross(Surface.to_normal(plane_surf))
			var rotation_basis := Surface.get_turn_basis(surface, plane_surf)

			# オーバーラン部分のベクトルを稜線に従って折り曲げる
			#rest = rest.rotated(rotation_axis, PI / 2)
			rest = rotation_basis.xform(rest)

			# 折り曲げたベクトルで予想移動経路線分を更新
			location = corride_at
			destination = corride_at + rest		

			# 面を移動したため、前方向ベクトルを更新する
			#forward_dir = forward_dir.rotated(rotation_axis, PI / 2)
			forward_dir = rotation_basis.xform(forward_dir)

			# 現在属している平面を更新
			surface = plane_surf
			
			# 折り返し回数加算
			turn_count += 1

			# 折り返した後の所属面でもう一度判定を行うため、隣接面の導出からやり直す
			break
		
		# 完了していればそこで終了		
		if finished : break
		
		pass # もう一度隣接面の導出から

	
	# 座標補正
	# 方向転換時にベクトルの計算誤差が発生するためそれを補正する
	match surface:
		Surface.SURF_XPLUS: destination.x = 1.0
		Surface.SURF_XMINUS: destination.x = -1.0
		Surface.SURF_YPLUS: destination.y = 1.0
		Surface.SURF_YMINUS: destination.y = -1.0
		Surface.SURF_ZPLUS: destination.z = 1.0
		Surface.SURF_ZMINUS: destination.z = -1.0

	# 座標更新
	self.translation = destination
	
	return turn_count
	
