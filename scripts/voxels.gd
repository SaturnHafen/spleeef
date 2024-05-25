extends Node

var terrain: VoxelLodTerrain
var voxel_tool: VoxelToolLodTerrain

func do_graph(graph: VoxelGeneratorGraph, global_pos: Vector3, size: Vector3, pitch = 0.0, yaw = 0.0):
	var to_local = terrain.global_transform.affine_inverse()
	var pos = to_local * global_pos
	var transform = Transform3D.IDENTITY \
		.rotated(Vector3(0, 0, 1), pitch) \
		.rotated(Vector3(0, 1, 0), yaw) \
		.translated(pos)
	voxel_tool.do_graph(graph, transform, size)
