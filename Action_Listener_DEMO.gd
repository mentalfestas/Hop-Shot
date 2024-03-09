extends Node
var pressedW = false
var pressedA = false
var pressedS = false
var pressedD = false
var all_pressed = false
@onready var text_pop = $"../TextPop"
@onready var spawn_in = $"../spawn_weapon"
var weapons = preload("res://WEAPONS/weapon.tscn")

func spawn_weapon():
	var weapon = weapons.instantiate()
	weapon.position = spawn_in.position
	spawn_in.add_child(weapon)

# Called when the node enters the scene tree for the first time.
func _ready():
	text_pop.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("MOVE_BACKWARD"):
		pressedS = true
		print("S")
	if Input.is_action_just_pressed("MOVE_FORWARD"):
		pressedW = true
		print("W")
	if Input.is_action_just_pressed("MOVE_RIGHT"):
		pressedD = true
		print("D")
	if Input.is_action_just_pressed("MOVE_LEFT"):
		pressedA = true
		print("A")
		
	if pressedS&&pressedW&&pressedD&&pressedA&&!all_pressed:
		all_pressed = true
		spawn_weapon()
		
		
		
		
