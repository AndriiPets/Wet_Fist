extends Node
class_name StateMachine
## Generic push_down automata

@export var initial_state: NodePath

@export var actor: Actor
@export var animation_player: AnimationPlayer

var current: State: get = get_current
var states: Dictionary = {}

var _state_stack: Array[State] = []

func _ready() -> void:
	if initial_state == null:
		push_error("StateMachine: initial state is null")
		return
	for st in get_children():
		if st is State:
			states[st.name.to_lower()] = st
			st.fsm = self
			st.body = actor
			st.anim = animation_player
			st._init_state()
	
	if get_node_or_null(initial_state) != null:
		var start_state = get_node(initial_state) as State
		_state_stack.append(start_state)
		start_state._enter_state()
	else:
		push_error("Initial state not in StateMachine")

#API
func change_state(new_state_name: String) -> void:
	if not states.has(new_state_name.to_lower()):
		push_error("State not found: " + new_state_name)
		
	#print("StateMachine: ", "changed to ", new_state_name)
	
	if _state_stack.size():
		_state_stack.back()._exit_state()

	var new_state = states[new_state_name.to_lower()]
	_state_stack = [new_state]
	_state_stack.back()._enter_state()

func push_state(new_state_name: String) -> void:
	if not states.has(new_state_name.to_lower()):
		push_error("State not found: " + new_state_name)

	if _state_stack.size():
		_state_stack.back()._exit_state()
	
	var new_state = states[new_state_name.to_lower()]
	_state_stack.append(new_state)
	_state_stack.back()._enter_state()

func pop_state() -> void:
	if _state_stack.size() > 1:
		_state_stack.back()._exit_state()
		_state_stack.pop_back()
		if _state_stack.size():
			_state_stack.back()._enter_state()

#Engine hooks
func _unhandled_input(event: InputEvent) -> void:
	if not _state_stack.is_empty():
		_state_stack.back()._handle_input(event)

func _process(delta: float) -> void:
	if not _state_stack.is_empty():
		_state_stack.back()._update(delta)

func _physics_process(delta: float) -> void:
	if not _state_stack.is_empty():
		_state_stack.back()._physics_update(delta)

func get_current() -> State:
	return _state_stack.back() if _state_stack.size() else null
