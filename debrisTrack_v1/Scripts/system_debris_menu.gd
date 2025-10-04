extends Control

var InternetConect : bool
var CallQuery : bool = true
var timerStop : bool = false
var OBJ_Data = []

#apis
var Api1 : String = "https://api.wheretheiss.at/v1/satellites/25544"
var Api2 : String = "https://www.n2yo.com/api/"

#nodos 
@onready var Consola = $SplitContainer/VSplitPrincipal/Inspect3_R/ScrollContainer/Container3/Consola
@onready var Anotaciones = $SplitContainer/VSplitPrincipal/Inspect3_R/ScrollContainer/Container3/Anotaciones
@onready var Coliciones = $SplitContainer/VSplitPrincipal/Inspect3_R/ScrollContainer/Container3/Coliciones
@onready var HTTP = $"../HTTPRequest"

@onready var ApiAcces = $SplitContainer/VSplitPrincipal/VSplitLeftContainer/Inspect2_L_Dawn/HBoxContainer/VContainer2/Container2/VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/ApiAcces
@onready var DataCollision = $SplitContainer/VSplitPrincipal/VSplitLeftContainer/Inspect2_L_Dawn/HBoxContainer/VContainer2/Container2/VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/DataCollicionTrack
@onready var ObjectHUD = $SplitContainer/VSplitPrincipal/VSplitLeftContainer/Inspect2_L_Dawn/HBoxContainer/VContainer2/Container2/VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/ObjectHUDContainer
@onready var buscador = $SplitContainer/VSplitPrincipal/VSplitLeftContainer/Inspect2_L_Dawn/HBoxContainer/VContainer2/buscador
@onready var AnimSignal = $SplitContainer/VSplitPrincipal/VSplitLeftContainer/Inspect2_L_Dawn/HBoxContainer/VContainer2/Container2/VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/ApiAcces/Network/Signal
@onready var NetworkSwitch = $SplitContainer/VSplitPrincipal/VSplitLeftContainer/Inspect2_L_Dawn/HBoxContainer/VContainer2/Container2/VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/ApiAcces/Network/Network
@onready var TiempoEspera = $SplitContainer/VSplitPrincipal/VSplitLeftContainer/Inspect2_L_Dawn/HBoxContainer/VContainer2/Container2/VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/ApiAcces/Network/TiempoEspera

@onready var hsplit = $SplitContainer/VSplitPrincipal

#nodo done de instancian los debris
@onready var DebrisInstance = $"../../InstanceEnviroment/DebrisInstance"

#nodo que se va a instancear
var Body_Instance : PackedScene = preload("res://debrisTrack_v1/Escenas/body_instance.tscn")
var instance
func _ready() -> void:
	var bodyVisual = preload("res://debrisTrack_v1/Escenas/body_instance.tscn")
	instance = bodyVisual.instantiate()
	instance.position = Math.Lat_lon_convert_to_cartesian(0, 10, 20)
	DebrisInstance.add_child(instance)
	
	AnimSignal.texture.current_frame = 0

func _process(delta: float) -> void:
	instance.position = Math.Lat_lon_convert_to_cartesian(0, -20, 20)
	#bloqueando el deslizador horizontal
	hsplit.split_offset = clamp(hsplit.split_offset, 180, 800)
	
	if Input.is_action_just_pressed("ui_left"):
		print($"../../InstanceEnviroment/DebrisInstance".get_children())
		print(OBJ_Data)
		print(OBJ_Data.size())
		print(OBJ_Data[1]["latitude"], " deberia ser la latitud")

#region Funciones Nuevas
func Request(URL : String = "https://api.wheretheiss.at/v1/satellites/25544"): #25544 identificador de la ISS
	if !timerStop:
		$"../TimerWhereTheIss".start(3)
	var error = HTTP.request(URL)
	if error != OK:
		Consola.append_text("[center][color=red]A Ocurrido un error en la coneccion, se reintara de nuevo, verifique coneccion a internet [/color][/center]")

