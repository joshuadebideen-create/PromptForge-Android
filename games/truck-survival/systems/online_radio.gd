
extends CanvasLayer

const DEFAULT_STATION := "http://puma.streemlion.com:1220/stream"

var radio: Node
var radio_audio: AudioStreamPlayer
var station_input: LineEdit
var status_label: Label
var play_button: Button

func _ready() -> void:
    create_radio_interface()
    setup_radio_extension()

func create_radio_interface() -> void:
    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(330, 145)
    panel.set_anchors_and_offsets_preset(
        Control.PRESET_TOP_RIGHT
    )
    panel.position = Vector2(-345, 15)
    add_child(panel)

    var layout := VBoxContainer.new()
    panel.add_child(layout)

    var heading := Label.new()
    heading.text = "ONLINE TRUCK RADIO"
    layout.add_child(heading)

    station_input = LineEdit.new()
    station_input.text = DEFAULT_STATION
    station_input.placeholder_text = "Radio stream URL"
    layout.add_child(station_input)

    var buttons := HBoxContainer.new()
    layout.add_child(buttons)

    play_button = Button.new()
    play_button.text = "PLAY"
    buttons.add_child(play_button)
    play_button.pressed.connect(play_radio)

    var stop_button := Button.new()
    stop_button.text = "STOP"
    buttons.add_child(stop_button)
    stop_button.pressed.connect(stop_radio)

    status_label = Label.new()
    status_label.text = "Radio ready"
    layout.add_child(status_label)

func setup_radio_extension() -> void:
    if not ClassDB.class_exists("IcyRadioPlayer"):
        status_label.text = "Radio extension unavailable"
        push_error("IcyRadioPlayer extension was not loaded.")
        return

    radio_audio = AudioStreamPlayer.new()
    radio_audio.name = "RadioAudio"
    radio_audio.volume_db = -5.0
    add_child(radio_audio)

    radio = ClassDB.instantiate("IcyRadioPlayer")
    radio.set("player_path", NodePath("../RadioAudio"))
    add_child(radio)

    radio.connect(
        "state_changed",
        _on_radio_state_changed
    )

    radio.connect(
        "metadata_received",
        _on_metadata_received
    )

    radio.connect(
        "stream_failed",
        _on_stream_failed
    )

    status_label.text = "Radio ready"

func play_radio() -> void:
    if radio == null:
        status_label.text = "Radio extension unavailable"
        return

    var station_url := station_input.text.strip_edges()

    if station_url.is_empty():
        status_label.text = "Enter a radio URL"
        return

    status_label.text = "Connecting..."

    radio.call(
        "play",
        station_url,
        PackedStringArray(["User-Agent: Godot/4.5"])
    )

func stop_radio() -> void:
    if radio != null:
        radio.call("stop")
        status_label.text = "Radio stopped"

func _on_radio_state_changed(state: int) -> void:
    var states := [
        "Idle",
        "Connecting",
        "Buffering",
        "Playing",
        "Reconnecting",
        "Failed"
    ]

    if state >= 0 and state < states.size():
        status_label.text = states[state]

func _on_metadata_received(title: String) -> void:
    status_label.text = "Now playing: " + title

func _on_stream_failed(
    result: int,
    http_code: int
) -> void:
    status_label.text = "Stream error: HTTP " + str(http_code)
    push_warning(
        "Radio stream failed: %s, HTTP %d" %
        [str(result), http_code]
    )
