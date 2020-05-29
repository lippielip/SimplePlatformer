extends KinematicBody2D

var SPEED = 80
var SPRINT_MODIFIER = 1.5
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

var on_ground = false
var is_attacking = false

func _physics_process(delta):
	
	#LEFT / RIGHT Movement
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$AnimatedSprite.flip_h = false
		#Sprint
		if Input.is_action_pressed("ui_shift"):
			velocity.x = SPEED * SPRINT_MODIFIER
			$RunFx.pitch_scale = 1.4
			if !is_attacking:
				$AnimatedSprite.play("Sprint")
		else:
			$RunFx.pitch_scale = 1.0
			if !is_attacking:
				$AnimatedSprite.play("Run")
				
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.flip_h = true
		#Sprint
		if Input.is_action_pressed("ui_shift"):
			$RunFx.pitch_scale = 1.4
			velocity.x = -SPEED * SPRINT_MODIFIER
			if !is_attacking:
				$AnimatedSprite.play("Sprint")
		else:
			$RunFx.pitch_scale = 1.0
			if !is_attacking:
				$AnimatedSprite.play("Run")
				
	elif Input.is_action_pressed("ui_down"):
			if !is_attacking:
				velocity.x = 0
				$AnimatedSprite.play("Crouch")
	#Idle Animation
	else:
		velocity.x = 0
		if on_ground == true:
			if !is_attacking:
				$RunFx.stop()
				$AnimatedSprite.play("Idle")
	#Jump
	if Input.is_action_pressed("ui_up"):
		if on_ground == true:
			velocity.y = JUMP_POWER
			on_ground = false
			if !is_attacking:
				$AnimatedSprite.play("Jump")
				
		# Gravity calculation
	velocity.y += GRAVITY
		
		#Attack 
	if Input.is_action_just_pressed("ui_select") && !is_attacking:
		$AnimatedSprite.play("Attack")
		$SwordFx.play()
		SPEED = 70
		SPRINT_MODIFIER = 1.0
		is_attacking = true
		print("Attack")
	#Ground Detection
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		#Decide between Jump and Fall animation
		if !is_attacking:
			if velocity.y < 0:
				$AnimatedSprite.play("Jump")
			else:
				$AnimatedSprite.play("Fall")
	
	if Input.is_action_pressed("ui_up") &&  on_ground == true:
		if !$JumpFx.playing:
			$JumpFx.play()
			$RunFx.stop()
	elif (Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"))  &&  on_ground == true:
		if !$RunFx.playing:
			$RunFx.play()
	if Input.is_action_just_released("ui_left") && velocity.x == 0:
		$RunFx.stop()
	if Input.is_action_just_released("ui_right") && velocity.x == 0:
		$RunFx.stop()
# Attack Check
	if is_attacking && $AnimatedSprite.frame == $AnimatedSprite.frames.get_frame_count("Attack")-2:
		SPEED = 80
		SPRINT_MODIFIER = 1.5
		is_attacking = false
	# Do Movement based on velocity
	velocity = move_and_slide(velocity, FLOOR)
