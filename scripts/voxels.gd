extends Node

var terrain: VoxelLodTerrain
var voxel_tool: VoxelToolLodTerrain

func do_graph(graph: VoxelGeneratorGraph, global_pos: Vector3, size: Vector3):
	var to_local = terrain.global_transform.affine_inverse()
	var pos = to_local * global_pos
	var transform = Transform3D.IDENTITY.translated(pos)
	voxel_tool.do_graph(graph, transform, size)
