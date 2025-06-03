extends Area2D

var time : float = 0.0

func _ready() -> void:
	time = 0.0

func _process(delta: float) -> void:
	time += delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tree = get_tree()
		tree.call_deferred("change_scene_to_file","res://mainMenu.tscn")
		
		var file : FileAccess
		var data : Dictionary
		
		if FileAccess.file_exists("user://scores.json"):
			file = FileAccess.open("user://scores.json",FileAccess.READ)
			var data_string = file.get_as_text()
			if data_string != "":
				data = JSON.parse_string(data_string)
			else:
				data = Dictionary()
			file.close()
			file = FileAccess.open("user://scores.json",FileAccess.WRITE)
		else:
			file = FileAccess.open("user://scores.json",FileAccess.WRITE)
			data = Dictionary()
		var id = str(find_parent("Node2D").id)

		var value = data.get(id,INF)
		
		if value == null or value > time:
			data[id] = time
		file.store_string(JSON.stringify(data))
		
		file.close()
		
