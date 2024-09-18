enum WEAPON_STATE
{
	IDLE,
	LATENCY_TO_FIGHT,
	FIGHT,
	LATENCY_TO_IDLE
}

function Weapon()
{
	// INIT
	unit = undefined;
	image_angle_reset = -135;
	image_angle = image_angle_reset + 90;
	image_xscale = 3;
	image_yscale = 3;
	
	function idle()
	{
		// If ready to fight (is not moving)
		if (unit.stateMachineSoldier.isState(SOLDIER_STATE.FIGHT))
		{
			stateMachineWeapon.setState(WEAPON_STATE.LATENCY_TO_FIGHT);
			alarm_set(0, 45);
		}
	}
	
	function latencyToFight()
	{
	    // Calculer l'angle cible vers le monstre
	    var target_angle = point_direction(x, y, unit.targetMonster.x, unit.targetMonster.y);
		
		target_angle -= 135
    
	    // Utiliser lerp pour tourner progressivement vers la cible
	    image_angle = lerp(image_angle, target_angle, 0.1);
	}
	
	function alarm0()
	{
		stateMachineWeapon.setState(WEAPON_STATE.FIGHT);
	}
	
	function fight()
	{
		// If not fighting anymore
		if (not unit.stateMachineSoldier.isState(SOLDIER_STATE.FIGHT))
		{
			stateMachineWeapon.setState(WEAPON_STATE.LATENCY_TO_IDLE);
			alarm_set(1, 45);
		}
	}
	
	function latencyToIdle()
	{
		image_angle = lerp(image_angle, image_angle_reset + 90, 0.1);
	}
	
	function alarm1()
	{
		stateMachineWeapon.setState(WEAPON_STATE.IDLE);
	}
	
	stateMachineWeapon = new StateMachine(WEAPON_STATE.IDLE,
		idle,
		latencyToFight,
		fight,
		latencyToIdle
	);

	// EVENTS
	function step()
	{
		script_execute(stateMachineWeapon.update());
	}
	
	function endStep()
	{
		x = unit.x - 15;
		y = unit.y - 15;
	}
	
	function draw()
	{
		draw_self();
		
		draw_set_color(c_white)
		draw_text(x, y - 30, stateMachineWeapon.getState());
	}
}