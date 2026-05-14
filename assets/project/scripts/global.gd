extends Node

# Ruta de guardado en la carpeta de usuario del sistema (persiste tras cerrar)
const SAVE_PATH = "user://save_data.dat"

# --- DATOS DE LA PARTIDA ---
var monedas: int = 1000
var personajes_comprados: Array = ["perso1"]
var seleccionado: String = "perso1"
var nivel_maximo: int = 1

# Precios fijos (no necesitan guardarse porque no cambian)
var precios = {
	"perso1": 0,
	"perso2": 100,
	"perso3": 300,
	"perso4": 200,
	"perso5": 400
}

func _ready():
	# Intentamos cargar los datos en cuanto el juego inicia
	load_game()

# --- SISTEMA DE PERSISTENCIA ---

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		# Empaquetamos todos los datos en un diccionario
		var data = {
			"monedas": monedas,
			"personajes_comprados": personajes_comprados,
			"seleccionado": seleccionado,
			"nivel_maximo": nivel_maximo
		}
		# Guardamos el diccionario completo
		file.store_var(data)
		file.close()
		print("Juego guardado exitosamente.")

func load_game():
	# Si el archivo no existe (primera vez que se juega), no hacemos nada
	if not FileAccess.file_exists(SAVE_PATH):
		print("No hay datos guardados previos.")
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var data = file.get_var()
		# Usamos .get() por seguridad: si una llave no existe, usa el valor por defecto
		monedas = data.get("monedas", 1000)
		personajes_comprados = data.get("personajes_comprados", ["perso1"])
		seleccionado = data.get("seleccionado", "perso1")
		nivel_maximo = data.get("nivel_maximo", 1)
		file.close()
		print("Datos cargados correctamente.")

# --- UTILIDADES ---

# Función para añadir monedas y guardar automáticamente
func añadir_monedas(cantidad: int):
	monedas += cantidad
	save_game()
