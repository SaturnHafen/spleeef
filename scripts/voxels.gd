extends Node

var terrain: VoxelLodTerrain
var voxel_tool: VoxelToolLodTerrain

func do_graph(graph: VoxelGeneratorGraph, global_pos: Vector3, size: Vector3, pitch = 0.0, yaw = 0.0):
	var to_local = terrain.global_transform.affine_inverse()
	var pos = to_local * global_pos
	var transform = Transform3D.IDENTITY \
		.scaled(size / terrain.global_transform.basis.get_scale()) \
		.rotated(Vector3(0, 0, 1), pitch) \
		.rotated(Vector3(0, 1, 0), yaw) \
		.translated(pos)
	voxel_tool.do_graph(graph, transform, Vector3(1, 1, 1))
