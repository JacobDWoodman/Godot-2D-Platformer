extends AnimatedSprite


func _ready():
	# warning-ignore:return_value_discarded
	connect("animation_finished", self, "anim_finish")
	#play the animated sprite
	play()


func anim_finish():
	queue_free()
