
extends Node3D

const MobileControls = preload("res://scripts/mobile_controls.gd")
const CBRadio = preload("res://systems/cb_radio.gd")

@export var world_label: String = "Open-World Truck Survival Simulator"

@onready var truck: CharacterBody3D = $Truck

var cockpit_mode: bool = false
var cb_radio: CanvasLayer

func _ready() -> void:
    print("Loaded: ", world_label)
    create_world()
    connect_mobile_controls()
    create_cb_radio()

func create_world() -> void:
    var road_mesh := BoxMesh.new()
    road_mesh.size = Vector3(12.0, 0.15, 200.0)

    var road := MeshInstance3D.new()
    road.name = "Highway"
    road.mesh = road_mesh
    road.position = Vector3(0.0, -0.35, 0.0)
    add_child(road)

func connect_mobile_controls() -> void:
    var controls = MobileControls.new()
    add_child(controls)

    controls.steering_changed.connect(truck.set_steering)
    controls.throttle_changed.connect(truck.set_throttle)
    controls.brake_changed.connect(truck.set_brake)

    controls.engine_brake_changed.connect(
        truck.set_engine_brake_stage
    )

    controls.camera_switch_requested.connect(switch_camera)
    controls.windows_toggle_requested.connect(toggle_windows)

func create_cb_radio() -> void:
    cb_radio = CBRadio.new()
    add_child(cb_radio)

    print("CB radio installed.")

func switch_camera() -> void:
    cockpit_mode = not cockpit_mode

    if cockpit_mode:
        truck.get_node("CockpitCamera").make_current()
    else:
        truck.get_node("Camera3D").make_current()

func toggle_windows() -> void:
    truck.get_node("Cabin").toggle_windows()

