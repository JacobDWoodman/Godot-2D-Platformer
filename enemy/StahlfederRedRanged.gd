extends "res://enemy/stahlfeder.gd"
#overrides idle and move functions to remove random changes in state
#overrides chase func to add attack cooldown

const Projectile = preload ("res://enemy/projectile.tscn")

onready var shootTimer = $shootTimer

var shootTimerOut = false

func _ready():
	state = IDLE

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

func _spawn_projectile():
	var effect = Projectile.instance()
	get_parent().add_child(effect)
	#cant use tiger_spawnp for some reason
	effect.position = position + Vector2(0, -40)
	effect.facing_right = facing_right
	effect.sprite.flip_h = sprite.flip_h
	shootTimer.start(1.5)
	shootTimerOut = false

func _do_idle():
	anim_state.travel("Idle")
	check_in_range(playerDetector, CHASE)

func _do_move():
	anim_state.travel("Walk")
	if facing_right:
		move_dir -= 1
	else: move_dir += 1
	
	if timeout:
		if _near_enough(last_position.x, position.x, 0.01):
			_flip()
			timeout = false
			timer.start(0.1)
	last_position.x = position.x
	
# warning-ignore:return_value_discarded
	move_and_slide(Vector2(move_dir * move_speed, y_velo), Vector2(0, -1))
	check_in_range(playerDetector, CHASE)

func _do_chase():
	anim_state.travel("Idle")
	var player = playerDetector.player
	if player == null:
		 state = IDLE
	
	if shootTimerOut:
		check_in_range(attackDetector, ATTACK)

func _on_shootTimer_timeout():
	shootTimerOut = true
