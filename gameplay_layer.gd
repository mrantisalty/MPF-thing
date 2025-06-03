extends TileMapLayer

@export var wallScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cell_arr = self.get_used_cells()
	for cell_pos in cell_arr:
		var data = self.get_cell_tile_data(cell_pos)
		if data and data.get_custom_data("one_way_collision") == 1:
			var wall = wallScene.instantiate()
			wall.position = to_global(self.map_to_local(cell_pos))
			add_child(wall)
