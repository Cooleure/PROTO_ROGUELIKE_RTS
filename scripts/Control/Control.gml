///////////////////////////////
///// STATE MACHINE MODEL /////
///////// EVENT CLASS /////////
///////////////////////////////

#macro DEBUG false
#macro Test:DEBUG true


function Control()
{
	/// INIT
	show_debug_log(DEBUG);
	randomize();
	
	/// EVENTS
	function step()
	{
		if (keyboard_check_pressed(ord("R"))) game_restart();
		if (keyboard_check_pressed(ord("M")))
		{
			instance_destroy(oMonster);
		}

	}
	
	function globalLeftPressed()
	{
		if (not collision_point(mouse_x, mouse_y, oTroop, false, true))
		{
			with (oTroop)
			{
				selected = false;
			}
		}
	}

	function draw()
	{
		
	}
}
