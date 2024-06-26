extends Node
var pressedW = false
var pressedA = false
var pressedS = false
var pressedD = false
var all_pressed = false

signal reverse_text
signal orb_spawned


@onready var text_pop = $"../TextPop"
@onready var spawn_in = $"../spawn_weapon"
@onready var spawn_in_orb = $"../Random/orb"
@onready var player = $"../Player"
@onready var camera = $"../Player/Head"
#@onready var cameraAnimation = $"../Player/Head/AnimationPlayer"
@onready var timer = $"../Random/Timer"
@onready var animationNode = $"../Floating_animation"
var weapons = preload("res://prefabs/game objects/interactable/weapon/weapon.tscn")
@onready var label3 = $"../Label"
var crate = preload("res://prefabs/game objects/interactable/ammo_create.tscn")
@onready var door = $"../Doors"

#Markers
@onready var point4 = $"../point4"
@onready var point3 = $"../point3"

#SFX
@onready var AHSH = $"../spawn_weapon/Ah_shit"
@onready var lightON = $"../SpotLight3D/light_on"
@onready var lightOFF = $"../SpotLight3D/light_on"
@onready var Pop = $"../TextPop/Pop"

#opacity
@onready var colorRect = $"../Random/ColorRect"

#Good node
@onready var animation_Player_Node = $"../AnimationPlayerNode"
@onready var collisionArea = $"../Area3D"
@onready var collisionArea1 = $"../Area3D2"
@onready var HUD = $"../UI"
@onready var spotLight = $"../SpotLight3D"

func spawn_weapon():
	var weapon = weapons.instantiate()
	spawn_in.add_child(weapon)
	player._on_level_template_set_ammo(100)
	
	

func spawn_orb():
	var instance = crate.instantiate()
	instance.ammoValue = 10
	spawn_in_orb.position = Vector3(0,0,-16)
	
	spawn_in_orb.add_child(instance)

	
	

func _on_player_colided_with_collision_area(collision_area: Area3D):
	var player_detected = false
	if collision_area.get_overlapping_bodies().size() > 0:
		for body in collision_area.get_overlapping_bodies():
			if  body.is_in_group("movable"):
				player_detected = true
				break
	return player_detected
	
	
func change_collision_area_pos(x,y,z, collision_area: Object):
	collision_area.position = Vector3(x,y,z)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	text_pop.visible = false
	player.enabled_mouse_input = false
	HUD.visible = false
	set_player_pos_onready(0,100,20)
	#cameraAnimation.play("new_animation")
	#cameraAnimation.seek(0)
	#cameraAnimation.pause()
	
	
	animation_Player_Node.play("opacity")
	
	label3.visible = false
	animationNode.play("Text_type")
	label3.text = "Press W to move forwards"
	
	timer.start()
	await timer.timeout
	#cameraAnimation.play()
	HUD.visible = true
	player.enabled_mouse_input = true
	animationNode.play("Text_type")
	label3.visible = true

func enter_pointer_text(text: String):
	text_pop.text = text


func text_pop_change_position(x,y,z):
	text_pop.position = Vector3(x,y,z)

	
func set_player_pos_onready(x,y,z):
	player.position = Vector3(x,y,z)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var executed = false
	
	var playerDetected = _on_player_colided_with_collision_area(collisionArea)
	if playerDetected and not executed:
		animation_Player_Node.play("close")
		change_collision_area_pos(-100,100,0,collisionArea)
		pass

	executed = true
	
	if Input.is_action_just_pressed("move_backward") and !pressedS:
		pressedS = true
		label3.text = "Press D to move right"
		
	if Input.is_action_just_pressed("move_forward") and !pressedW:
		pressedW = true
		label3.text = "Press S to move backwards"
		
	if Input.is_action_just_pressed("move_right") and !pressedD:
		pressedD = true
		label3.text = "Press A to move left"
		
	if Input.is_action_just_pressed("move_left") and !pressedA:
		pressedA = true
		label3.text =""
	
		
	if pressedS&&pressedW&&pressedD&&pressedA&&!all_pressed:
		all_pressed = true
		label3.text=""
		
		#Weapon spawns
		player.enabled_mouse_input = false
		timer.wait_time = 2
		timer.start()
		#cameraAnimation.play("shake")
		await timer.timeout
		#cameraAnimation.stop()
		lightON.play()
		spotLight.visible = true
		text_pop.visible = true
		spawn_weapon()
		camera.look_at_from_position(camera.global_transform.origin,spawn_in.global_position)
		#cameraAnimation.play("zoom")
		timer.wait_time = 0.2
		timer.start()
		await timer.timeout
		AHSH.play()
		await AHSH.finished
		timer.wait_time = 1
		timer.start()
		await timer.timeout
		player.enabled_mouse_input = true
		Pop.play()
		enter_pointer_text("Pick me up!")
		#animation_Player_Node.play("Rattlesanek")
		text_pop_change_position(spawn_in.position.x, 1.2,spawn_in.position.z)
		timer.wait_time = 0.5
		timer.start()
		await timer.timeout
		HUD.update_objective("pick up the 'thing'?", false)
		
		await player.equip_gun
		#HUD.changse_objective_color(true)
		enter_pointer_text("")
		timer.wait_time = 1
		timer.start()
		await timer.timeout
		lightON.play()
		
		spotLight.visible = false
		HUD.update_objective("pick up the 'thing'?", true)

		timer.wait_time = 1.5
		timer.start()
		await timer.timeout
		
		#Orb spawns
		spotLight.visible = true
		lightON.play()
		spotLight.position = Vector3(spawn_in_orb.position.x, spotLight.position.y, spawn_in_orb.position.z)
		spawn_orb()
		enter_pointer_text("Pick this up!")
		text_pop_change_position(spawn_in_orb.position.x, 1.2, spawn_in_orb.position.z)
		timer.wait_time = 0.5
		timer.start()
		await timer.timeout
		HUD.update_objective("Do what it says...", false)
		
		await player.UI_update_ammo
		enter_pointer_text("")
		timer.wait_time = 1
		timer.start()
		await timer.timeout
		spotLight.visible = false
		lightON.play()
		HUD.update_objective("Do what it says...", true)
		
		timer.wait_time = 2
		timer.start()
		await timer.timeout
		HUD.update_objective("Shoot the 'thing' at the to jump...", false)
		
		
		text_pop_change_position(point3.position.x,point3.position.y+2,point3.position.z)
		enter_pointer_text("Get up here!")
		spotLight.position = Vector3(text_pop.position.x, 6,-20.5)
		spotLight.visible = true
		lightON.play()
		
		#var playerDetected1 = _on_player_colided_with_collision_area(collisionArea1)
		#if playerDetected1:
			#HUD.update_objective(str(playerDetected1))
	
		#TEMPORARY COLLISION NOT WORKING
		timer.wait_time = 1.5
		timer.start()
		await timer.timeout
		timer.wait_time = 1
		timer.start()
		await timer.timeout
		spotLight.visible = false
		enter_pointer_text("")
		lightON.play()
		HUD.update_objective("Do what it says...", true)
		
		timer.wait_time = 2
		await timer.timeout
		lightON.play()
		enter_pointer_text("Get over here!")
		HUD.update_objective("While holding W press SHIFT to sprint.\nOtherwise you're not getting up there...", false)
		text_pop_change_position(point4.position.x,point4.position.y+2,point4.position.z)
		spotLight.position = Vector3(point4.position.x,point4.position.y+5,point4.position.z+3)
		spotLight.visible = true
