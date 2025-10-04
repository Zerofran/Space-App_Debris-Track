
extends Control

#-----------------------------------Referenciar Nodos-----------------------------------------------
#region Referencia hacia los nodos
@onready var NewBaseDatos : Node  = $VBoxContainer/UI_Hbox/Imput_container/Basedatos_Container/baseDatos_input
@onready var selector : OptionButton = $VBoxContainer/UI_Hbox/Imput_container/Select_data
@onready var selectorTipo : OptionButton = $VBoxContainer/UI_Hbox/Imput_container/Select_Type
@onready var Dia : Node = $VBoxContainer/UI_Hbox/Imput_container/Fecha_avistamiento/Dia
@onready var mes : Node = $VBoxContainer/UI_Hbox/Imput_container/Fecha_avistamiento/Mes
@onready var año : Node = $"VBoxContainer/UI_Hbox/Imput_container/Fecha_avistamiento/Año"
@onready var hora : Node = $VBoxContainer/UI_Hbox/Imput_container/Tiempo_avistamiento/Horas
@onready var minutos : Node = $VBoxContainer/UI_Hbox/Imput_container/Tiempo_avistamiento/Minutos
@onready var segundos : Node = $VBoxContainer/UI_Hbox/Imput_container/Tiempo_avistamiento/Segundos
@onready var AR_horas_i : Node = $VBoxContainer/UI_Hbox/Imput_container/Ascencion_recta/Horas
@onready var AR_minutos_i : Node = $VBoxContainer/UI_Hbox/Imput_container/Ascencion_recta/Minutos
@onready var AR_segundos_i : Node = $VBoxContainer/UI_Hbox/Imput_container/Ascencion_recta/Segundos
@onready var AR_horas_f : Node = $VBoxContainer/UI_Hbox/Imput_container/Ascencion_recta2/Horas
@onready var AR_minutos_f : Node = $VBoxContainer/UI_Hbox/Imput_container/Ascencion_recta2/Minutos
@onready var AR_segundos_f : Node = $VBoxContainer/UI_Hbox/Imput_container/Ascencion_recta2/Segundos
@onready var D_Grados_i : Node = $VBoxContainer/UI_Hbox/Imput_container/Declinacion/Grados
@onready var D_Minutos_i : Node = $VBoxContainer/UI_Hbox/Imput_container/Declinacion/Minutos
@onready var D_Segundos_i : Node =  $VBoxContainer/UI_Hbox/Imput_container/Declinacion/Segundos
@onready var D_Grados_f : Node = $VBoxContainer/UI_Hbox/Imput_container/Declinacion2/Grados
@onready var D_Minutos_f : Node = $VBoxContainer/UI_Hbox/Imput_container/Declinacion2/Minutos
@onready var D_Segundos_f : Node = $VBoxContainer/UI_Hbox/Imput_container/Declinacion2/Segundos
@onready var format_date : Node = $VBoxContainer/UI_Hbox/Imput_container/Fecha_avistamiento/format_date
@onready var FechaJuliana : Node = $VBoxContainer/UI_Hbox/Imput_container/Fecha_avistamiento/FechaJuliana
@onready var Camera_exposure_Min: Node = $VBoxContainer/UI_Hbox/Imput_container/Exposicion_time/Minutos
@onready var Camera_exposure_S: Node = $VBoxContainer/UI_Hbox/Imput_container/Exposicion_time/Segundos
	#salidas del programa
@onready var salida : Node = $VBoxContainer/UI_Hbox/Output_container/Output
#endregion
	#trancision del programa
@onready var anim : Node = $AnimationPlayer
@onready var transition = $Trancition


#-----------------------------------Declarar variables----------------------------------------------
#var Url : String = "res://debrisTrack_v1/Csv/"
var Url : String = "user://"
const  encavezado : Array = ["Id", "Nombre", "Tipo", "masa", "posicion", "altura", "asce recta i", "asce recta f",
"Declin i", "Declin f", "Vel angular", "Vel Tangencial", "Fecha", "Fecha Juliana", "Tiempo UTC"]
var archivos: Array = DirAccess.get_files_at(Url)
@export var SelectData_Icon = preload("res://debrisTrack_v1/HUD/HUD Icon/import.png")

#-----------------------------------Variables de Debris---------------------------------------------
var contador : int = 0
var masa : float
var ascencionRecta : Array
var Declinacion : Array
var nombreDebris : String = "Debris_"
var stadoFormat : bool = false
#-----------------------------------Cambio de escena---------------------------------------------
var Main = load("res://debrisTrack_v1/Escenas/Main.tscn")
#---------------------------------------------------------------------------------------------------
func _ready():
	
#region evaluando las funciones de conversion
	#var x = Math.gregoriano_a_juliano(29,2,2024,12,45,40)
	#print(x, " conversion a juliana")
	#x = 2459946.55544043
	#print(Math.juliano_a_gregoriano(x), " de juliano a gregoriano")
#endregion
	transition.visible = true
	anim.play("Fade_In")
	opsiones()

