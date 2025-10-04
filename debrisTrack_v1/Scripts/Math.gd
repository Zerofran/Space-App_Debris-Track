extends Node
#-----------------------------Declarar variables-------------------------
#Todas la unidades de medida estan en  el SI
const  G = 6.67e-11
const tierraMasa = 5.972e24 #en kilogramos
const earth_radius = 6371000.0  # Radio de la Tierra en metros
const IssMass = 419725 #en kilogramos

#-------------funciones propias del motor pertenecientes a la clase node---------------
func _ready():
	#print_rich("[color=green][b]Prueba de convercion[/b][/color]")
	#var dia_juliano = gregoriano_a_juliano(1, 2, 2002 , 12, 1, 20)
	#print_rich("[color=green][b]El día juliano es: [/b][/color]", dia_juliano)
	#print_rich("[color=green][b]El dia gregoriano es: [/b][/color]", juliano_a_gregoriano(dia_juliano))
	pass
	
#region aqui van las funciones que manejan la matematica y la fisica del programa
#-------------------------------Ecuaciones Fisicas y matematicas-----------------------------------

#la fuerza que 2 ejerce en 1 o el cuerpo que llame la funcion
func GravityNewton(mass_1: float, mass_2: float, pos_i: Vector3, pos_f: Vector3, Escala: int = 1) -> Vector3:
		var r = pos_f - pos_i
		var V_absoluto = r.length()
		var V_absoluto_cubo = pow(V_absoluto, 3)
		var masas = mass_1 * mass_2 
		var parte1 = ( masas/V_absoluto_cubo)
		var F = r * parte1 * G
		return F * Escala
	
#region Transformacione
#funciones de trasnformacion
func A_Recta_A_grados(horas: int , minutos: int, segundos:float):
	#----------Para la Ascencion recta---------------
	#Esta funcion transforma las coordenadas horarias en grados 
	var gradosTotales = 15 * (horas + (minutos/60.0) + (segundos/3600.0))
	return gradosTotales
	#----------Para la Ascencion recta---------------
	
func Declinacion_A_grados(grados: int, minutos:int, segundos: float):
	#----------Para la Declinacion---------------
	#esta funcion trasforma los grados declinados en grados ordinarios de la declinacion
	var signo = 1 if grados >= 0 else -1
	var gradosTotales = signo * (abs(grados) + (minutos / 60.0) + (segundos/3600.0))
	return gradosTotales
	
func CoordenadasHorarias_A_Cartecianas(AR:float, D:float, r:float):
	var AR_rad = deg_to_rad(AR)
	var D_rad = deg_to_rad(D)
	var X = r * cos(D_rad) * cos(AR_rad)
	var Y = r * sin(D_rad) #el eje Y se usa como altura
	var Z = r * cos(D_rad) * sin(AR_rad)
	return Vector3(X, Y, Z)
	
# Convertir de coordenadas geográficas (lat, lon, alt) a coordenadas cartesianas 3D
func Lat_lon_convert_to_cartesian(lat: float, lon: float, alt: float) -> Vector3:
	# Convertir latitud y longitud de grados a radianes
	#lon = lon * -1
	lat = deg_to_rad(lat) 
	lon = deg_to_rad(lon)
	# Calcular las coordenadas cartesianas
	var x = (earth_radius + alt) * cos(lat) * cos(lon)
#aqui se multiplica por -1 para que coisida con la conveniencia de signos de los sitemas geograficos anguares
	var z = (earth_radius + alt) * cos(lat) * sin(lon)  * -1 # En 3D, z toma el rol de longitud
	var y = (earth_radius + alt) * sin(lat)  # Altitud se asocia al eje Y en Godot

	return Vector3(x, y, z)
	
func velocity_cal(magnitude, rf, ri, km_h = false)-> Vector3:
	if km_h:
		magnitude = (magnitude * 1000)/3600.0
	var vector : Vector3 = rf - ri
	var UnityVector = vector.normalized()
	return (UnityVector * magnitude)
	
#para los debris de los .fits
func  DebrisMass(radio: float, V_angular:float):
	var Mass = ((pow(V_angular, 2) * pow(radio, 3))/G) - tierraMasa
	return Mass
	
func Debris_r_magnitud(_V_angular):
	var _numerador = G * tierraMasa
	var _denominador = pow(_V_angular, 2)
	var _r_magnitud: float = pow(_numerador/_denominador, 1.0/3.0)
	return _r_magnitud

func DebrisAngularVelocity_magnitud(Dec_i: float, Dec_f: float, AR_i: float, AR_f: float, TimeCamera:float):
	var W_ar = (AR_f - AR_i)/TimeCamera
	var W_d = (Dec_f - Dec_i)/TimeCamera
	var W = sqrt( pow(W_ar,2) + pow(W_d,2) )
	return W

func TangencialVelocity(AgularV: float, r_vector: Vector3):
	var V: Vector3 = AgularV * r_vector
	return V


#endregion


#region esta parte controla la conversion entre fechas
func gregoriano_a_juliano(dia: int, mes: int, año: int, hora: int, minutos: int, segundos: float) -> float:
	# Ajuste de mes y año para el calendario astronómico
	var mes_ajustado = mes
	var año_ajustado = año

	if mes_ajustado <= 2:
		mes_ajustado += 12
		año_ajustado -= 1

	# Cálculo de términos
	var AA = floor(365.25 * (año_ajustado + 4716))
	var MM = floor(30.6001 * (mes_ajustado + 1))
	var DD = dia + (hora / 24.0) + (minutos / 1440.0) + (segundos / 86400.0)
	var B = 2 - floor(año_ajustado / 100.0) + floor(floor(año_ajustado / 100.0) / 4)

	# Cálculo del día juliano
	var DJ = AA + MM + DD - B - 1524.5 - 26

	return DJ

func juliano_a_gregoriano(dia_juliano: float) -> Dictionary:
	# Ajuste del día juliano
	var DJ = dia_juliano + 0.5

	# Cálculo de términos
	var Z = floor(DJ)
	var F = DJ - Z

	var A = Z
	if Z >= 2299161:
		var α = floor((Z - 1867216.25) / 36524.25)
		A = Z + 1 + α - floor(α / 4)

	var B = A + 1524
	var C = floor((B - 122.1) / 365.25)
	var D = floor(365.25 * C)
	var E = floor((B - D) / 30.6001)

	var dia = B - D - floor(30.6001 * E) + F

	var mes = E
	if E < 14:
		mes -= 1
	else:
		mes -= 13

	var año = C
	if mes > 2:
		año -= 4716
	else:
		año -= 4715

	# Ajuste de la hora, minutos y segundos
	var hora = floor((dia - floor(dia)) * 24)
	var minutos = floor(((dia - floor(dia)) * 24 - hora) * 60)
	var segundos = ((((dia - floor(dia)) * 24 - hora) * 60 - minutos) * 60)

	# Devolver el resultado como un diccionario
	return {
		"dia": floor(dia),
		"mes": mes,
		"año": año,
		"hora": hora,
		"minutos": minutos,
		"segundos": segundos
	}

func seconds_to_hms(total_seconds: int) -> Dictionary:
	# Asegurarse de que los segundos sean positivos
	total_seconds = max(total_seconds, 0)

	# Calcular horas, minutos y segundos
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60

	# Retornar un diccionario con los valores
	return {
		"hours": hours,
		"minutes": minutes,
		"seconds": seconds
	}

#endregion

#---------------------------------------------------------------------------------------------------
#endregion
