extends KinematicBody2D

export var target : String

func _physics_process(delta):
	set_position(get_node("/root/Main/Ghosts/"+target).getTargetTile() * 20)
