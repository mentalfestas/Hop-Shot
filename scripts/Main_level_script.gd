extends Node3D

var collider_obj = preload( "res://prefabs/collider.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_player_shot_fired(pos):
	var collider = collider_obj.instantiate()
	add_child(collider)
	collider.position = pos

func _on_death_zone_body_entered(body):
	print("You died")
	body.position = Vector3.ZERO + Vector3(0,5,0)
