///////////////////////////////
///// STATE MACHINE MODEL /////
///////// EVENT CLASS /////////
///////////////////////////////

function Leader()
{
	/// INIT
	// Appareance
	spriteIdle = sLeaderIdle;
	spriteWalk = sLeaderWalk;
	sprite_index = spriteIdle;

	/// EVENTS
	function stepLeader()
	{
		
	}

	function draw()
	{
		draw_self();
		
		//draw_text(x, y, moveToPoint);
	}
}
