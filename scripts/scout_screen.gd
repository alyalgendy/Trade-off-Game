extends Control

@onready var monster_preview_label: Label = $VBoxContainer/MonsterPreviewBox/VBoxContainer/MonsterPreviewLabel
@onready var monster_texture: TextureRect = $VBoxContainer/MonsterPreviewBox/VBoxContainer/MonsterTexture
@onready var potion_card_container: HBoxContainer = $VBoxContainer/PotionCardContainer
@onready var enter_arena_button: Button = $VBoxContainer/EnterArenaButton

var selected_potion: Dictionary = {}

func _ready() -> void:
	enter_arena_button.disabled = true
	update_monster_preview()
	populate_potion_cards()

func update_monster_preview() -> void:
	var idx = GameManager.current_monster_index
	var descriptions = {
		1: "Monster 1/4: Glint Swarmer\nFast & Aggressive. Low HP.",
		2: "Monster 2/4: Iron Golem\nHeavy Tank. Hits hard, moves slow.",
		3: "Monster 3/4: Venom Spitter\nRanged Threat. High Mobility.",
		4: "Monster 4/4: APEX WARDEN (BOSS)\nMassive Health. Relentless Attacks."
	}
	monster_preview_label.text = descriptions.get(idx, "Unknown Beast")

func populate_potion_cards() -> void:
	for child in potion_card_container.get_children():
		child.queue_free()

	var all_potions = PotionData.get_all_potions()
	all_potions.shuffle()

	for i in range(min(3, all_potions.size())):
		var potion = all_potions[i]
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(220, 180)
		btn.text = "%s\n\n[GAIN]:\n%s\n\n[TRADE-OFF]:\n%s" % [
			potion["name"], potion["buff_text"], potion["debuff_text"]
		]
		btn.pressed.connect(func(): _on_potion_selected(potion, btn))
		potion_card_container.add_child(btn)

func _on_potion_selected(potion: Dictionary, btn: Button) -> void:
	selected_potion = potion
	GameManager.active_potion = potion
	enter_arena_button.disabled = false
	
	for child in potion_card_container.get_children():
		child.modulate = Color(0.5, 0.5, 0.5)
	btn.modulate = Color(1, 1, 1)

func _on_enter_arena_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Arena.tscn")
