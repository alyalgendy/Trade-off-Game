extends Node

# Global state variables
var player_hearts: int = 3
var max_hearts: int = 3
var current_monster_index: int = 1 # Tracks monster 1 through 4
var active_potion: Dictionary = {}

signal hearts_changed(new_hearts: int)

func lose_heart(amount: int = 1) -> void:
	player_hearts -= amount
	hearts_changed.emit(player_hearts)
	if player_hearts <= 0:
		game_over()

func reset_run() -> void:
	player_hearts = 3
	max_hearts = 3
	current_monster_index = 1
	active_potion = {}
	get_tree().change_scene_to_file("res://scenes/ScoutScreen.tscn")

func game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/GameOverScreen.tscn")

func win_game() -> void:
	get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")
