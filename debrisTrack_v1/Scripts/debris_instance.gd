extends Node3D

@export var DebrisInstance : Array
@export var Instace : bool = false
var Contador : int = 1
var Body_Instance : PackedScene = preload("res://debrisTrack_v1/Escenas/body_instance.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation = $"../../Globo terraqueo/Space/Tierra".rotation
	
	if DebrisInstance != [] and Instace == true:
		print(DebrisInstance, "Datos recibidos por los debris ")
		var debris : RigidBody3D = Body_Instance.instantiate()
		debris.ID = int(DebrisInstance[Contador][0])
		debris.nombre = DebrisInstance[Contador][1]
		debris.Masa = float(DebrisInstance[Contador][3])
		debris.position = CSV.string_to_vector3d(DebrisInstance[Contador][4])
		debris.linear_velocity = CSV.string_to_vector3d(DebrisInstance[Contador][11]) 
		add_child(debris)
		Contador += 1
	if Contador == DebrisInstance.size()-1:
		Instace = false
