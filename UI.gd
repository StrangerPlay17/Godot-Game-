extends CanvasLayer

var coins = 0 # Referencia a las monedas en la interfaz <-
# Referencia a los corazones en la interfaz <-
# Hearts Player1
var heart1
var heart2
var heart3
# Hearts Player2
var heart4
var heart5
var heart6

# Called when the node enters the scene tree for the first time.
func _ready():
	# Player1 Hearts
	heart1 = get_node("HeartP11")
	heart2 = get_node("HeartP12")
	heart3 = get_node("HeartP13")
	# Playr2 Hearts
	heart4 = get_node("HeartP21")
	heart5 = get_node("HeartP22")
	heart6 = get_node("HeartP23")
	
	#var coinNode = get_tree().get_root().find_node("Coin2D", true, false)
	for coin in get_tree().get_nodes_in_group("coins"):  # Itera sobre todos los nodos "Coins" en el grupo "coins"
		#print("Nodo Coin2D encontrado: ", child)
		coin.connect("coinCollected", handleCoinCollected, 0)
	for chest in get_tree().get_nodes_in_group("chests"):  # Itera sobre todos los nodos en el grupo "chest"
		#print("Nodo Coin2D encontrado: ", child)
		chest.connect("chestCollected", handleChestCollected, 0)
	
	$CoinsCollectedText.text = str(coins) # Valor por defecto en coins impreso

func handleCoinCollected(): # Funcion para suma de monedas
	print("Coin Collected")
	coins += 1
	$CoinsCollectedText.text = str(coins)
	# Al recoger 3 monedas el nivel termina
	if coins == 3:
		get_tree().change_scene_to_file("res://scenes/victory.tscn")

func handleChestCollected(): # Funcion para recoleccion de chest
	print("Chest Collected")
	coins += 3
	$CoinsCollectedText.text = str(coins)
	# Al recoger 10 monedas el nivel termina
	if coins == 10:
		get_tree().change_scene_to_file("res://scenes/victory.tscn")

func handleHeartsPlayer1(lifes): # Muestra las vidas que le quedan al player1 <-
	if lifes == 2:
		heart3.visible = false
	elif lifes == 1:
		heart2.visible = false
		heart3.visible = false
	elif lifes == 0:
		heart1.visible = false
		heart2.visible = false
		heart3.visible = false

func handleHeartsPlayer2(lifes): # Muestra las vidas que le quedan al player2 <-
	if lifes == 2:
		heart6.visible = false
	elif lifes == 1:
		heart5.visible = false
		heart6.visible = false
	elif lifes == 0:
		heart4.visible = false
		heart5.visible = false
		heart6.visible = false
