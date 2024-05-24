extends VoxelLodTerrain

var graph = preload("res://resources/sdfs/noisy_sphere.tres");

@onready
var tool = get_voxel_tool()

func _on_timer_timeout():
	tool.mode = VoxelTool.MODE_REMOVE
	tool.do_graph(graph, Transform3D.IDENTITY, Vector3(100, 100, 100))
