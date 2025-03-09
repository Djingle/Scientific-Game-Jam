extends Control

signal tween_done()
signal text_written()

var is_writing : bool = false
var is_displayed : bool = false
var last_speech : String = ""

func _ready() -> void:
	display_manager(false)

func display_manager(mode : bool = true):
	#Shrinks or displays the text box
	var anchor_top : float = 1
	var anchor_bottom : float = 1.25
	if mode == true:
		anchor_top = .75
		anchor_bottom = .7
	else:
		$DialogText/DialogCloseButton.hide()
		$DialogText/DialogLabel.text = ""
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($DialogText, "anchor_top", anchor_top, .25)
	tween.tween_property($DialogText, "anchor_bottom", anchor_bottom, .25)
	await tween.finished
	if mode == true: $DialogText/DialogCloseButton.show()
	emit_signal("tween_done")
	is_displayed = mode

func display_text(speech : String):
	last_speech = speech
	if !is_writing:
		is_writing = true
		if !is_displayed:
			display_manager()
			await tween_done
		$DialogText/DialogLabel.text = speech
		$DialogText/DialogLabel.visible_ratio = 0
		var tween = create_tween()
		tween.tween_property($DialogText/DialogLabel, "visible_ratio", 1, 0.03 * speech.length())
		await tween.finished
		emit_signal("text_written")
		is_writing = false
	
func _on_menu_button_pressed() -> void:
	get_tree().quit()

func _on_dialog_close_button_pressed() -> void:
	display_manager(false)

func _on_dialog_open_button_pressed() -> void:
	if is_displayed : return
	display_text(last_speech)
