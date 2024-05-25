extends VoxelLodTerrain

func _ready():
	Voxels.terrain = self
	Voxels.voxel_tool = get_voxel_tool()
