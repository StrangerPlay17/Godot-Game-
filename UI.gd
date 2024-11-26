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

var total_coins = 8
var total_silver_coins = 8
var total_chests = 4

var collected_coins = 0
var collected_silver_coins = 0
var collected_chests = 0

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
		
	for silver in get_tree().get_nodes_in_group("silvers"):  # Itera sobre todos los nodos "Coins" en el grupo "coins"
		#print("Nodo Coin2D encontrado: ", child)
		silver.connect("silverCollected", handleSilverCollected, 0)	
		
	for chest in get_tree().get_nodes_in_group("chests"):  # Itera sobre todos los nodos en el grupo "chest"
		#print("Nodo Coin2D encontrado: ", child)
		chest.connect("chestCollected", handleChestCollected, 0)
	
	$CoinsCollectedText.text = str(coins) # Valor por defecto en coins impreso

func handleCoinCollected(): 
	print("Coin Collected")
	collected_coins += 1
	coins += 2
	$CoinsCollectedText.text = str(coins)
	checkVictoryCondition()

func handleSilverCollected(): 
	print("Silver Collected")
	collected_silver_coins += 1
	coins += 1
	$CoinsCollectedText.text = str(coins)
	checkVictoryCondition()

func handleChestCollected(): 
	print("Chest Collected")
	collected_chests += 1
	coins += 3
	$CoinsCollectedText.text = str(coins)
	checkVictoryCondition()

func checkVictoryCondition():
	# Verifica si estás en el tutorial
	var canvas_layer = get_tree().root.find_child("GameTutorial", true, false)
	
	if canvas_layer != null:
		# Lógica para el tutorial (cambiar de escena con 4 monedas)
		if coins == 4:
			get_tree().change_scene_to_file("res://game.tscn")
	else:
		# Lógica para el juego principal
		if collected_coins == total_coins and collected_silver_coins == total_silver_coins and collected_chests == total_chests:
			get_tree().change_scene_to_file("res://scenes/victory.tscn")
		

"""
func handleSilverCollected(): # Funcion para suma de monedas
	print("silver Collected")
	coins += 1
	$CoinsCollectedText.text = str(coins)
	if coins == 4:
		# Si las monedas recogidas fueron 3 y ademas, se esta en el tutorial
		var canvas_layer = get_tree().root.get_node("GameTutorial/CanvasLayer")
		if canvas_layer != null:
			get_tree().change_scene_to_file("res://game.tscn")
		else: # Sino, se esta en el nivel del juego 
			get_tree().change_scene_to_file("res://scenes/victory.tscn")

func handleCoinCollected(): # Funcion para suma de monedas
	print("Coin Collected")
	coins += 2
	$CoinsCollectedText.text = str(coins)
	# Al recoger 3 monedas el nivel termina
	if coins == 4:
		# Si las monedas recogidas fueron 3 y ademas, se esta en el tutorial
		var canvas_layer = get_tree().root.get_node("GameTutorial/CanvasLayer")
		if canvas_layer != null:
			get_tree().change_scene_to_file("res://game.tscn")
		else: # Sino, se esta en el nivel del juego 
			get_tree().change_scene_to_file("res://scenes/victory.tscn")
		

func handleChestCollected(): # Funcion para recoleccion de chest
	print("Chest Collected")
	coins += 3
	$CoinsCollectedText.text = str(coins)
	# Al recoger 10 monedas el nivel termina
	if coins == 10:
		get_tree().change_scene_to_file("res://scenes/victory.tscn")
"""

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

func restoreHearts(player_group):
	if player_group == "player1":
		# Restaura los corazones del Jugador 1
		heart1.visible = true
		heart2.visible = true
		heart3.visible = true
	elif player_group == "player2":
		# Restaura los corazones del Jugador 2
		heart4.visible = true
		heart5.visible = true
		heart6.visible = true
