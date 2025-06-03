extends Button

@export var level : PackedScene
@export var id : int

func format_time(seconds : float) -> String:
	var minute = floor(seconds / 60)
	var sec = int(seconds) % 60
	var ms = int((seconds - int(seconds)) * 1000)
	return "%02d:%02d.%03d" % [minute,sec,ms]

func _ready() -> void:
	var file
	var data : Dictionary
	if FileAccess.file_exists("user://scores.json"):
		file = FileAccess.open("user://scores.json",FileAccess.READ)
		var data_string = file.get_as_text()
		if data_string != "":
			data = JSON.parse_string(data_string)
		else:
			data = Dictionary()
		
		var time = data.get(str(id),-1)
		if time == -1:
			$Label.text = "Not set"
		else:
			$Label.text = format_time(time)
		
	else:
		$Label.text = "Not set"
	

func _on_pressed() -> void:
	get_tree().change_scene_to_packed(level)
