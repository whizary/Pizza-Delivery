extends Control

@onready var master_slider: HSlider = $"Audio/Main/HSlider"
@onready var sfx_slider: HSlider = $"Audio/SFX/HSlider2"
@onready var music_slider: HSlider = $"Audio/Music/HSlider3"

@onready var fullscreen_cb: CheckBox = $"Display/FullScreen/CheckBox"
@onready var resolution_dd: OptionButton = $"Display/Resolution/OptionButton"

@onready var vsync_cb: CheckBox = $"Gameplay/VSync/CheckBox"
@onready var particles_cb: CheckBox = $"Gameplay/Particles/CheckBox"

var _loading_ui := false

func _physics_process(delta):
	AudioManager.play_music("MenuMusic")

func _ready():
	_loading_ui = true

	fullscreen_cb.button_pressed = SettingsManager.data["display"]["fullscreen"]
	resolution_dd.select(int(SettingsManager.data["display"]["resolution_index"]))

	vsync_cb.button_pressed = SettingsManager.data["gameplay"]["vsync"]
	particles_cb.button_pressed = SettingsManager.data["gameplay"]["particles"]

	_loading_ui = false


	fullscreen_cb.toggled.connect(_on_fullscreen_toggled)
	resolution_dd.item_selected.connect(_on_resolution_selected)

	vsync_cb.toggled.connect(_on_vsync_toggled)
	particles_cb.toggled.connect(_on_particles_toggled)

func _on_master_changed(v: float):
	if _loading_ui: return
	SettingsManager.set_master(v)

func _on_sfx_changed(v: float):
	if _loading_ui: return
	SettingsManager.set_sfx(v)

func _on_music_changed(v: float):
	if _loading_ui: return
	SettingsManager.set_music(v)

func _on_fullscreen_toggled(on: bool):
	if _loading_ui: return
	SettingsManager.set_fullscreen(on)

func _on_resolution_selected(index: int):
	if _loading_ui: return
	SettingsManager.set_resolution_index(index)

func _on_vsync_toggled(on: bool):
	if _loading_ui: return
	SettingsManager.set_vsync(on)

func _on_particles_toggled(on: bool):
	if _loading_ui: return
	SettingsManager.set_particles(on)
