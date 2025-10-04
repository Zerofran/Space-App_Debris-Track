extends Node

@onready var tierra :MeshInstance3D = $Space/Tierra
@onready var Admosfera: MeshInstance3D = $Space/Tierra/Admosfera
@onready var sol : Node3D = $"../Entorno/Sol/Sun_Position"


func _ready():
	
	pass


func _process(delta):
#-----Opteniendo la hora en UTC en segundos-----#
	var UTC_Time = Time.get_time_dict_from_system(true)
	var UTC_TIME_s = Time.get_unix_time_from_datetime_dict(UTC_Time)
	#print(UTC_Time, " Tiempo en UTC")
	#print(UTC_TIME_s, " Tiempo UTC en segundos")
	#print(UTC_Time["hour"] * 3600 + UTC_Time["minute"] * 60 + UTC_Time["second"],  " segundos calculados")
	
#-----Mandar la posicion del sol a la tierra-----#
	tierra.get_active_material(0).set_shader_parameter("Objeto", sol.global_position)
	Admosfera.get_active_material(0).set_shader_parameter("Objeto", sol.global_position)
	
#-----controla la rotacion de la tierra-----#
	tierra.rotation.y = second_to_rad(UTC_TIME_s)#second_to_rad(12 * 3600 + 0 * 60 + 0)

func second_to_rad(Segundos:float) -> float:
#----convertir segundos a grados----#
	var x = Segundos / 3600   
	x = x * 15 - 180
#----convertir grados a radianes----#
	x = deg_to_rad(x)
	return x
	
