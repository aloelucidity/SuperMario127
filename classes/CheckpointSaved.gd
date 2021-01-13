extends Node

var current_checkpoint_id := -1
var current_spawn_pos := Vector2(-999, -999)
var current_area := 0
var current_coins := 0
var current_red_coins := []
var current_shine_shards := []
var liquid_positions := []
var nozzles_collected := []

func reset():
	current_checkpoint_id = -1
	current_spawn_pos = Vector2(-999, -999)
	current_area = 0
	current_coins = 0
	current_red_coins = []
	current_shine_shards = []
	liquid_positions = []
	nozzles_collected = ["null"]
	
	for index in CurrentLevelData.level_data.areas.size():
		current_red_coins.append([0, []])
		current_shine_shards.append([0, []])
		liquid_positions.append([])

	CurrentLevelData.level_data.vars.init()
