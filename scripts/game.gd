class_name Game extends Control

enum State {
	PLAYER_SELECTION,
	READY,
	PLAYING,
	GAME_OVER,
}

var state: State
var players: Array[Player] = []
var arena: Node3D = null
var empty_player_view: PlayerView

var max_num_players = 8
@onready var status = $UI/StatusPanel/Status

var team_won: Team = null
var teams: Array[Team] = [
	Team.new("red", Color.RED),
	Team.new("blue", Color.BLUE),
	Team.new("green", Color.GREEN),
	Team.new("orange", Color.ORANGE),
	Team.new("purple", Color.PURPLE),
	Team.new("aqua", Color.AQUA),
	Team.new("yellow", Color.YELLOW),
	Team.new("pink", Color.DEEP_PINK),
]

func _ready():
	switch_to_player_selection()

func clear_players():
	for child in $UI/PlayerGrid.get_children():
		child.queue_free()
	players = []

func switch_to_player_selection():
	state = State.PLAYER_SELECTION
	clear_players()
	add_empty_player_view()
	$UI/PlayerGrid.visible = true
	$UI/GameOver.visible = false

func switch_to_game_over():
	state = State.GAME_OVER
	if arena:
		arena.queue_free()
		arena = null
	clear_players()
	$UI/PlayerGrid.visible = false
	status.text = "Press right trigger to play again"
	$UI/GameOver.visible = true
	var game_over = $UI/GameOver/Label
	game_over.clear()
	game_over.bbcode_enabled = true
	game_over.text = "[center]"
	if not team_won:
		game_over.add_text("Game over\nNobody won")
		return
	game_over.add_text("Game over\nTeam ")
	game_over.push_color(team_won.color)
	game_over.add_text(team_won.name)
	game_over.pop()
	game_over.add_text(" won!")

const player_view_scene = preload("res://scenes/player_view.tscn")

func add_empty_player_view():
	empty_player_view = player_view_scene.instantiate()
	$UI/PlayerGrid.add_child(empty_player_view)
	empty_player_view.set_info("Press right trigger to join")

func _process(delta):
	match state:
		State.PLAYER_SELECTION:
			process_player_selection()
		State.READY:
			process_ready()
		State.PLAYING:
			process_playing()
		State.GAME_OVER:
			process_game_over()

func player_exists(id: int):
	for player in players:
			if player.id == id:
				return true
	return false

func find_new_players() -> Array[int]:
	var ids: Array[int] = []
	for id in range(max_num_players):
		if player_exists(id):
			continue
		if Input.is_action_just_pressed("player_%d_action" % id):
			ids.push_back(id)
	return ids

func process_player_selection():
	for id in find_new_players():
		player_joined(id)
	if len(players) > 0 and all_ready():
		status.text = "At least two teams are needed!"
	else:
		status.text = "Player selection"

func process_ready():
	status.text = "All players ready! Starting game in %.1f seconds" % ready_timer.time_left

func process_playing():
	status.clear()
	var first = true
	for team in get_teams_alive():
		if first:
			first = false
		else:
			status.add_text("\t")
		status.push_color(team.color)
		status.add_text("%s: %d" % [team.name, team.num_players])
		status.pop()

func process_game_over():
	if len(find_new_players()) >= 1:
		switch_to_player_selection()

func player_left(player: Player):
	players.erase(player)
	player.player_view.queue_free()

func player_joined(id: int):
	var player = preload("res://scenes/player.tscn").instantiate()
	player.id = id
	player.game = self
	player.player_view = empty_player_view
	players.push_back(player)
	player.death.connect(self.player_died)
	player.player_ready.connect(self.player_ready)
	player.player_not_ready.connect(self.player_not_ready)
	empty_player_view.add_player(player)
	add_empty_player_view()

func get_teams_alive() -> Array[Team]:
	var alive: Array[Team] = []
	for team in teams:
		if team.is_alive():
			alive.push_back(team)
	return alive

func player_died(player: Player):
	player.team.num_players -= 1
	var teams_alive = get_teams_alive()
	if len(teams_alive) > 1:
		return
	if len(teams_alive) == 1:
		team_won = teams_alive[0]
	else:
		team_won = null
	switch_to_game_over()

var ready_timer: Timer = null

func switch_to_ready():
	state = State.READY
	ready_timer = Timer.new()
	ready_timer.timeout.connect(self.switch_to_playing)
	add_child(ready_timer)
	ready_timer.start(5)

func clear_ready_timer():
	if not ready_timer:
		return
	ready_timer.stop()
	ready_timer.queue_free()

func assign_team_num_players():
	for team in teams:
		team.num_players = 0
	for player in players:
		player.team.num_players += 1

func switch_to_playing():
	state = State.PLAYING
	clear_ready_timer()
	arena = preload("res://scenes/arena.tscn").instantiate()
	add_child(arena)
	move_child(arena, 0)
	empty_player_view.queue_free()
	assign_team_num_players()
	for player in players:
		player.get_parent().remove_child(player)
		player.player_view.remove_player()
		player.switch_to_playing()
	arena.spawn(players)

func all_ready():
	for player in players:
		if not player.is_ready():
			return false
	return true

func player_ready(player: Player):
	clear_ready_timer()
	if all_ready():
		assign_team_num_players()
		if len(get_teams_alive()) > 1:
			switch_to_ready()

func player_not_ready(player: Player):
	if state != State.READY:
		return
	clear_ready_timer()
	state = State.PLAYER_SELECTION
