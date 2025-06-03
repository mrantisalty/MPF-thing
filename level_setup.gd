extends Node2D

var RestartTimer : Timer
@export var id : int

func _ready() -> void:
	RestartTimer = $RestartTimer
	

func _on_player_dead() -> void:
	RestartTimer.start()
	


func _on_restart_timer_timeout() -> void:
	get_tree().reload_current_scene()


func on_player_dead() -> void:
	pass # Replace with function body.
