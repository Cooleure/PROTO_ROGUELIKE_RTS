///////////////////////////////
///// STATE MACHINE MODEL /////
///////// EVENT CLASS /////////
///////////////////////////////

function Leader()
{
	/// INIT
	stateMachineExample = new StateMachine(SM_MODEL_STATE.FIRST_STATE,
										StateObjectStateFirstState,
										StateObjectStateSecondState,
										StateObjectStateThirdState);

	/// EVENTS
	function step()
	{
		script_execute(stateMachineExample.update());
	}

	function draw()
	{
		
	}
}
