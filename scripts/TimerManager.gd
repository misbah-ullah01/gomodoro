extends Control


@onready var timer_display: Label = $MarginContainer/VBoxContainer/TimerDisplay
@onready var progress: TextureProgressBar = $MarginContainer/VBoxContainer/TextureProgressBar
@onready var start_pause_btn: Button = $MarginContainer/VBoxContainer/ControlButtons/StartPause
@onready var reset_btn: Button = $MarginContainer/VBoxContainer/ControlButtons/Reset
@onready var minigame_btn: Button = $MarginContainer/VBoxContainer/MiniGameButton
@onready var countdown_timer: Timer = $CountdownTimer

var phase  = "focus"
# var timer = null
var is_running = false
var focus_time = 25*60
var short_break_time = 5*60
var long_break_time = 15*60
var time_left = focus_time
var focus_count = 0

func _ready():
	update_display()
	progress.max_value = time_left
	progress.value = 0
	minigame_btn.hide()
	countdown_timer.timeout.connect(_on_tick)
	
func start_pause():
	if is_running:
		_pause_timer()
	else:
		_start_timer()
		
func _start_timer():
	is_running = true
	start_pause_btn.text = "Pause"
	# timer = get_tree().create_timer(1.0, true)
	# timer.timeout.connect(_on_tick)
	countdown_timer.start()
	
func _pause_timer():
	is_running = false
	start_pause_btn.text = "Start"
	# if timer:
	#	timer.timeout.disconnect(_on_tick)
	countdown_timer.stop()
func _on_tick():
	time_left -= 1
	update_display()
	progress.value = progress.max_value - time_left
	
	if time_left <= 0:
		countdown_timer.stop()
		_phase_complete()

func update_display():
	@warning_ignore("integer_division")
	var minutes = int(time_left / 60)
	var seconds  =int(time_left % 60)
	timer_display.text = "%02d:%02d" % [minutes, seconds]
	
func _phase_complete():
	if phase == "focus":
		focus_count += 1
		if focus_count % 4 == 0:
			_set_phase("long_break")
		else:
			_set_phase("short_break")
	elif phase in ["short_break", "long_break"]:
			_set_phase("focus")
			
func _set_phase(new_phase):
	phase = new_phase
	if phase == "focus":
		time_left = focus_time
		minigame_btn.hide()
	elif phase == "short_break":
		time_left = short_break_time
		minigame_btn.show()
	elif phase == "long_break":
		time_left = long_break_time
		minigame_btn.show()
	
		
	progress.max_value = time_left
	progress.value = 0
	update_display()
	_start_timer()
	# start_pause_btn.text = "Start"
	


func _on_start_pause_pressed() -> void:
	start_pause()
	
func _on_reset_pressed() -> void:
	_set_phase("focus")
	
func _on_mini_game_button_pressed() -> void:
	pass
