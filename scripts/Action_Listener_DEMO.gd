extends Node
var pressedW = false
var pressedA = false
var pressedS = false
var pressedD = false
var all_pressed = false



@onready var text_pop = $"../TextPop"
@onready var spawn_in = $"../spawn_weapon"
@onready var player = $"../Player"
@onready var camera = $"../Player/Head/Camera"
@onready var cameraAnimation = $"../Player/Head/AnimationPlayer"
@onready var timer = $"../Random/Timer"
@onready var animationNode = $"../Floating_animation"
@onready var animationNode2 = $"../Floating_animation/AnimationPlayer"
var weapons = preload("res://prefabs/game objects/interactable/weapon/weapon.tscn")
var offset = Vector3(0,0.8,-5)
@onready var label3 = $"../UI/RichTextLabel"
var original_text
@onready var crate = $"../Random/AmmoCreate"
@onready var cylinder = $"../Tube"

var temp = 0




var ammoCratePosition = Vector3(0,0,20)


func spawn_weapon():
	var weapon = weapons.instantiate()
	weapon.position = offset


	print(spawn_in.position)

	spawn_in.add_child(weapon)
	
func _on_weapon_picked_up():
	text_pop.visible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	text_pop.visible = false
	label3.visible = false
	crate.position = ammoCratePosition
	label3.bbcode_enabled = true
	label3.text = "Use to move:\nW - forwards\nA - left\nD - right\nS - backwards"
	
	original_text = label3.text
	set_player_pos_onready()
	set_camera_on_ready()
	
	timer.start()
	await timer.timeout
	animationNode.play("Text_type")
	label3.visible = true
	cameraAnimation.play("new_animation")

func _on_player_change_ammo(value):
	label3.text = "Ammo Value: " + str(value)

func set_camera_on_ready():
	pass

func set_player_pos_onready():
	player.position = Vector3(0,30,0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	
	if Input.is_action_just_pressed("move_backward"):
		pressedS = true
		var modify = original_text.replace("S - backwards", "[color=red]S - backwards[/color]")
		label3.bbcode_text = modify
		print("S")
		
		
	if Input.is_action_just_pressed("move_forward"):
		pressedW = true
		print(player.position)
		var modify = original_text.replace("W - forwards", "[color=red]W - forwards[/color]")
		label3.bbcode_text = modify
		print("W")
	if Input.is_action_just_pressed("move_right"):
		pressedD = true
		var modify = original_text.replace("D - right", "[color=red]D - right[/color]")
		label3.bbcode_text = modify
		print("D")
	if Input.is_action_just_pressed("move_left"):
		pressedA = true
		var modify = original_text.replace("A - left", "[color=red]A - left[/color]")
		label3.bbcode_text = modify
		print("A")
		
		
		
	if pressedS&&pressedW&&pressedD&&pressedA&&!all_pressed:
		all_pressed = true
		text_pop.visible = true
		spawn_weapon()
		animationNode2.play("float_weapon")
		animationNode.play("float")

		


