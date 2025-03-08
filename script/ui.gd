extends Control

var is_dialog_displayed : bool = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		is_dialog_displayed = false if is_dialog_displayed == true else true
		var anchor_array = [0.5, 0.775, 0.5, 0.775, 0]
		if is_dialog_displayed:
			anchor_array = [0.025, 0.65, 0.95, 0.9, 1]
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property($DialogText, "anchor_left", anchor_array[0], 0.75)
		tween.tween_property($DialogText, "anchor_top", anchor_array[1], 0.75)
		tween.tween_property($DialogText, "anchor_right", anchor_array[2], 0.75)
		tween.tween_property($DialogText, "anchor_bottom", anchor_array[3], 0.75)
		tween.tween_property($DialogText, "color:a", anchor_array[4], 0.7)
	
func _on_menu_button_pressed() -> void:
	get_tree().quit()
