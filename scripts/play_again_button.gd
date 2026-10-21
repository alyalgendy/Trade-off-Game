extends Control

@onready var play_again_button: Button = $CenterContainer/VBoxContainer/PlayAgainButton

func _ready() -> void:
	play_again_button.pressed.connect(_on_play_again_button_pressed)

func _on_play_again_button_pressed() -> void:
	GameManager.reset_run()
