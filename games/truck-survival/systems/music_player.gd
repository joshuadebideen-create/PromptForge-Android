
extends CanvasLayer

var audio_player: AudioStreamPlayer
var playlist: Array[String] = []
var current_track: int = 0
var is_paused: bool = false

var track_label: Label
var volume_slider: HSlider

func _ready() -> void:
    audio_player = AudioStreamPlayer.new()
    audio_player.name = "MusicAudioPlayer"
    audio_player.volume_db = -6.0
    add_child(audio_player)

    audio_player.finished.connect(play_next)
    create_music_interface()
    scan_music_folder()

func create_music_interface() -> void:
    var panel := PanelContainer.new()
    panel.position = Vector2(15, 325)
    panel.custom_minimum_size = Vector2(260, 190)
    add_child(panel)

    var layout := VBoxContainer.new()
    panel.add_child(layout)

    var title := Label.new()
    title.text = "TRUCK MULTIMEDIA"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    layout.add_child(title)

    track_label = Label.new()
    track_label.text = "No music loaded"
    track_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    layout.add_child(track_label)

    var buttons := HBoxContainer.new()
    layout.add_child(buttons)

    add_music_button(buttons, "PREV", play_previous)
    add_music_button(buttons, "PLAY", play_music)
    add_music_button(buttons, "PAUSE", pause_music)
    add_music_button(buttons, "STOP", stop_music)
    add_music_button(buttons, "NEXT", play_next)

    var volume_label := Label.new()
    volume_label.text = "VOLUME"
    layout.add_child(volume_label)

    volume_slider = HSlider.new()
    volume_slider.min_value = 0
    volume_slider.max_value = 100
    volume_slider.value = 70
    layout.add_child(volume_slider)

    volume_slider.value_changed.connect(set_volume)

func add_music_button(
    parent: HBoxContainer,
    button_text: String,
    callback: Callable
) -> void:
    var button := Button.new()
    button.text = button_text
    button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    parent.add_child(button)
    button.pressed.connect(callback)

func scan_music_folder() -> void:
    var directory := DirAccess.open("user://music")

    if directory == null:
        DirAccess.make_dir_recursive_absolute(
            ProjectSettings.globalize_path("user://music")
        )
        track_label.text = "Add MP3 files to music folder"
        return

    directory.list_dir_begin()

    var filename := directory.get_next()

    while filename != "":
        if not directory.current_is_dir():
            if filename.to_lower().ends_with(".mp3"):
                playlist.append("user://music/" + filename)

        filename = directory.get_next()

    directory.list_dir_end()

    playlist.sort()

    if playlist.is_empty():
        track_label.text = "No MP3 files found"
    else:
        track_label.text = str(playlist.size()) + " tracks found"

func load_track(index: int) -> void:
    if playlist.is_empty():
        track_label.text = "No music available"
        return

    current_track = posmod(index, playlist.size())

    var file_path := playlist[current_track]
    var music_data := FileAccess.get_file_as_bytes(file_path)

    if music_data.is_empty():
        track_label.text = "Unable to load MP3"
        return

    var stream := AudioStreamMP3.load_from_buffer(music_data)

    if stream == null:
        track_label.text = "Invalid MP3 file"
        return

    audio_player.stop()
    audio_player.stream = stream
    audio_player.play()

    is_paused = false
    track_label.text = file_path.get_file().get_basename()

func play_music() -> void:
    if playlist.is_empty():
        scan_music_folder()

    if playlist.is_empty():
        track_label.text = "Add MP3 files first"
        return

    if audio_player.stream != null and is_paused:
        audio_player.stream_paused = false
        audio_player.play()
        is_paused = false
    else:
        load_track(current_track)

func pause_music() -> void:
    if audio_player.playing:
        audio_player.stream_paused = true
        is_paused = true

func stop_music() -> void:
    audio_player.stop()
    is_paused = false

func play_next() -> void:
    if not playlist.is_empty():
        load_track(current_track + 1)

func play_previous() -> void:
    if not playlist.is_empty():
        load_track(current_track - 1)

func set_volume(value: float) -> void:
    if value <= 0.0:
        audio_player.volume_db = -80.0
    else:
        audio_player.volume_db = linear_to_db(value / 100.0)

