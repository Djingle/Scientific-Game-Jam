extends Control

signal tween_done()

var is_writing : bool = false
var is_displayed : bool = false

func _ready() -> void:
	var anchor_array = [0.5, 0.775, 0.5, 0.775]
	$DialogText.anchor_left = anchor_array[0]
	$DialogText.anchor_top = anchor_array[1]
	$DialogText.anchor_right = anchor_array[2]
	$DialogText.anchor_bottom = anchor_array[3]
	$DialogText.color.a = 0
	$DialogText/DialogCloseButton.hide()

func display_manager(mode : bool = true):
	#Shrinks or displays the text box
	var anchor_array = [0.5, 0.775, 0.5, 0.775, 0]
	if mode == true:
		anchor_array = [0.025, 0.65, 0.95, 0.9, 1]
	else:
		$DialogText/DialogCloseButton.hide()
		$DialogText/DialogLabel.text = ""
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($DialogText, "anchor_left", anchor_array[0], 0.75)
	tween.tween_property($DialogText, "anchor_top", anchor_array[1], 0.75)
	tween.tween_property($DialogText, "anchor_right", anchor_array[2], 0.75)
	tween.tween_property($DialogText, "anchor_bottom", anchor_array[3], 0.75)
	tween.tween_property($DialogText, "color:a", anchor_array[4], 0.7)
	await tween.finished
	if mode == true: $DialogText/DialogCloseButton.show()
	emit_signal("tween_done")
	is_displayed = mode

func display_text(speech : String):
	if !is_writing:
		is_writing = true
		if !is_displayed:
			display_manager()
			await self.tween_done
		$DialogText/DialogLabel.text = speech
		$DialogText/DialogLabel.visible_ratio = 0
		var tween = create_tween()
		tween.tween_property($DialogText/DialogLabel, "visible_ratio", 1, 0.1 * speech.length())
		await tween.finished
		is_writing = false
	
func _on_menu_button_pressed() -> void:
	get_tree().quit()

func _on_dialog_close_button_pressed() -> void:
	display_manager(false)
