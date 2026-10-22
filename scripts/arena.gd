extends Node2D

@onready var heart_container: HBoxContainer = $CanvasLayer/HUD/HeartContainer
@onready var monster_label: Label = $CanvasLayer/HUD/MonsterLabel
@onready var spawn_point: Marker2D = $SpawnPoint

var enemy_scene: PackedScene = preload("res://scenes/Enemy.tscn")

func _ready() -> void:
	GameManager.hearts_changed.connect(update_hud)
	update_hud(GameManager.player_hearts)
	spawn_current_monster()

func update_hud(hearts: int) -> void:
	monster_label.text = "Stage: Monster %d/4" % GameManager.current_monster_index
	
	# Update heart container display
	var idx = 0
	for child in heart_container.get_children():
		if child is TextureRect or child is Label:
			child.visible = (idx < hearts)
			idx += 1

func spawn_current_monster() -> void:
	var enemy_inst = enemy_scene.instantiate()
	enemy_inst.global_position = spawn_point.global_position
	add_child(enemy_inst)

func on_monster_defeated() -> void:
	if GameManager.current_monster_index >= 4:
		GameManager.win_game()
	else:
		GameManager.current_monster_index += 1
		get_tree().change_scene_to_file("res://scenes/ScoutScreen.tscn")
