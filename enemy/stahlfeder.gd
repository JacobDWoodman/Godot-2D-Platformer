extends "res://moving_entity.gd"

const Explosion = preload("res://enemy/explosion.tscn")

enum{
IDLE,
MOVE,
CHASE,
ATTACK,
OUCH,
DYING
}

var state = MOVE
var last_position = Vector2.ZERO

onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var timer = $Timer
onready var wanderTimer = $WanderTimer
onready var hurtbox = $Pivot/hurtbox
onready var stats = $stats
onready var playerDetector = $Pivot/PlayerDetectZone
onready var attackDetector = $Pivot/AttackDetectZone
onready var pivot = $Pivot

var timeout = false
var wanderTimeout = false

func _do_idle():
	anim_state.travel("Idle")
	_check_state_timer()
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
	_check_state_timer()

func _do_chase():
	anim_state.travel("Walk")
	var player = playerDetector.player
	if player == null:
		 state = IDLE
	
	check_in_range(attackDetector, ATTACK)
	if facing_right:
		move_dir -= 1
	else: move_dir += 1
	# warning-ignore:return_value_discarded
	move_and_slide(Vector2(move_dir * move_speed, y_velo), Vector2(0, -1))

func check_in_range(detector, change):
	if !detector.can_see_player(): return
	state = change

#checks if the two points are near enough based on the 3rd input
func _near_enough(point_a, point_b, threshold):
	return point_a + threshold >= point_b && point_a - threshold <= point_b

func _check_state_timer():
	if wanderTimeout:
		state = _pick_rand_state([IDLE, MOVE, MOVE, MOVE])
		wanderTimeout = false
		wanderTimer.start(rand_range(3, 6))

func _pick_rand_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _reset_state():
	state = IDLE

func _flip():
	._flip()
	if facing_right: pivot.set_scale(Vector2(-1, 1))
	else: pivot.set_scale(Vector2(1, 1))

func _on_Timer_timeout():
	timeout = true

func _on_WanderTimer_timeout():
	wanderTimeout = true

func _on_hurtbox_area_entered(area):
	if(state == IDLE or state == MOVE):
		_flip()
	state = OUCH
	stats.health -= area.damage
	hurtbox.create_hitEffect()
	hurtbox.create_dmgNumber(area.damage)

func _on_stats_no_health():
	state = DYING

func die():
	var effect = Explosion.instance()
	get_parent().add_child(effect)
	effect.position = position + Vector2(0, -40)
	queue_free()
