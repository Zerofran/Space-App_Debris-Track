extends Control

#llamado de nodos simples
@onready var Date : Label = $TopBar/VBoxContainer/TopContainer/BarraSuperior/VBoxContainer/HBoxContainer/Date/ActualDate
@onready var menu : Node = $"../Camera_Control"

#llamado de nodos de inspeccion de las zonas de instancias
@onready var InstanceEnviroment_Debris : Node3D = $"../InstanceEnviroment/DebrisInstance" #aqui se instanciaran los debris
@onready var InstanceEnviromen : Node3D = $"../InstanceEnviroment"
@onready var SpaceEarthSistem =  $"../Globo terraqueo"


#llamado de nodos de inspeccion
@onready var Inspect1 = $SystemDebrisMenu/SplitContainer/VSplitPrincipal/VSplitLeftContainer/Inspect1_L_Up

#variables de la top bar
var DiaSemana : Array = ["Domingo","Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"]
var AmPm : String
var menuVisiviliti : bool = true

#variables de carga de datos en el boton de opsiones
var Url : String = "user://"
var archivos: Array = DirAccess.get_files_at(Url)
@export var SelectData_Icon = preload("res://debrisTrack_v1/HUD/HUD Icon/import.png")
@onready var selector : OptionButton = $TopBar/VBoxContainer/TopContainer/BarraSuperior/VBoxContainer/HBoxContainer/LoadData/SelectData
@onready var OK : Button = $TopBar/VBoxContainer/TopContainer/BarraSuperior/VBoxContainer/HBoxContainer/LoadData/OK

#cargando escena e inicio
var Main = load("res://debrisTrack_v1/Escenas/Main.tscn") #main


var second = 0
@export var futureSecond : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionCentered.visible = true
	
	if $TopBar.visible:
		$SystemDebrisMenu.visible = false
		menuVisiviliti = false
	else:
		$SystemDebrisMenu.visible = true
		menuVisiviliti = true
		pass
	menu.menu = menuVisiviliti
#mostrando las ociones disponibles
	opsiones()

func _process(delta: float) -> void:
#region Fecha y Hora

	var DictionariDate = Time.get_date_dict_from_system() 
	var hora = Time.get_datetime_dict_from_system()
	var HoraConvert
	if hora["hour"] >= 12:
		AmPm = " Pm"
		
	else:
		AmPm = " Am"
		
	Date.text =  DiaSemana[DictionariDate["weekday"]] + " " + str(DictionariDate["day"]) + "/" + str(DictionariDate["month"]) + "/" + str(DictionariDate["year"])
	Date.text = Date.text + " " + str(hora["hour"]) + ":" + str(hora["minute"]) + ":" + str(hora["second"]) + AmPm
	
#endregion
	#mostrar u ocultar el menu
	if Input.is_action_just_pressed("Menu"):
		SistemDebrisMenuVisible()

	if selector.get_selected_id() == 0:
		OK.disabled = true
	else:
		OK.disabled = false

func  opsiones():
	for i in archivos.size():
		var item = archivos[i]
		selector.add_item(item, i+1)
		selector.set_item_icon(i+1, SelectData_Icon)
	selector.select(0)

func SistemDebrisMenuVisible():
		menuVisiviliti = !menuVisiviliti
		menu.menu = menuVisiviliti
		$SystemDebrisMenu.visible = menuVisiviliti
		$TopBar.visible = !menuVisiviliti

func _on_ok_pressed() -> void:
	CSV.setting(Url, CSV.encavezado, selector.get_item_text(selector.get_selected_id()))
	var lista : Array = CSV._leer()
	InstanceEnviroment_Debris.DebrisInstance = lista

func _on_volver_pressed() -> void:
	get_tree().change_scene_to_packed(Main)


func _on_fast_time_2_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Engine.time_scale = 10
		SpaceEarthSistem.fastTime = true
		$"../Globo terraqueo".fastTime = true
		


func _on_fast_time_timeout() -> void:
	second += 1
	print(second)
