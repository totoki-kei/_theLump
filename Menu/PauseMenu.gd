extends Control

signal resume_selected
signal back_to_menu_selected

var resume_selected_caller : Callable
var back_to_menu_selected_caller : Callable

func _ready() -> void:
	resume_selected_caller = func ():
		resume_selected.emit()
	back_to_menu_selected_caller = func ():
		back_to_menu_selected.emit()

	$List/ResumeButton.connect("pressed", resume_selected_caller)
	$List/BackToMenuButton.connect("pressed", back_to_menu_selected_caller)
	
	# 初期状態
	($List/ResumeButton as Button).grab_focus.call_deferred()
	pass

func _exit_tree() -> void:
	$List/ResumeButton.disconnect("pressed", resume_selected_caller)
	$List/BackToMenuButton.disconnect("pressed", back_to_menu_selected_caller)
	pass
