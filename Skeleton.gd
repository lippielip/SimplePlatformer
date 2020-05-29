extends KinematicBody2D

var SPEED = 40
var SPRINT_MODIFIER = 1.5
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

onready var obj = get_parent().get_node('Player')

var on_ground = false
var is_attacking = false

func _physics_process(delta):
	var dir = (obj.global_position - global_position).normalized()
	dir = dir.x
	if dir > 0:
		velocity.x = SPEED
		if !is_attacking:
			$AnimatedSprite.flip_h = false
	if dir < 0:
		velocity.x = -SPEED
		if !is_attacking:
			$AnimatedSprite.flip_h = true
	if !is_attacking:
		$AnimatedSprite.play("Run")
	velocity.y += GRAVITY
		#Attack 
	if !is_attacking && (abs(obj.global_position.x - global_position.x)) < 25:
		$AnimatedSprite.play("Attack")
		$SwordFx.play()
		SPEED = 0
		SPRINT_MODIFIER = 1.0
		is_attacking = true
		
	#Ground Detection
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
# Attack Check
	if is_attacking && $AnimatedSprite.frame == $AnimatedSprite.frames.get_frame_count("Attack")-1:
		SPEED = 40
		SPRINT_MODIFIER = 1.5
		is_attacking = false
	# Do Movement based on velocity
	velocity = move_and_slide(velocity, FLOOR)
