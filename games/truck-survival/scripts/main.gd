
extends Node3D

@export var world_label: String = "Open-World Truck Survival Simulator"

func _ready() -> void:
    print("Loaded: ", world_label)
    create_world()

func create_world() -> void:
    # Create a large placeholder terrain
    var ground_mesh := BoxMesh.new()
    ground_mesh.size = Vector3(200.0, 1.0, 200.0)

    var ground := MeshInstance3D.new()
    ground.name = "WorldGround"
    ground.mesh = ground_mesh
    ground.position = Vector3(0.0, -1.0, 0.0)
    add_child(ground)

    # Create a simple road
    var road_mesh := BoxMesh.new()
    road_mesh.size = Vector3(12.0, 0.15, 200.0)

    var road := MeshInstance3D.new()
    road.name = "Highway"
    road.mesh = road_mesh
    road.position = Vector3(0.0, -0.35, 0.0)
    add_child(road)

    print("Starter world created.")
