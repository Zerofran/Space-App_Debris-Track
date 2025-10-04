extends Control

var Fits_data = load("res://debrisTrack_v1/Escenas/fits_data.tscn")
var CSV_Visualiser = load("res://debrisTrack_v1/Escenas/csv_visualisador.tscn")
var Simulasion = load("res://debrisTrack_v1/Escenas/Debris_Track.tscn")
var Problemas = load("res://debrisTrack_v1/Escenas/problemas_del_programa.tscn")

@onready var anim : Node = $AnimationPlayer
@onready var transition : Node = $Trancition
var escene
func _ready():
	transition.visible = true
	anim.play("Fade_In")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_fits_data_pressed():
	escene = Fits_data
	transition.visible = true
	anim.play("Fade_Out")

func _on_data_base_check_pressed():
	escene = CSV_Visualiser
	transition.visible = true
	anim.play("Fade_Out")

func _on_simulation_pressed():
	escene = Simulasion
	transition.visible = true
	anim.play("Fade_Out")

func _on_problemas_pressed():
	escene = Problemas
	transition.visible = true
	anim.play("Fade_Out")

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Fade_In":
			transition.visible = false

		"Fade_Out":
			get_tree().change_scene_to_packed(escene)
		
