extends Node

##TODO don't require spawning. just have a parent scene that loads all of it?
##TODO portals can be spawned but deactivated in this case. and the system can just activate them.

@export var starting_car: PackedScene
@export var surrounded_car_culling := 1

var offset = 20.0
var current_offset = 0.0

var active_car: TrainCar

func _ready() -> void:
	if starting_car:
		var first_car = spawn_car(starting_car)
		first_car.enter()

func spawn_car(prefab: PackedScene) -> TrainCar:
	var new_car = prefab.instantiate() as TrainCar
	add_child(new_car)
	new_car.transform = Transform3D.IDENTITY # todo modify this
	new_car.translate(Vector3(current_offset, 0, 0))
	current_offset += offset
	new_car.car_entered.connect(_on_car_entered.bind(new_car))

	return new_car

static func link_cars(first_car: TrainCar, second_car: TrainCar) -> void:
	first_car.exit_traincar = second_car
	first_car.exit_portal_spawner.link(second_car.enter_portal_spawner)

	second_car.enter_traincar = first_car
	second_car.enter_portal_spawner.link(first_car.exit_portal_spawner)

static func sever_cars(first_car: TrainCar, second_car: TrainCar) -> void:
	if first_car.exit_traincar == second_car:
		first_car.exit_traincar = null
		first_car.exit_portal_spawner.remove_portal()

	if second_car.enter_traincar == first_car:
		second_car.enter_traincar = null
		second_car.enter_portal_spawner.remove_portal()

func clean_up_cars() -> void:
	clean_up_cars_in_direction("enter_traincar")
	clean_up_cars_in_direction("exit_traincar")

func clean_up_cars_in_direction(direction: String = "enter_traincar") -> void:
	var cars_to_remove := []
	var distance = 0
	var car = active_car
	while car != null:
		if distance > surrounded_car_culling:
			cars_to_remove.append(car)
		distance += 1
		car = car.get(direction)

	for car_to_remove in cars_to_remove:
		remove_car(car_to_remove)

func remove_car(car: TrainCar) -> void:
	if car.enter_traincar:
		sever_cars(car.enter_traincar, car)
	if car.exit_traincar:
		sever_cars(car, car.exit_traincar)
	car.queue_free()

func _on_car_entered(car: TrainCar) -> void:
	if active_car == car:
		return

	print("Entered car: ", car)
	active_car = car

	clean_up_cars()

	if active_car.exit_traincar == null and active_car.prefab_exit_traincar:
		print("Spawning exit car")
		var exit_car = spawn_car(active_car.prefab_exit_traincar)
		link_cars(active_car, exit_car)
	
	if active_car.enter_traincar == null and active_car.prefab_enter_traincar:
		print("Spawning enter car")
		var enter_car = spawn_car(active_car.prefab_enter_traincar)
		link_cars(enter_car, active_car)
