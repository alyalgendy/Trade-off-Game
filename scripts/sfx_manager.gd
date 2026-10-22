extends Node

var audio_player: AudioStreamPlayer

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

# Synthesizes retro sound effects on the fly
func play_sfx(type: String) -> void:
	var sample_rate = 22050.0
	var duration = 0.15
	var stream = AudioStreamWAV.new() # Fixes the scope error in Godot 4
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.mix_rate = int(sample_rate)
	
	var buffer = PackedByteArray()
	var total_samples = int(sample_rate * duration)
	
	for i in range(total_samples):
		var t = float(i) / sample_rate
		var val = 0.0
		
		match type:
			"attack": # Fast noise / swoosh sound
				var freq = lerp(800.0, 100.0, t / duration)
				val = sin(t * freq * TAU) * (1.0 - (t / duration))
			"hit": # Deep impact thump
				var freq = lerp(200.0, 40.0, t / duration)
				val = (randf() * 0.4 + sin(t * freq * TAU) * 0.6) * (1.0 - (t / duration))
			"hurt": # High-to-low buzz
				var freq = lerp(600.0, 150.0, t / duration)
				val = (1.0 if sin(t * freq * TAU) > 0 else -1.0) * (1.0 - (t / duration)) * 0.5
			"select": # Pleasant chime
				var freq = 587.33 # D5 note
				val = sin(t * freq * TAU) * (1.0 - (t / duration))

		var byte_val = int(clamp((val + 1.0) * 127.5, 0, 255))
		buffer.append(byte_val)
		
	stream.data = buffer
	audio_player.stream = stream
	audio_player.play()
