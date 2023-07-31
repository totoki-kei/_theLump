extends Control

var last_selected : Control = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if last_selected == null:
		last_selected = $List/StartButton
	last_selected.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_focus_entered(node : NodePath):
	var control := get_node(node) as Control
	if control:
		last_selected = control
	pass # Replace with function body.


func _on_start_button_pressed():
	last_selected = $List/StartButton as Control
	pass # Replace with function body.


func _on_leaderboard_button_pressed():
	last_selected = $List/LeaderboardButton as Control
	pass # Replace with function body.


func _on_options_button_pressed():
	last_selected = $List/OptionsButton as Control
	pass # Replace with function body.


func _on_quit_button_pressed():
	last_selected = $List/QuitButton as Control
	pass # Replace with function body.
