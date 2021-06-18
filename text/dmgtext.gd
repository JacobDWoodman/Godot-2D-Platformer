extends RichTextLabel

export(int) var move_speed = 50
var input = "0" setget set_input

func set_input(change):
	input = change
	set_bbcode(input)

func _process(delta):
	get_parent().global_position.y -= move_speed * delta
	move_speed -= move_speed * delta

func _on_Timer_timeout():
	queue_free()
