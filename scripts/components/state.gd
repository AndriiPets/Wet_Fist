extends Node
class_name State

var fsm: StateMachine
var body: Actor
var anim: AnimationPlayer

#Mandatory
func _init_state() -> void: pass
func _enter_state() -> void: pass
func _exit_state() -> void: pass

func _handle_input(_event: InputEvent) -> void: pass
func _update(_delta: float) -> void: pass
func _physics_update(_delta: float) -> void: pass
