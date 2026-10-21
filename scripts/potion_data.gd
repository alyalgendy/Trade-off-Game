class_name PotionData
extends Node

static func get_all_potions() -> Array[Dictionary]:
	return [
		{
			"id": "stone_skin",
			"name": "Stone Skin Brew",
			"buff_text": "+50% Defense (Take Half Damage)",
			"debuff_text": "-40% Movement Speed",
			"speed_mod": 0.6,
			"damage_take_mod": 0.5,
			"attack_speed_mod": 1.0,
			"reduced_max_hp": false
		},
		{
			"id": "berserker",
			"name": "Berserker Tonic",
			"buff_text": "+100% Attack Speed & Heavy Damage",
			"debuff_text": "Reduce Current HP to 1 Heart for this fight",
			"speed_mod": 1.1,
			"damage_take_mod": 1.0,
			"attack_speed_mod": 0.5,
			"reduced_max_hp": true
		},
		{
			"id": "shadow",
			"name": "Shadow Elixir",
			"buff_text": "+40% Move Speed & Extended Dodge",
			"debuff_text": "+25% Extra Damage Taken if Hit",
			"speed_mod": 1.4,
			"damage_take_mod": 1.25,
			"attack_speed_mod": 1.0,
			"reduced_max_hp": false
		},
		{
			"id": "volatile",
			"name": "Volatile Draft",
			"buff_text": "High Attack Speed & Swift Moves",
			"debuff_text": "Taking damage costs 2 Hearts instead of 1",
			"speed_mod": 1.2,
			"damage_take_mod": 2.0,
			"attack_speed_mod": 0.7,
			"reduced_max_hp": false
		}
	]
