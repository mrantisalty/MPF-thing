extends CanvasLayer

@onready var Player = self.get_parent().find_child("Player")


@onready var time : float = 0.0

func format_time(seconds : float) -> String:
	var minute = floor(seconds / 60)
	var sec = int(seconds) % 60
	var ms = int((seconds - int(seconds)) * 1000)
	return "%02d:%02d.%03d" % [minute,sec,ms]

func _process(delta: float) -> void:
	$Control/Coins.text = str(Player.get_coin())
	
	time += delta
	$Control/Time.text = format_time(time)
	
