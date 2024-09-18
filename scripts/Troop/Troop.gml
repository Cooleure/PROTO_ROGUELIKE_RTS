function Troop()
{
	/// INIT
	stateMachineExample = new StateMachine(SM_MODEL_STATE.FIRST_STATE,
										StateObjectStateFirstState,
										StateObjectStateSecondState,
										StateObjectStateThirdState);
	
	// Selection
	selected = false;
	
	// Creation troop
	sizeX = 3;
	sizeY = 3;
	spacing = 50;
	
	soldiersGrid = ds_grid_create(sizeX, sizeY);
	soldiersList = ds_list_create();
	
	angle = 45; // 45 degrés

	var _no = 0;
	
	for (var i = 0; i < sizeX; i++)
	{
	    for (var j = 0; j < sizeY; j++)
		{
			var _soldier = instance_create_layer(0, 0, "Soldiers", oSoldier);
			
			_soldier.no = _no;
			_no++;
			
			var gridX = i - floor(sizeX / 2);
			var gridY = j - floor(sizeY / 2);
			
			var rotated = rotate(gridX, gridY, angle);
			
			_soldier.x = x + rotated[0] * (spacing + _soldier.sprite_width);
			_soldier.y = y + rotated[1] * (spacing + _soldier.sprite_height);

			ds_grid_set(soldiersGrid, i, j, _soldier);
			ds_list_add(soldiersList, _soldier);
		}
	}
	
	// Soldier leader
	centerX = floor(sizeX / 2);
	centerY = floor(sizeY / 2);
	centerSoldier = ds_grid_get(soldiersGrid, centerX, centerY);

	// BoundingBox
	show_debug_message(sprite_get_xoffset(sprite_index))
	image_xscale = (sizeX * (oSoldier.sprite_width + spacing) - spacing) / 2;
	image_yscale = (sizeY * (oSoldier.sprite_height + spacing) - spacing) / 2;
	image_angle = -angle;

	/// EVENTS
	function step()
	{
		script_execute(stateMachineExample.update());
	}
	
	function endStep()
	{
		x = centerSoldier.x;
		y = centerSoldier.y;
	}
	
	function leftPressed()
	{
		selected = not selected;
	}
	
	function globalRightPressed()
	{
		if (selected)
		{
			for (var i = 0; i < sizeX; i++)
			{
			    for (var j = 0; j < sizeY; j++)
				{
					var _soldier = ds_grid_get(soldiersGrid, i, j);
				
					var _posX = i - centerX;
					var _posY = j - centerY;

					var rotated = rotate(_posX, _posY, angle);

					var _destX = mouse_x + rotated[0] * (spacing + _soldier.sprite_width);
					var _destY = mouse_y + rotated[1] * (spacing + _soldier.sprite_height);
			
					_soldier.moveToPoint(_destX, _destY);
				}
			}
		}
	}

	function draw()
	{
		if (selected)
		{
			draw_set_color(c_green);
			draw_rectangle(bbox_left - 1, bbox_top, bbox_right, bbox_bottom, true);
		}
		
		draw_text(10, 10, image_xscale);
	}
}
