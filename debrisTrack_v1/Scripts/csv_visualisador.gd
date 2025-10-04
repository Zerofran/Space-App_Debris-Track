extends Control

@onready var selector:OptionButton = $Contenedor/Contenedor/ajustes/Select_data
@onready var organizar = $Contenedor/Contenedor/ajustes/Organizar
@onready var ok = $Contenedor/Contenedor/ajustes/Ok
@onready var ver_datos = $Contenedor/Contenedor/visualizar/ver_datos
var labelseting = preload("res://debrisTrack_v1/Extras/label_set_font2.tres")
var Main = load("res://debrisTrack_v1/Escenas/Main.tscn") #main

#-------------------------------Importar script-----------------------------------------------------
	# esto da acceso a las funciones para modificar los .csv
var CSV = preload("res://debrisTrack_v1/Scripts/CSV_Ctrl.gd").new()
	# esto da acceso a las funciones fisicas para calcular los Datos de los .Fits
var Math = preload("res://debrisTrack_v1/Scripts/Math.gd").new()

#-----------------------------------Declarar variables----------------------------------------------
var Url : String = "user://"
var archivos: Array = DirAccess.get_files_at(Url)
const  encavezado : Array = ["Id", "Nombre", "masa", "posicion", "altura", "asce recta i", "asce recta f",
"Declin i", "Declin f", "Vel angular", "Vel Tangencial", "Fecha", "Fecha Juliana", "Tiempo UTC"]

@export var SelectData_Icon = preload("res://debrisTrack_v1/HUD/HUD Icon/import.png")

var EmptyArrayLeng

func _ready():
	opsiones()

func _process(_delta):
	if selector.get_selected_id() == 0:
		ok.disabled = true
		organizar.disabled = true
	else:
		ok.disabled = false
		organizar.disabled = false

func  opsiones():
	for i in archivos.size():
		var item = archivos[i]
		selector.add_item(item, i+1)
		selector.set_item_icon(i+1, SelectData_Icon)
	selector.select(0)

func _on_ok_pressed():
	CSV.setting(Url,encavezado, selector.get_item_text(selector.get_selected_id()))
	var lista:Array = CSV._leer()
	EmptyArrayLeng = lista[0].size()  # con esto se sabe cuantos objetos abra en cada columna
	nodeCriate(lista)


func _on_organizar_pressed():
	var Datos:Array = optenerDatos()
	var datosOrganizados:Array = organizarDatos(Datos)
	nodeCriate(datosOrganizados)
	
func _on_guardar_pressed():
	var Datos:Array = optenerDatos()
	CSV._Re_escribir(Datos)
	print_rich("[color=green][b]¡Los datos se guardaron con exito![/b][/color]")
	
func _on_guardar_como_pressed() -> void:
	$GuardarComo/FileDialog.visible = true
	
func _on_volver_pressed():
	get_tree().change_scene_to_packed(Main)

func _on_nueva_fila_pressed() -> void:
	NewFileNode()

func _on_quitar_fila_pressed() -> void:
	deletFileNode()

#ayuda a guarar un archivo nuevo a partir el que ya se abia creado
func _on_file_dialog_confirmed() -> void:
	var file_sistem : FileDialog = $GuardarComo/FileDialog
	CSV.setting(file_sistem.current_dir, CSV.encavezado, file_sistem.get_line_edit().text)
	CSV._Re_escribir(optenerDatos())
	file_sistem.get_line_edit().text = ""

#crea los nodos en la pantalla con la informacion del CSV
func nodeCriate(datos:Array, ExpandText : bool = false) -> void:
	for i in ver_datos.get_children().size():
		ver_datos.get_children()[i].queue_free()
			
	for i in datos.size():
		#crear nodos
		var fila = HBoxContainer.new()
		ver_datos.add_child(fila)
		for a in datos[i].size():
			var line = LineEdit.new()
			line.expand_to_text_length = ExpandText
			line.text = datos[i][a]
			line.custom_minimum_size = Vector2(200, 30)
			line.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
			if i == 0: #i controlalas filas
				line.editable = false
			if a == 0: #a controla las columnas
				line.editable = false
				line.custom_minimum_size = Vector2(0, 0)
				
			fila.add_child(line) # instanciar el nodo de lineEdit

			if a == datos[i].size() - 1 and i != 0: #cuando ya sea el ultimo espacio
				var boton = Button.new()
				var deleteButton = load("res://debrisTrack_v1/Scripts/DeleteButton.gd")
				boton.text = "X"
				boton.modulate = Color("red")
				#boton.set_name("delet")
				boton.custom_minimum_size = Vector2(40, 40)
				boton.tooltip_text = "elimina la \nfila completa"
				boton.set_script(deleteButton)
				#boton.pressed.connect(self._button_pressed)
				fila.add_child(boton) #instanciar el boton

#crea una nueva fila
func NewFileNode() -> void:
	var EmptyArray :Array = []
	var array : Array = optenerDatos()
	for i in EmptyArrayLeng:
		EmptyArray.append("")
	EmptyArray[0] = str(array.size()) 
	array.append(EmptyArray)
	print(array)
	nodeCriate(array)
	
#borra una fila
func deletFileNode() -> void:
	var array : Array = optenerDatos()
	array.remove_at(array.size() - 1 )
	nodeCriate(array)

#optinene los datos de los lineEdit
func optenerDatos() -> Array:
	var getData : Array = ver_datos.get_children()  # getData son los nodos en godot
	#print(getData[2].get_children(), " array de nodos")
	var datos: Array = [] # datos representa un array2D
	
	for i in getData.size():
		var agregar: Array = []
		for a in getData[i].get_children().size():
			var x = getData[i].get_children()[a] # x representa cada elemento de un array
			var tipoNodo = x.get_class()
		#quedara asi de momento pero luego del array[0] se formatearan los valores
		#para poder tener un arrray con variables operables
			if tipoNodo == "LineEdit":
				agregar.append(x.text) # agregar representa un array
		datos.append(agregar) # datos representa un array2D
	return datos

#condiciones para la funcion de organizacion
func sort_ascending(a, b):
	if a[-2] < b[-2]:
		return true
	return false

#Organiza los datos de menor a mayor
func organizarDatos(lista:Array)->Array:
	var titulo = lista[0]
	lista.remove_at(0)
	lista.sort_custom(sort_ascending)
	lista.insert(0, titulo)
	return lista
