extends Camera2D

#Camera speed
@export var camera_speed : int = 1000
var screen_size : Vector2
var player_control : bool = true

signal movement_done()
 
func _ready() -> void:
	screen_size = DisplayServer.screen_get_size() * 2
 
func _process(delta: float) -> void:
	if player_control:
		var direction : Vector2 = Vector2(0, 0)
	 
		if Input.is_action_pressed("left") or get_local_mouse_position().x < screen_size.x / 100 - screen_size.x / 2:
			direction.x -= camera_speed
		if Input.is_action_pressed("right") or get_local_mouse_position().x + screen_size.x/2 > screen_size.x - screen_size.x / 100:
			direction.x += camera_speed
		if Input.is_action_pressed("up") or get_local_mouse_position().y + screen_size.y/2 < screen_size.y / 100:
			direction.y -= camera_speed
		if Input.is_action_pressed("down") or get_local_mouse_position().y + screen_size.y/2 > screen_size.y - screen_size.y / 100:
			direction.y += camera_speed

		position += direction.normalized() * camera_speed * delta

func move_to(pos : Vector2):
	player_control = false
	var tween = create_tween()
	tween.tween_property(self, "global_position", pos, global_position.distance_to(pos) * 0.002).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	player_control = true
	emit_signal("movement_done")
