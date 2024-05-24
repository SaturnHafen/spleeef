extends Node3D

var graph = preload("res://test_generator.tres");

@onready
var tool = $VoxelLodTerrain.get_voxel_tool()

func _process(delta):
	tool.mode = VoxelTool.MODE_REMOVE
	tool.do_graph(graph, Transform3D.IDENTITY, Vector3(80, 80, 80))
