extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var surface_material : Material
export var outer_material : Material
export var middle_material : Material
export var inner_material : Material
export var line_material : Material

# Called when the node enters the scene tree for the first time.
func _ready():
	$DebugCube.visible = false
	setup_mesh()
	
	pass

func _process(delta):
	pass

func setup_mesh():
	# インデックスは共通なので外で作成
	var indices = PoolIntArray()
	indices.append_array([1, 9, 0])
	indices.append_array([5, 9, 1])
	indices.append_array([4, 9, 5])
	indices.append_array([0, 9, 4])

	indices.append_array([4, 11, 0])
	indices.append_array([7, 11, 4])
	indices.append_array([3, 11, 7])
	indices.append_array([0, 11, 3])

	indices.append_array([3, 12, 0])
	indices.append_array([2, 12, 3])
	indices.append_array([1, 12, 2])
	indices.append_array([0, 12, 1])

	indices.append_array([2, 10, 1])
	indices.append_array([6, 10, 2])
	indices.append_array([5, 10, 6])
	indices.append_array([1, 10, 5])

	indices.append_array([3, 8, 2])
	indices.append_array([7, 8, 3])
	indices.append_array([6, 8, 7])
	indices.append_array([2, 8, 6])

	indices.append_array([5, 13, 4])
	indices.append_array([6, 13, 5])
	indices.append_array([7, 13, 6])
	indices.append_array([4, 13, 7])
	
	for size in [0.625, 0.75, 0.875, 1.0]:
		var verts = PoolVector3Array()
		var colors = PoolColorArray()

		# 0
		verts.append(size * Vector3(-1, -1,  1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		# 1
		verts.append(size * Vector3(-1,  1,  1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		# 2
		verts.append(size * Vector3( 1,  1,  1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		# 3
		verts.append(size * Vector3( 1, -1,  1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		# 4
		verts.append(size * Vector3(-1, -1, -1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		# 5
		verts.append(size * Vector3(-1,  1, -1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		# 6
		verts.append(size * Vector3( 1,  1, -1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		# 7
		verts.append(size * Vector3( 1, -1, -1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))

		# 8
		verts.append(size * Vector3( 1,  0,  0))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		# 9
		verts.append(size * Vector3(-1,  0,  0))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		# 10
		verts.append(size * Vector3( 0,  1,  0))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		# 11
		verts.append(size * Vector3( 0, -1,  0))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		# 12
		verts.append(size * Vector3( 0,  0,  1))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		# 13
		verts.append(size * Vector3( 0,  0, -1))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))


		var surface_array = []
		surface_array.resize(Mesh.ARRAY_MAX)
		surface_array[Mesh.ARRAY_VERTEX] = verts
		surface_array[Mesh.ARRAY_INDEX] = indices
		surface_array[Mesh.ARRAY_COLOR] = colors	

		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
		
		if size == 1.0:
			# ワイヤーフレーム部分の作成
			var line_indices = PoolIntArray()
			line_indices.append_array([0, 1, 1, 2, 2, 3, 3, 0])
			line_indices.append_array([4, 5, 5, 6, 6, 7, 7, 4])
			line_indices.append_array([0, 4, 1, 5, 2, 6, 3, 7])
			line_indices.append_array([0, 2, 1, 3])
			line_indices.append_array([4, 6, 5, 7])
			line_indices.append_array([0, 5, 1, 4])
			line_indices.append_array([1, 6, 2, 5])
			line_indices.append_array([2, 7, 3, 6])
			line_indices.append_array([3, 4, 0, 7])

			var lines_array = []
			lines_array.resize(Mesh.ARRAY_MAX)
			lines_array[Mesh.ARRAY_VERTEX] = verts
			lines_array[Mesh.ARRAY_INDEX] = line_indices

			mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, lines_array)
	
	mesh.surface_set_material(0, inner_material)
	mesh.surface_set_material(1, middle_material)
	mesh.surface_set_material(2, outer_material)
	mesh.surface_set_material(3, surface_material)
	mesh.surface_set_material(4, line_material)

