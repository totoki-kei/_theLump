extends Camera3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const POS_MOVE_THRESHOLD = 0.5;
const DELTA_RATE = 1.0 / 16.0;
const POS_MOVE_MAX_SPEED = 1.0 / 24.0;
#const POS_MOVE_MAX_SPEED = 1.0 / 32.0;
const SIDEVIEW_SHIFT = 1.6;
const SIDEVIEW_RATE = 0.8;

const DEFAULT_POV = 60.0


var followee : GameObject
var following : bool

var mode : int = 0

var current_pos : Vector3
var current_up  : Vector3

var target_pos : Vector3
var target_up  : Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):

	if following && followee != null:
		if mode == 0:
			var followee_pos := followee.position;
			var followee_surf := followee.surface;

			var up := followee.forward_dir
			var pos := 3 * Surface.to_vector(followee_surf)

			var rate := 1.0

			
			if followee_surf != Surface.SURF_XPLUS and followee_surf != Surface.SURF_XMINUS:
				if followee_pos.x < -POS_MOVE_THRESHOLD:
					pos.x -= SIDEVIEW_SHIFT
					rate *= SIDEVIEW_RATE
				elif followee_pos.x > POS_MOVE_THRESHOLD:
					pos.x += SIDEVIEW_SHIFT
					rate *= SIDEVIEW_RATE
				pass

			if followee_surf != Surface.SURF_YPLUS and followee_surf != Surface.SURF_YMINUS:
				if followee_pos.y < -POS_MOVE_THRESHOLD:
					pos.y -= SIDEVIEW_SHIFT
					rate *= SIDEVIEW_RATE
				elif followee_pos.y > POS_MOVE_THRESHOLD:
					pos.y += SIDEVIEW_SHIFT
					rate *= SIDEVIEW_RATE
				pass

			if followee_surf != Surface.SURF_ZPLUS and followee_surf != Surface.SURF_ZMINUS:
				if followee_pos.z < -POS_MOVE_THRESHOLD:
					pos.z -= SIDEVIEW_SHIFT
					rate *= SIDEVIEW_RATE
				elif followee_pos.z > POS_MOVE_THRESHOLD:
					pos.z += SIDEVIEW_SHIFT
					rate *= SIDEVIEW_RATE
				pass
		
			match followee_surf:
				Surface.SURF_XPLUS, Surface.SURF_XMINUS:
					pos.x *= rate
				Surface.SURF_YPLUS, Surface.SURF_YMINUS:
					pos.y *= rate
				Surface.SURF_ZPLUS, Surface.SURF_ZMINUS:
					pos.z *= rate
			
			target_pos = pos
			target_up = up
		elif mode == 1:
			var up := followee.forward_dir
			var pos := 3 * followee.position.normalized()

			target_pos = pos
			target_up = up
			pass
		

	# 更新
	if not target_pos.is_equal_approx(current_pos) or not target_up.is_equal_approx(current_up):
		var delta_pos := (target_pos - current_pos) * DELTA_RATE
		if delta_pos.length_squared() > POS_MOVE_MAX_SPEED * POS_MOVE_MAX_SPEED:
			delta_pos = delta_pos.normalized() * POS_MOVE_MAX_SPEED
		
		var delta_up := (target_up - current_up) * DELTA_RATE
		if delta_up.length_squared() > POS_MOVE_MAX_SPEED * POS_MOVE_MAX_SPEED:
			delta_up = delta_up.normalized() * POS_MOVE_MAX_SPEED
		
		current_pos += delta_pos
		current_up  += delta_up
		
		#current_pos = current_pos.move_toward(target_pos, POS_MOVE_MAX_SPEED)
		#current_up  = current_up.move_toward(target_up, POS_MOVE_MAX_SPEED).normalized()
		

		self.position = current_pos
		self.look_at(Vector3.ZERO, current_up)
		pass

	pass
