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

	# Optional: Load a background texture for the card boxes
	# Replace with your actual card background image path if you have one!
	var card_bg_texture_path = "res://assets/ui/card_background.png"
	var card_style_normal: StyleBoxTexture = null
	var card_style_hover: StyleBoxTexture = null

	if ResourceLoader.exists(card_bg_texture_path):
		var bg_tex = load(card_bg_texture_path)
		
		# Normal state style
		card_style_normal = StyleBoxTexture.new()
		card_style_normal.texture = bg_tex
		# Sets 9-slice margins so corners don't stretch weirdly (adjust pixels to match your border size)
		card_style_normal.texture_margin_left = 12
		card_style_normal.texture_margin_top = 12
		card_style_normal.texture_margin_right = 12
		card_style_normal.texture_margin_bottom = 12

	for i in range(min(3, all_potions.size())):
		var potion = all_potions[i]
		
		# 1. Create Main Card Button with Larger Size
		var card_btn = Button.new()
		# Give enough height (340px) so larger text never overflows
		card_btn.custom_minimum_size = Vector2(260, 340)
		
		# Apply custom texture background if it exists
		if card_style_normal:
			card_btn.add_theme_stylebox_override("normal", card_style_normal)
			card_btn.add_theme_stylebox_override("hover", card_style_normal)
			card_btn.add_theme_stylebox_override("pressed", card_style_normal)
		
		# 2. Container inside card with internal padding (Margins)
		var vbox = VBoxContainer.new()
		vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
		vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE # Lets mouse clicks hit the button
		
		# Padding around borders to keep text inside the box
		vbox.add_theme_constant_override("margin_left", 14)
		vbox.add_theme_constant_override("margin_top", 14)
		vbox.add_theme_constant_override("margin_right", 14)
		vbox.add_theme_constant_override("margin_bottom", 14)
		vbox.add_theme_constant_override("separation", 8) # Vertical spacing between text/icon
		
		card_btn.add_child(vbox)
		
		# 3. Potion Title Label (Bigger Font)
		var title_label = Label.new()
		title_label.text = potion["name"]
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		title_label.add_theme_font_size_override("font_size", 22) # <--- BIGGER TITLE (22px)
		vbox.add_child(title_label)
		
		# 4. Potion Texture Icon
		var icon_rect = TextureRect.new()
		if ResourceLoader.exists(potion["icon_path"]):
			icon_rect.texture = load(potion["icon_path"])
		icon_rect.custom_minimum_size = Vector2(64, 64)
		icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		vbox.add_child(icon_rect)
		
		# 5. Buff Description Label (Bigger Font & Auto-Wrap Fix)
		var buff_label = Label.new()
		buff_label.text = "[GAIN]:\n" + potion["buff_text"]
		buff_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		buff_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		buff_label.clip_text = false
		buff_label.add_theme_font_size_override("font_size", 16) # <--- BIGGER BUFF TEXT (16px)
		buff_label.add_theme_color_override("font_color", Color(0.3, 1.0, 0.3)) # Green accent
		vbox.add_child(buff_label)

		# 6. Debuff Description Label (Bigger Font & Auto-Wrap Fix)
		var debuff_label = Label.new()
		debuff_label.text = "[TRADE-OFF]:\n" + potion["debuff_text"]
		debuff_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		debuff_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		debuff_label.clip_text = false
		debuff_label.add_theme_font_size_override("font_size", 16) # <--- BIGGER DEBUFF TEXT (16px)
		debuff_label.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4)) # Red accent
		vbox.add_child(debuff_label)
		
		# 7. Connect Button Press Signal
		card_btn.pressed.connect(func(): _on_potion_selected(potion, card_btn))
		potion_card_container.add_child(card_btn)
		
func _on_potion_selected(potion: Dictionary, btn: Button) -> void:
	selected_potion = potion
	GameManager.active_potion = potion
	enter_arena_button.disabled = false
	
	for child in potion_card_container.get_children():
		child.modulate = Color(0.5, 0.5, 0.5)
	btn.modulate = Color(1, 1, 1)

func _on_enter_arena_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Arena.tscn")
