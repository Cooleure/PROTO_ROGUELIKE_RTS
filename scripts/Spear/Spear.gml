function Spear()
{
	// INIT
	unit = undefined;
	image_angle_reset = -135;
	image_angle = image_angle_reset + 90;
	image_xscale = 3;
	image_yscale = 3;
	
	// Attacking
	attackRange = 200;
	attackDirection = 0;
	
	// Idle -> LatencyToFight
	function idle()
	{
		followUnit();
		
		// If ready to fight (is not moving)
		if (unit.stateMachineSoldier.isState(SOLDIER_STATE.FIGHT))
		{
			stateMachineWeapon.setState(WEAPON_STATE.LATENCY_TO_FIGHT);
			alarm_set(0, 30); // Duration of the latency to fight
		}
	}
	
	// LatencyToIdle -> Fight
	function latencyToFight()
	{
	    pointEnemy();
		followUnit();
	}
	
	function alarm0()
	{
		stateMachineWeapon.setState(WEAPON_STATE.FIGHT);
	}
	
	// Fight -> LatencyToIdle | Load
	function fight()
	{
		pointEnemy();
		followUnit();
		
		// If not fighting anymore (reset)
		if (not unit.stateMachineSoldier.isState(SOLDIER_STATE.FIGHT))
		{
			stateMachineWeapon.setState(WEAPON_STATE.LATENCY_TO_IDLE);
			alarm_set(1, 45); // Fin de latency to idle
		}
		else // Start fighting
		{
			if (not instance_exists(unit.targetMonster)) exit;
			
			if (collision_circle(x, y, attackRange, unit.targetMonster, true, true) != noone)
			{
				stateMachineWeapon.setState(WEAPON_STATE.LOAD);
				alarm_set(2, 30); // Fin de load
			}
		}
	}
	
	// LatencyToIdle -> Idle
	function latencyToIdle()
	{
		image_angle = lerp(image_angle, image_angle_reset + 90, 0.1);
		followUnit();
	}
	
	function alarm1()
	{
		stateMachineWeapon.setState(WEAPON_STATE.IDLE);
	}
	
	// Load -> Attack
	function load()
	{
		pointEnemy();
		
		// Position cible pour reculer la lance (arrière de l'unité)
	    var loadOffset = -30; // Ajuste cette valeur pour reculer la lance comme tu veux
    
	    // Calcul du déplacement en fonction de l'angle actuel de la lance
	    var offsetX = lengthdir_x(loadOffset, image_angle + 115);
	    var offsetY = lengthdir_y(loadOffset, image_angle + 115);

	    // Utiliser lerp pour reculer la lance par rapport à son angle
	    x = lerp(x, unit.x + offsetX, 0.05);
	    y = lerp(y, unit.y + offsetY, 0.05);
		
		// Cancel
		if (unit.isPanicking())
		{
			stateMachineWeapon.setState(WEAPON_STATE.LATENCY_TO_IDLE);
			alarm_set(1, 45); // Fin de latency to idle
			alarm_set(2, -1); // Cancel transition load -> attack
		}
	}
	
	function alarm2()
	{
		// Calculer la direction de l'attaque en fonction de la cible
		// Uniquement si la cible est toujours vivante au moment de l'attaque

		attackDirection = instance_exists(unit.targetMonster) ? point_direction(x, y, unit.targetMonster.x, unit.targetMonster.y): image_angle + 135;
		show_debug_message(attackDirection)
		stateMachineWeapon.setState(WEAPON_STATE.ATTACK);
		alarm_set(3, 30); // Fin de attack
	}
	
	// Attack -> Reload
	function attack()
	{
		if (DEBUG) image_index = 0;
		
		// Position cible pour l'attaque (vers l'avant, direction de la cible)
	    var attackOffset = 50; // Distance vers la cible pour l'estoc
		
    
		// Convertir la direction en coordonnées pour déplacer la lance
		var offsetX = lengthdir_x(attackOffset, attackDirection);
		var offsetY = lengthdir_y(attackOffset, attackDirection);
    
		// Utiliser lerp pour déplacer la lance vers la cible
		x = lerp(x, unit.x + offsetX, 0.25);
		y = lerp(y, unit.y + offsetY, 0.25);
	
		// If collide monster : damages
		doDamages();
	}
	
	function attackSuccess()
	{
		if (DEBUG) image_index = 1;
		
		// Position cible pour l'attaque (vers l'avant, direction de la cible)
	    var attackOffset = 50; // Distance vers la cible pour l'estoc
    
		// Convertir la direction en coordonnées pour déplacer la lance
		var offsetX = lengthdir_x(attackOffset, attackDirection);
		var offsetY = lengthdir_y(attackOffset, attackDirection);
    
		// Utiliser lerp pour déplacer la lance vers la cible
		x = lerp(x, unit.x + offsetX, 0.25);
		y = lerp(y, unit.y + offsetY, 0.25);
		
		// Cancel
		if (unit.isPanicking())
		{
			stateMachineWeapon.setState(WEAPON_STATE.LATENCY_TO_IDLE);
			alarm_set(1, 45); // Fin de latency to idle
			alarm_set(3, -1); // Cancel transition attack -> reload
		}
	}
	
	function alarm3()
	{
		stateMachineWeapon.setState(WEAPON_STATE.RELOAD);
		alarm_set(4, 30); // Fin de reload
	}
	
	// Reload -> Fight
	function reload()
	{
		if (DEBUG) image_index = 0;
		
		// Position initiale de la lance (par rapport à l'unité)
	    var initialOffsetX = -15;
	    var initialOffsetY = -15;
    
	    // Utiliser lerp pour ramener la lance à sa position initiale
	    x = lerp(x, unit.x + initialOffsetX, 0.1);
	    y = lerp(y, unit.y + initialOffsetY, 0.1);
		
		// Cancel
		if (unit.isPanicking())
		{
			stateMachineWeapon.setState(WEAPON_STATE.LATENCY_TO_IDLE);
			alarm_set(1, 45); // Fin de latency to idle
			alarm_set(4, -1); // Cancel transition reload -> fight
		}
	}
	
	function alarm4()
	{
		stateMachineWeapon.setState(WEAPON_STATE.FIGHT);
	}
	
	stateMachineWeapon = new StateMachine
	(
		WEAPON_STATE.IDLE,
		idle,
		latencyToFight,
		fight,
		latencyToIdle,
		load,
		attack,
		attackSuccess,
		reload
	);
	
	
	// Common multiple states
	function pointEnemy()
	{
		if (not instance_exists(unit.targetMonster)) exit;
		
		// Calculer l'angle cible vers le monstre
	    var _targetAngle = point_direction(x, y, unit.targetMonster.x, unit.targetMonster.y);
		
		_targetAngle -= 135;
    
	    // Utiliser lerp pour tourner progressivement vers la cible
	    image_angle = lerp(image_angle, _targetAngle, 0.1);
	}
	
	function followUnit()
	{
		x = lerp(x, unit.x - 15, 0.5);
		y = lerp(y, unit.y - 15, 0.5);
	}
	
	function doDamages()
	{
		var _inst = instance_place(x, y, oMonster);
		if (_inst != noone)
		{
			_inst.takeDamage();
			
			stateMachineWeapon.setState(WEAPON_STATE.ATTACK_SUCCESS); // Can't do damages twice in the same attack
		}
	}

	// EVENTS
	function step()
	{
		script_execute(stateMachineWeapon.update());
	}
	
	function endStep()
	{
		
	}
	
	function draw()
	{
		draw_self();
		
		if (not DEBUG) exit;
		
		draw_set_color(#9999ff);
		//draw_circle(x, y, attackRange, not (stateMachineWeapon.getState() >= WEAPON_STATE.LOAD));
		draw_circle(x, y, attackRange, true);
		
		draw_set_color(c_white)
		draw_text(x, y - 30, stateMachineWeapon.getState());
	}
}