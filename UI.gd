extends CanvasLayer

var coins = 0 # Referencia a las monedas en la interfaz <-
# Referencia a los corazones en la interfaz <-
var heart1
var heart2
var heart3

# Called when the node enters the scene tree for the first time.
func _ready():
	heart1 = get_node("Heart1")
	heart2 = get_node("Heart2")
	heart3 = get_node("Heart3")
	
	#var coinNode = get_tree().get_root().find_node("Coin2D", true, false)
	for child in get_tree().get_nodes_in_group("coins"):  # Itera sobre todos los nodos "Coins" en el grupo "coins"
		#print("Nodo Coin2D encontrado: ", child)
		child.connect("coinCollected", handleCoinCollected, 0)
	
	$CoinsCollectedText.text = str(coins)

func handleCoinCollected(): # Funcion para suma de monedas
	print("Coin Collected")
	coins += 1
	$CoinsCollectedText.text = str(coins)
	# Al recoger 3 monedas el nivel termina
	if coins == 3:
		get_tree().change_scene_to_file("res://scenes/victory.tscn")

func handleHearts(lifes): # Muestra las vidas que le quedan al player <-
	if lifes == 2:
		heart3.visible = false
	elif lifes == 1:
		heart2.visible = false
		heart3.visible = false
		
