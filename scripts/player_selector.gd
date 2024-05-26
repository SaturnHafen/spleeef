extends Marker3D

signal player_joined(player)
signal player_ready(player)

@export_enum(
	"Player 1",
	"Player 2",
	"Player 3",
	"Player 4",
	"Player 5",
	"Player 6",
	"Player 7",
	"Player 8",
) var player: int = 0

enum State {
	PLAYER_DISABLED,
	PLAYER_JOINED,
	PLAYER_CHAR_SELECTED,
	PLAYER_TEAM_SELECTED
}

var state = State.PLAYER_DISABLED

var selected_player = 0
var selected_team = 0

var can_change_selection = true

func disable_change_selection():
	can_change_selection = false
	$SwitchDelay.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not can_change_selection:
		return
	if state == State.PLAYER_DISABLED:
		if Input.is_action_just_pressed("player_%d_switch" % player):
			state = State.PLAYER_JOINED
			$Spot.visible = true
			disable_change_selection()
			player_joined.emit(self)
			return
		
	elif state == State.PLAYER_JOINED:
		if Input.is_action_just_pressed("player_%d_switch" % player):
			state = State.PLAYER_CHAR_SELECTED
			$Spot.light_color = GameOverData.team_colors[0]
			disable_change_selection()
			return
		
		var selection = Input.get_axis(
			"player_%d_left" % player, 
			"player_%d_right" % player)
		
		if selection == 0:
			return
		
		var old_player = selected_player
		selected_player += int(selection)
		
		if selected_player < 0:
			selected_player = $Character.get_child_count() - 1
		if selected_player >= $Character.get_child_count():
			selected_player = 0
		
		if selected_player != old_player:
			disable_change_selection()
		
		var new_char = $Character.get_child(selected_player)
		var old_char = $Character.get_child(old_player)
		
		new_char.visible = true
		old_char.visible = false
	
	elif state == State.PLAYER_CHAR_SELECTED:
		if Input.is_action_just_pressed("player_%d_switch" % player):
			state = State.PLAYER_TEAM_SELECTED
			disable_change_selection()
			$Ready.visible = true
			$Spot.light_energy = 1.5
			player_ready.emit(self)
			return
		
		var selection = Input.get_axis(
			"player_%d_left" % player, 
			"player_%d_right" % player)
		
		if selection == 0:
			return
		
		selected_team += int(selection)
		
		if selected_team < 0:
			selected_team = len(GameOverData.team_colors) - 1
		if selected_team >= len(GameOverData.team_colors):
			selected_team = 0
		
		disable_change_selection()
		$Spot.light_color = GameOverData.team_colors[selected_team]
		
	elif state == State.PLAYER_TEAM_SELECTED:
		pass


func _on_switchdelay_timeout():
	can_change_selection = true
