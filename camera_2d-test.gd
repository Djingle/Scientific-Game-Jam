extends Camera2D

#Camera speed
@export var camera_speed : int = 1000
var screen_size : Vector2
 
func _ready() -> void:
	screen_size = DisplayServer.screen_get_size()
 
func _process(delta: float) -> void:
	var direction : Vector2 = Vector2(0, 0)
 
	if Input.is_action_pressed("left") or get_local_mouse_position().x + screen_size.x/2 < screen_size.x / 10:
		direction.x -= camera_speed
	if Input.is_action_pressed("right") or get_local_mouse_position().x + screen_size.x/2 > screen_size.x - screen_size.x / 10:
		direction.x += camera_speed
	if Input.is_action_pressed("up") or get_local_mouse_position().y + screen_size.y/2 < screen_size.y / 10:
		direction.y -= camera_speed
	if Input.is_action_pressed("down") or get_local_mouse_position().y + screen_size.y/2 > screen_size.y - screen_size.y / 10:
		direction.y += camera_speed

	position += direction.normalized() * camera_speed * delta
