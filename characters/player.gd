extends CharacterBody2D

var Hitbox : Area2D
var Hurtbox : Area2D
var Sprite : AnimatedSprite2D
var CoyoteTimer : Timer
var DamagedTimer : Timer
var AttackTimer : Timer
var AttackCooldownTimer : Timer

var health : int
var max_health : int = 3
var movement_modifier = 1

var HurtAudio : AudioStreamPlayer2D
var JumpAudio : AudioStreamPlayer2D
var SwingAudio : AudioStreamPlayer2D

const GRAVITY = 300 
const ACCELERATION = 600

signal player_dead

var coin : int = 0

func _ready() -> void:
	Hitbox = $Hitbox
	Hurtbox = $Hurtbox
	Sprite = $AnimatedSprite2D
	CoyoteTimer = $CoyoteTimer
	DamagedTimer = $DamagedTimer
	AttackTimer = $AttackTimer
	AttackCooldownTimer = $AttackCooldownTimer
	
	HurtAudio = $HurtAudio
	JumpAudio = $JumpAudio
	SwingAudio = $SwingAudio
	
	health = max_health
	
	add_user_signal("player_died")

func movement_handler(delta : float) -> void:
	var input_vector : Vector2i = Vector2i.ZERO
	var is_jumping = false
	movement_modifier = 1
	
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_jump"):
		is_jumping = true
	
	if not self.is_on_floor():
		movement_modifier = 0.25
	
	self.velocity.x += input_vector.x * delta * ACCELERATION * movement_modifier
	
	if DamagedTimer.time_left == 0:
		if self.velocity.x > 0:
			Sprite.animation = "walking"
			Sprite.flip_h = false
		elif self.velocity.x < 0:
			Sprite.animation = "walking"
			Sprite.flip_h = true
		else:
			Sprite.animation = "default"
	
	if abs(self.velocity.x) > 100:
		self.velocity.x = move_toward(self.velocity.x,0,700 * delta * movement_modifier)
	
	if is_on_floor():
		CoyoteTimer.start()
	
	if is_jumping and CoyoteTimer.time_left > 0:
		CoyoteTimer.stop()
		JumpAudio.play()
		self.velocity.y = -200
	
	if not is_jumping and input_vector.y <= 0:
		self.velocity.y = move_toward(self.velocity.y,300,delta * GRAVITY)
	
	if (signi(input_vector.x) != signf(self.velocity.x)):
		self.velocity.x = move_toward(self.velocity.x,0,delta * ACCELERATION * 1.5 * movement_modifier)
	
	self.velocity.y = move_toward(self.velocity.y,300,delta * GRAVITY)

func hitbox_handler():
	if self.velocity.x != 0:
		Hitbox.position.x = 16 * sign(self.velocity.x)
		if Hitbox.position.x > 0:
			Hitbox.get_child(1).flip_h = false
		else:
			Hitbox.get_child(1).flip_h = true
	
	if AttackTimer.time_left <= 0:
		Hitbox.visible = false
		Hitbox.get_child(0).disabled = true
	
	if Input.is_action_just_pressed("action_attack") and AttackCooldownTimer.is_stopped():
		AttackCooldownTimer.start()
		AttackTimer.start()
		SwingAudio.play()
		
		if self.is_on_floor():
			self.velocity.x *= 2
		
		Hitbox.visible = true
		Hitbox.get_child(0).disabled = false
		Hitbox.get_child(1).play()

func _physics_process(delta: float) -> void:
	if DamagedTimer.time_left > 0:
		Hurtbox.get_child(0).disabled = true
	else:
		Hurtbox.get_child(0).disabled = false
	
	if health <= 0:
		if Sprite.animation != "death":
			emit_signal("player_dead")
			Sprite.animation = "death"
		return
	
	movement_handler(delta)
	hitbox_handler()
	
	move_and_slide()

func take_damage(direction : Vector2) -> void:
	if Sprite.animation == "death":
		return
	self.health -= 1
	DamagedTimer.start()
	Sprite.animation = "hit"
	
	HurtAudio.play()
	
	velocity.x = 150 * -sign(direction.x)
	velocity.y = -100

func _on_hurtbox_body_entered(_body: Node2D) -> void:
	take_damage(self.velocity)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	take_damage((area.global_position - self.global_position))

func get_coin() -> int:
	return coin

func increment_coin() -> void:
	$CoinAudio.play()
	coin += 1


func _on_attack_cooldown_timer_timeout() -> void:
	$SwingReadyAudio.play()
