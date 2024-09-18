function TroopSoldier()
{
	/// INIT
	generateTroop(oLeader, "Soldiers", oSoldier, "Soldiers");
	
	// Attacking
	attackRange = 400;
	fightDetected = false;
	previousFightDetected = fightDetected;
	
	/// EVENTS
	function step()
	{
		// Fighting detection
		fightDetected = collision_circle(x, y, attackRange, oMonster, false, true) != noone;
		
		// Each soldier of the troop is assigned to a monster that the troop can see in his detection area
		if (fightDetected and previousFightDetected != fightDetected)
		{
			previousFightDetected = fightDetected;
			
			var _list = ds_list_create();
			var _num = collision_circle_list(x, y, attackRange, oMonster, false, true, _list, false);
			if (_num > 0)
			{
				for (var i = 0; i < ds_list_size(soldiersList); i++)
				{
					var _soldier = soldiersList[| i];
					var _randomMonster = _list[| irandom(ds_list_size(_list) - 1)];
				    _soldier.targetMonster = _randomMonster;
					show_debug_message(_soldier.targetMonster)
				}
			}
			ds_list_destroy(_list);
		}
	}
	
	function leftPressed()
	{
		with (oTroop)
		{
			selected = false;
		}
		
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
					//show_debug_message(_soldier.no);

					var rotated = rotate(_posX, _posY, angle);

					var _destX = mouse_x + rotated[0] * (spacing + _soldier.sprite_width / 2);
					var _destY = mouse_y + rotated[1] * (spacing + _soldier.sprite_height / 2);
					
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
		
		for (var i = 0; i < 3; i++)
		{
		    for (var j = 0; j < 3; j++)
			{
				draw_set_color(c_black);
			    draw_text(30 + i * 30, 30 + j * 30, soldiersGrid[# i, j].no);
			}
		}
		
		// Draw detection attacking range
		draw_set_color(c_red);
		draw_circle(x, y, attackRange, not fightDetected);
	}
}
