///////////////////////////////
///// STATE MACHINE MODEL /////
///////// EVENT CLASS /////////
///////////////////////////////

function Control()
{
	/// INIT
	show_debug_log(true);
	
	stateMachineExample = new StateMachine(SM_MODEL_STATE.FIRST_STATE,
										StateObjectStateFirstState,
										StateObjectStateSecondState,
										StateObjectStateThirdState);

	/// EVENTS
	function step()
	{
		script_execute(stateMachineExample.update());
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
