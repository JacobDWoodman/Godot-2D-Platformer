extends "res://enemy/stahlfeder.gd"

func _physics_process(_delta):
	move_dir = 0
	
	match state:
		IDLE: _do_idle()
		MOVE: _do_move()
		CHASE: _do_chase()
		ATTACK: anim_state.travel("Attack")
		OUCH: anim_state.travel("Ouch")
		DYING: 
			anim_state.travel("Die")
	
	grounded = is_on_floor()
	_do_gravity()
