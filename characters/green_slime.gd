extends CharacterBody2D

const GRAVITY = 300

var Sprite : AnimatedSprite2D
var ImmunityTimer : Timer
var Hurtbox : Area2D
var Hitbox : Area2D
var DeathTimer : Timer

var direction : int = 1
var health : int = 2

func _ready() -> void:
	Sprite = $Sprite
	Hurtbox = $Hurtbox
	Hitbox = $Hitbox
	ImmunityTimer = $ImmunityTimer
	DeathTimer = $DeathTimer

func movement_handler(delta : float):
	velocity.x = 25
	if direction < 0:
		Sprite.flip_h = true
	if direction > 0:
		Sprite.flip_h = false
	
	if is_on_wall():
		direction *= -1
		
	velocity.x *= direction
	velocity.y = move_toward(self.velocity.y,300,delta * GRAVITY)


func _physics_process(delta: float) -> void:
	
	
	if health <= 0:
		if Sprite.animation != "dead":
			Sprite.animation = "dead"
			DeathTimer.start()
			Hitbox.get_child(0).set_deferred("disabled",true)
		return
	
	movement_handler(delta)
	
	move_and_slide()

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	if Sprite.animation == "dead":
		return
	ImmunityTimer.start()
	Hurtbox.get_child(0).set_deferred("disabled",true)
	Sprite.animation = "hurt"
	health -= 1
	


func _on_immunity_timer_timeout() -> void:
	Hurtbox.get_child(0).disabled = false
	Sprite.animation = "default"
	


func _on_death_timer_timeout() -> void:
	self.queue_free()
