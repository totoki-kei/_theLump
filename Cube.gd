extends MeshInstance3D
class_name Cube

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var surface_material : Material
@export var outer_material : Material
@export var middle_material : Material
@export var inner_material : Material
@export var line_material : Material

# Called when the node enters the scene tree for the first time.
func _ready():
	if mesh.get_surface_count() == 0:
		setup_mesh2()
		ResourceSaver.save(mesh, "res://cube_mesh.tres", ResourceSaver.FLAG_COMPRESS)
	pass

func _process(delta):
	pass

func setup_mesh():
	# インデックスは共通なので外で作成
	var indices = PackedInt32Array()
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
	
	# 面が逆だった　ので反転
	indices.reverse()
	
	for size in [0.625, 0.75, 0.875, 1.0]:
		var verts = PackedVector3Array()
		var normals = PackedVector3Array()
		var colors = PackedColorArray()

		# 0
		verts.append(size * Vector3(-1, -1,  1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		normals.append(Vector3(-1, -1,  1).normalized())
		# 1
		verts.append(size * Vector3(-1,  1,  1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		normals.append(Vector3(-1,  1,  1).normalized())
		# 2
		verts.append(size * Vector3( 1,  1,  1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		normals.append(Vector3( 1,  1,  1).normalized())
		# 3
		verts.append(size * Vector3( 1, -1,  1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		normals.append(Vector3( 1, -1,  1).normalized())
		# 4
		verts.append(size * Vector3(-1, -1, -1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		normals.append(Vector3(-1, -1, -1).normalized())
		# 5
		verts.append(size * Vector3(-1,  1, -1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		normals.append(Vector3(-1,  1, -1).normalized())
		# 6
		verts.append(size * Vector3( 1,  1, -1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		normals.append(Vector3( 1,  1, -1).normalized())
		# 7
		verts.append(size * Vector3( 1, -1, -1))
		colors.append(Color(1.0, 1.0, 1.0, 0.5))
		normals.append(Vector3( 1, -1, -1).normalized())

		# 8
		verts.append(size * Vector3( 1,  0,  0))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		normals.append(Vector3( 1,  0,  0))
		# 9
		verts.append(size * Vector3(-1,  0,  0))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		normals.append(Vector3(-1,  0,  0))
		# 10
		verts.append(size * Vector3( 0,  1,  0))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		normals.append(Vector3( 0,  1,  0))
		# 11
		verts.append(size * Vector3( 0, -1,  0))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		normals.append(Vector3( 0, -1,  0))
		# 12
		verts.append(size * Vector3( 0,  0,  1))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		normals.append(Vector3( 0,  0,  1))
		# 13
		verts.append(size * Vector3( 0,  0, -1))
		colors.append(Color(1.0, 1.0, 1.0, 0.125))
		normals.append(Vector3( 0,  0, -1))


		var surface_array = []
		surface_array.resize(Mesh.ARRAY_MAX)
		surface_array[Mesh.ARRAY_VERTEX] = verts
		surface_array[Mesh.ARRAY_INDEX] = indices
		surface_array[Mesh.ARRAY_COLOR] = colors
		#surface_array[Mesh.ARRAY_NORMAL] = normals

		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
		
		if size == 1.0:
			# ワイヤーフレーム部分の作成
			var line_indices = PackedInt32Array()
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

func setup_mesh2():
	var st := SurfaceTool.new()
	
	var colors = PackedColorArray([
		Color(1.0, 1.0, 1.0, 0.125),
		Color(1.0, 1.0, 1.0, 0.5),
		Color(1.0, 1.0, 1.0, 0.5),
		Color(1.0, 1.0, 1.0, 0.5),
		Color(1.0, 1.0, 1.0, 0.5)
	])

	for size in [0.625, 0.75, 0.875, 1.0]:
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		st.set_normal(Surface.to_normal(Surface.SURF_XPLUS))
		st.add_triangle_fan(Surface.get_triangle_fan(Surface.SURF_XPLUS, size), PackedVector2Array(), colors)
		st.set_normal(Surface.to_normal(Surface.SURF_YPLUS))
		st.add_triangle_fan(Surface.get_triangle_fan(Surface.SURF_YPLUS, size), PackedVector2Array(), colors)
		st.set_normal(Surface.to_normal(Surface.SURF_ZPLUS))
		st.add_triangle_fan(Surface.get_triangle_fan(Surface.SURF_ZPLUS, size), PackedVector2Array(), colors)
		st.set_normal(Surface.to_normal(Surface.SURF_XMINUS))
		st.add_triangle_fan(Surface.get_triangle_fan(Surface.SURF_XMINUS, size), PackedVector2Array(), colors)
		st.set_normal(Surface.to_normal(Surface.SURF_YMINUS))
		st.add_triangle_fan(Surface.get_triangle_fan(Surface.SURF_YMINUS, size), PackedVector2Array(), colors)
		st.set_normal(Surface.to_normal(Surface.SURF_ZMINUS))
		st.add_triangle_fan(Surface.get_triangle_fan(Surface.SURF_ZMINUS, size), PackedVector2Array(), colors)
		st.commit(mesh)

	# LineはArrayMeshの機能を使った方が作りやすい
	var line_vertices := PackedVector3Array([
		Vector3( 1,  1,  1), Vector3(-1,  1,  1), Vector3( 1, -1,  1), Vector3(-1, -1,  1),
		Vector3( 1,  1, -1), Vector3(-1,  1, -1), Vector3( 1, -1, -1), Vector3(-1, -1, -1)
	])
	var line_indices := PackedInt32Array([
		0b000, 0b001, 0b000, 0b010, 0b000, 0b100,
		0b011, 0b010, 0b011, 0b001, 0b011, 0b111,
		0b110, 0b111, 0b110, 0b100, 0b110, 0b010,
		0b101, 0b100, 0b101, 0b111, 0b101, 0b001,

		0b000, 0b011, 0b011, 0b101, 0b101, 0b110,
		0b011, 0b110, 0b110, 0b000, 0b000, 0b101,
		0b111, 0b100, 0b100, 0b001, 0b001, 0b010,
		0b100, 0b010, 0b010, 0b111, 0b111, 0b001,
	])
	var lines_array = []
	lines_array.resize(Mesh.ARRAY_MAX)
	lines_array[Mesh.ARRAY_VERTEX] = line_vertices
	lines_array[Mesh.ARRAY_INDEX] = line_indices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, lines_array)
	
	
	mesh.surface_set_material(0, inner_material)
	mesh.surface_set_material(1, middle_material)
	mesh.surface_set_material(2, outer_material)
	mesh.surface_set_material(3, surface_material)
	mesh.surface_set_material(4, line_material)
	pass

var surface_color:
	get:
		return (surface_material as StandardMaterial3D).albedo_color
	set(color):
		(surface_material as StandardMaterial3D).albedo_color = color

var outer_color:
	get:
		return (outer_material as StandardMaterial3D).albedo_color
	set(color):
		(outer_material as StandardMaterial3D).albedo_color = color

var middle_color:
	get:
		return (middle_material as StandardMaterial3D).albedo_color
	set(color):
		(middle_material as StandardMaterial3D).albedo_color = color

var inner_color:
	get:
		return (inner_material as StandardMaterial3D).albedo_color
	set(color):
		(inner_material as StandardMaterial3D).albedo_color = color