func _process(_delta):
	var OK : Button = $VBoxContainer/UI_Hbox/Imput_container/Basedatos_Container/Ok
	if NewBaseDatos.text != "":
		OK.disabled = false
	else:
		OK.disabled = true
		
	if Input.is_action_just_pressed("p"):
		pass

func  opsiones():
	for i in archivos.size():
		var item = archivos[i]
		selector.add_item(item, i+1)
		selector.set_item_icon(i+1, SelectData_Icon)
	selector.select(0)

func config_datosDebris():
	pass

func _on_ok_pressed():

	if NewBaseDatos.text != "":
		var nombre = NewBaseDatos.text + ".csv"
		CSV.setting(Url, encavezado, nombre)
		CSV._escribir()
		NewBaseDatos.text = ""
		get_tree().reload_current_scene()
	

func _on_extraer_info_pressed():
	
#transformar la fecha gregoriana a juliana
	var TiempoUTC : Array = [int(hora.text), int(minutos.text), float(segundos.text)]
	var JulianDate : float = float(FechaJuliana.text)
	var GregorianDate = [int(Dia.text), int(mes.text), int(año.text), int(hora.text), int(minutos.text), float(segundos.text)]
	if stadoFormat: #si es true el formato juliano esta activado, hay que convertir a gregoriano
		GregorianDate = Math.juliano_a_gregoriano(float(FechaJuliana.text))
		print(GregorianDate, "de juliana a gregoriana")
	else: #si es false el formato juliano esta desactivado, hay que convertir a juliano
		JulianDate = Math.gregoriano_a_juliano(int(Dia.text), int(mes.text), int(año.text), int(hora.text), int(minutos.text), float(segundos.text)) 
		print(JulianDate, "de gregoriano a juliana")
	
		
#transformar la exposicion a segundos
	var Timecamera = (int(Camera_exposure_Min.text) * 60) + float(Camera_exposure_S.text)
#optener que base de datos es la seleccionada
	var baseDatos = selector.get_item_text(selector.get_selected_id())
	CSV.setting(Url, CSV.encavezado, baseDatos)
	var num = CSV._leer()
	contador = num.size()
	nombreDebris = "Debris_" + str(contador)
	
#region Realizar calculos para encontrar maasa y posicion celeste en cartecianas
	var AR_i = Math.A_Recta_A_grados(int(AR_horas_i.text), int(AR_minutos_i.text), float(AR_segundos_i.text))
	var D_i =  Math.Declinacion_A_grados(int(D_Grados_i.text), int(D_Minutos_i.text), float(D_Segundos_i.text))
	var AR_f = Math.A_Recta_A_grados(int(AR_horas_f.text), int(AR_minutos_f.text), float(AR_segundos_f.text))
	var D_f =  Math.Declinacion_A_grados(int(D_Grados_f.text), int(D_Minutos_f.text), float(D_Segundos_f.text))
	var V_angular = Math.DebrisAngularVelocity_magnitud(D_i, D_f, AR_i, AR_f, Timecamera)
	var r = Math.Debris_r_magnitud(V_angular)
	var r_VectorDebris = Math.CoordenadasHorarias_A_Cartecianas(AR_f, D_f, r)
	var V_Tangencial = Math.TangencialVelocity(V_angular, r_VectorDebris)
	masa = Math.DebrisMass(r, V_angular)
#endregion

#region tomar y guardar informacion en el CSV
	var AR_i_array : Array = [int(AR_horas_i.text), int(AR_minutos_i.text), float(AR_segundos_i.text)]
	var AR_f_array : Array = [int(AR_horas_f.text), int(AR_minutos_f.text), float(AR_segundos_f.text)]
	var D_i_array : Array = [int(D_Grados_i.text), int(D_Minutos_i.text), float(D_Segundos_i.text)]
	var D_f_array : Array = [int(D_Grados_f.text), int(D_Minutos_f.text), float(D_Segundos_f.text)]
	var tipo : String = selectorTipo.get_item_text(selectorTipo.get_selected_id())
	var datosescritura : Array = [str(contador), nombreDebris ,tipo ,masa, r_VectorDebris, r, AR_i_array, AR_f_array,
	D_i_array, D_f_array, V_angular, V_Tangencial, GregorianDate, JulianDate, TiempoUTC]
	CSV._escribir(datosescritura)
#endregion

# mostrar informacion en el label
	
	salida.text = str(encavezado) + "\n" + str(datosescritura)

func _on_format_date_pressed():
	FechaJuliana.visible = !stadoFormat
#region cambio de formato de fecha
	var fleca : Node = $VBoxContainer/UI_Hbox/Imput_container/Fecha_avistamiento/fleca
	var fleca2 : Node = $VBoxContainer/UI_Hbox/Imput_container/Fecha_avistamiento/fleca2
	Dia.visible = stadoFormat
	mes.visible = stadoFormat
	año.visible = stadoFormat
	fleca.visible = stadoFormat
	fleca2.visible = stadoFormat
#endregion
	stadoFormat = !stadoFormat
	print(stadoFormat)


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Fade_In":
			transition.visible = false
		"Fade_Out":
			get_tree().change_scene_to_packed(Main)

func _on_volver_pressed():
	anim.play("Fade_Out")
	transition.visible = true
