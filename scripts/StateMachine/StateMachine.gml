/////////////////////////
///// STATE MACHINE /////
/////////////////////////

function StateMachine(_state) constructor
{
	/// CONSTRUCTOR
	// Current state of the state machine
	state = _state;

	// Set the state functions
	stateMachine = array_create(0);

	for (var _i = 1; _i < argument_count; _i++)
	{
		array_push(stateMachine, argument[_i]);
	}
	
	/// FUNCTIONS
	// Play the state function from the current state
	function update()
	{
		return stateMachine[state];
	}

	// Get the current state
	function getState()
	{
		return state;
	}

	// Set the current state
	function setState(_state)
	{
		state = _state;
	}

	// Check the current state
	function isState(_state)
	{
		return (state == _state);
	}
}
