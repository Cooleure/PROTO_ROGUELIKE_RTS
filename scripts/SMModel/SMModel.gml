///////////////////////////////
///// STATE MACHINE MODEL /////
///////// EVENT CLASS /////////
///////////////////////////////

/// Squelette d'un objet utilisant le state machine ///
function SM_Model()
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
