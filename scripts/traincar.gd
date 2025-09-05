extends Node3D
class_name TrainCar

signal car_entered

@export var prefab_enter_traincar: PackedScene
@export var prefab_exit_traincar: PackedScene

var enter_traincar: TrainCar
var exit_traincar: TrainCar

@onready var enter_trigger: Area3D = get_node(NodePath("enter_trigger"))

@onready var enter_door: Node3D = get_node(NodePath("door_enter/doorway"))
@onready var exit_door: Node3D = get_node(NodePath("door_exit/doorway"))

@onready var enter_portal_spawner: PortalSpawner = get_node(NodePath("door_enter/doorway/portal_spawner"))
@onready var exit_portal_spawner: PortalSpawner = get_node(NodePath("door_exit/doorway/portal_spawner"))


func _ready() -> void:
	enter_trigger.body_entered.connect(_on_body_entered_trigger)

func _on_body_entered_trigger(body: Node) -> void:
	if body is Player:
		enter()

func enter() -> void:
	car_entered.emit()