#endregion

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var output = body.get_string_from_utf8()
	var JsonResult : JSON = JSON.new()
	JsonResult.parse(output)
	var response = JsonResult.get_data()
	
	if response: # si la llamada no retorna un Null entonses
		Consola.append_text("[center][color=purple]La petecion se cumplio con exito:[/color][/center]")
		Consola.append_text("[center][color=green]"+ str(response) + "[/color][/center]")
		Consola.append_text("[center][color=green]"+ str(Time.get_datetime_dict_from_system()) + "[/color][/center]")
		OBJ_Data.append(response)
		print(Time.get_datetime_dict_from_system(true), " hora de la llamada")
		print(OBJ_Data)

	else:
		Consola.append_text("[center][color=red]----Retorno de elemento basio [], verifique coneccion a internet----[/color][/center]")
		
	if OBJ_Data.size() == 2:
		CallQuery = false
		Consola.append_text("[center][color=purple]2 paquetes de datos an sido optenidos con exito[/color][/center]")
		
	HTTP.cancel_request()


#aqui se realiza la llamada a la api cada 2 segundos
func _on_timer_where_the_iss_timeout() -> void:
	if CallQuery:
		Consola.append_text("[center][color=purple]-----Inicio de llamada-----[/color][/center]")
		Request()
	else:
		$"../TimerWhereTheIss".stop()
		timerStop = true
		
		var instance : Node3D = Body_Instance.instantiate()
		instance.mass = Math.IssMass
		instance.position = Math.Lat_lon_convert_to_cartesian(OBJ_Data[1]["latitude"], OBJ_Data[1]["longitude"], OBJ_Data[1]["altitude"])
		instance.ID = OBJ_Data[1]["id"]
		instance.nombre = OBJ_Data[1]["name"]
		$"../../InstanceEnviroment/DebrisInstance".add_child(instance)
		print(instance.position, " Posicion de la iss")
		print("Datos optenidos de las llamadas")
		#print(OBJ_Data)
		



func _on_line_edit_text_changed(new_text: String) -> void:
	var lista = ObjectHUD.get_children()
	for i in lista.size():
		if (str(lista[i].get_name()).to_lower()).similarity(new_text.to_lower()) > 0.3 :
			lista[i].visible = true
		else:
			lista[i].visible = false
	if new_text == "":
		for i in lista.size():
			lista[i].visible = true


func _on_network_toggled(toggled_on: bool) -> void:
	if toggled_on:
		NetworkSwitch.text = "Network On"
		Consola.append_text("[left][color=green]Se han consedido permisos de acceso a la red de internet[/color][/left]")
	else:
		Consola.append_text("[left][color=red]Se han canselado permisos de acceso a la red de internet[/color][/left]")
		AnimSignal.texture.current_frame = 0
		NetworkSwitch.text = "Network Off"
	AnimSignal.texture.pause = !toggled_on

#region botones
func VisibleContainer(Contain : int):
	if Contain == 1: #esto muestra solo el buscador de objetos
		ObjectHUD.visible = true
		DataCollision.visible = false
		ApiAcces.visible = false
		buscador.visible = true

	if Contain == 2:#esto muestra 
		ObjectHUD.visible = false
		DataCollision.visible = true
		ApiAcces.visible = false
		buscador.visible = false

	if Contain == 3:
		ObjectHUD.visible = false
		DataCollision.visible = false
		ApiAcces.visible = true
		buscador.visible = false

func _on_objeto_pressed() -> void:
	Consola.append_text("[left][color=white]El visualizador HUD de objetos se ha activado[/color][/left]")
	VisibleContainer(1)

func _on_registro_coliciones_pressed() -> void:
	Consola.append_text("[left][color=white]El visualizador de colisiones de objetos se ha activado[/color][/left]")
	VisibleContainer(2)

func _on_online_pressed() -> void:
	Consola.append_text("[left][color=white]Ajustes de coneccion Online consedido[/color][/left]")
	VisibleContainer(3)

func _on_anotaciones_toggled(toggled_on: bool) -> void:
	if toggled_on == false: 
		Consola.append_text("[left][color=white]El visualizador de anotaciones se ha ocultado[/color][/left]")
	Anotaciones.visible = toggled_on

func _on_cmd_toggled(toggled_on: bool) -> void:
	Consola.visible = toggled_on

#endregion

func _on_iss_instance_pressed() -> void:
	pass # Replace with function body.
