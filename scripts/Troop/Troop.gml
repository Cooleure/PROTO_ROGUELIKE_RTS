function Troop()
{
	/// INIT
	// Selection
	selected = false;
	
	// Creation troop
	sizeX = 3;
	sizeY = 3;
	spacing = 2;
	
	soldiersGrid = ds_grid_create(sizeX, sizeY);
	soldiersList = ds_list_create();
	
	angle = 45; // 45 degrés
	
	centerX = floor(sizeX / 2);
	centerY = floor(sizeY / 2);
	
	leader = undefined;
	
	function generateTroop(_leader, _leaderLayer, _follower, _followerLayer)
	{
		var _no = 0;
	
		var _order = array_reverse(getDiagOrder(sizeX, sizeY));
	
		for (var k = 0; k < array_length(_order); k++)
		{
		    var _pos = _order[k];
		    var i = _pos[0];
		    var j = _pos[1];
		
			// Case center : it is the leader
			var _soldier = undefined;
		
			if (i == centerX and j == centerY)
			{
				_soldier = instance_create_layer(0, 0, _leaderLayer, _leader);
			}
			else
			{
				_soldier = instance_create_layer(0, 0, _followerLayer, _follower);
			}
		
			_soldier.troop = id;
			_soldier.no = _no;
			_no++;
			
			var gridX = i - floor(sizeX / 2);
			var gridY = j - floor(sizeY / 2);
			
			var rotated = rotate(gridX, gridY, angle);
			
			_soldier.x = x + rotated[0] * (spacing + _soldier.sprite_width / 2);
			_soldier.y = y + rotated[1] * (spacing + _soldier.sprite_height / 2);

			ds_grid_set(soldiersGrid, i, j, _soldier);
			ds_list_add(soldiersList, _soldier);
		}
	
		// Soldier leader
		leader = ds_grid_get(soldiersGrid, centerX, centerY);
		
		// BoundingBox
		image_xscale = (sizeX * (_follower.sprite_width / 2 + spacing) - spacing) / 2;
		image_yscale = (sizeY * (_follower.sprite_height / 2 + spacing) - spacing) / 2;
		image_angle = -angle;
	}

	/// EVENTS
	function step()
	{
		
	}
	
	function endStep()
	{
		if (not is_undefined(leader))
		{
			x = leader.x;
			y = leader.y;
		}
	}
}
