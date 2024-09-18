///////////////////////////////
///// STATE MACHINE MODEL /////
///////// EVENT CLASS /////////
///////////////////////////////

enum SOLDIER_STATE
{
	IDLE,
	MOVE
}

function Soldier()
{
	/// INIT
	// State Machine
	function idle()
	{
		
	}
	
	function move()
	{
		// Calculate the distance between the instance and the destination
		var distance = point_distance(x, y, moveTargetX, moveTargetY);

		// If we're at the destination coordinates
		if (distance == 0)
		{
		    // Set instance speed to zero to stop moving
		    speed = 0;
			stateMachineSoldier.setState(SOLDIER_STATE.IDLE);
		}
		else
		{
		    // This is the maximum distance you want to move each frame
		    var max_step = 3;
  
		    // Move towards the destination coordinates by no more than max_step
		    move_towards_point(moveTargetX, moveTargetY, min(distance, max_step));
		}
		
	}
	
	stateMachineSoldier = new StateMachine(SOLDIER_STATE.IDLE,
		idle,
		move
	);
				
	moveTargetX = 0;
	moveTargetY = 0;
	
	no = undefined;

	/// EVENTS
	function step()
	{
		script_execute(stateMachineSoldier.update());
	}

	function draw()
	{
		draw_self();
		
		draw_set_color(c_black);
		draw_text(x, y, no);
	}
	
	
	// Public functions
	function moveToPoint(_x, _y)
	{
		moveTargetX = _x;
		moveTargetY = _y;
		
		stateMachineSoldier.setState(SOLDIER_STATE.MOVE);
	}
}
