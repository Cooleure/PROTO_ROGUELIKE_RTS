///////////////////////////////
///// STATE MACHINE MODEL /////
/////// STATE FUNCTIONS ///////
///////////////////////////////

function StateObjectStateFirstState()
{
	//show_debug_message("first state");
	stateMachineExample.setState(SM_MODEL_STATE.SECOND_STATE);
}

function StateObjectStateSecondState()
{
	//show_debug_message("seconde state");
	stateMachineExample.setState(SM_MODEL_STATE.THIRD_STATE);
}

function StateObjectStateThirdState()
{
	//show_debug_message("third state");	
	stateMachineExample.setState(SM_MODEL_STATE.FIRST_STATE);
}
