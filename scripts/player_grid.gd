extends GridContainer

@export var columns_for_child_count: Array[int] = []

func _ready():
	_on_children_changed()

func _on_children_changed():
	if len(columns_for_child_count) == 0:
		columns = 1
		return
	var count = min(get_child_count(), len(columns_for_child_count))
	columns = max(columns_for_child_count[count], 1)
