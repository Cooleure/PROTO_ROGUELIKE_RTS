///////////////////////////////
///// STATE MACHINE MODEL /////
///////// EVENT CLASS /////////
///////////////////////////////

enum SOLDIER_STATE
{
	IDLE,
	LATENCY,
	MOVE,
	FIGHT,
	PANIC
}

function Soldier()
{
	/// INIT
	
	// Appareance
	spriteIdle = sSoldierIdle;
	spriteWalk = sSoldierWalk;
	sprite_index = spriteIdle;
	image_xscale = 3;
	image_yscale = 3;
	sprite_index = spriteIdle;
	image_index = irandom(sprite_get_number(sprite_index));
	
	// Movement target
	moveTargetX = 0;
	moveTargetY = 0;
	
	moveSpeed = 0;
	currentMoveSpeed = 0;
	
	// Id
	troop = undefined;
	targetMonster = undefined;
	no = undefined;
	
	// Weapon
	weapon = instance_create_layer(x, y, "Weapons", oSpear);
	weapon.unit = id;
	
	// Panic
	panicRange = 50;
	
	// State Machine
	function idle()
	{
		// Detect panic
		var _panicDetected = collision_circle(x, y, panicRange, oMonster, false, true) != noone;
		
		if (_panicDetected)
		{
			stateMachineSoldier.setState(SOLDIER_STATE.PANIC);
		}
		
		// Else : detect panic
		else if (troop.isFighting())
		{
			stateMachineSoldier.setState(SOLDIER_STATE.FIGHT);
		}
	}
	
	function latency()
	{
		
	}
	
	function move()
	{
		var distance = point_distance(x, y, moveTargetX, moveTargetY);

		// Si l'objet est proche de la cible, réduire progressivement la vitesse
		var slowDownDistance = 30;  // Distance à partir de laquelle l'objet commence à ralentir

		if (distance == 0)
		{
		    // Stopper l'objet quand il atteint la destination
		    speed = 0;

		    stateMachineSoldier.setState(SOLDIER_STATE.IDLE);
		    sprite_index = spriteIdle;
		    image_index = irandom(sprite_get_number(sprite_index));
		}
		else
		{
		    // Interpolation linéaire pour atteindre la vitesse maximale progressivement
		    currentMoveSpeed = lerp(currentMoveSpeed, moveSpeed, 0.1);
    
		    // Si l'objet est dans la zone de ralentissement, réduire la vitesse
		    if (distance < slowDownDistance)
		    {
		        // Ralentir la vitesse à l'approche de la cible, proportionnellement à la distance
		        currentMoveSpeed = lerp(currentMoveSpeed, 0.1, 0.1);
		    }

		    // Déplacement vers la cible avec la vitesse ajustée
		    move_towards_point(moveTargetX, moveTargetY, min(distance, currentMoveSpeed));
		}
	}
	
	function fight()
	{
		var _panicDetected = collision_circle(x, y, panicRange, oMonster, false, true) != noone;
		
		if (_panicDetected)
		{
			stateMachineSoldier.setState(SOLDIER_STATE.PANIC);
		}
		
		else if (troop.isIdle())
		{
			stateMachineSoldier.setState(SOLDIER_STATE.IDLE);
		}
	}
	
	function panic()
	{
		var _panicDetected = collision_circle(x, y, panicRange, oMonster, false, true) != noone;
		
		if (not _panicDetected) // Back to a normal behiavor
		{
			if (troop.isIdle()) // The troop is not fighting
			{
				stateMachineSoldier.setState(SOLDIER_STATE.IDLE);
			}
			else if (troop.isFighting()) // The troop is fighting
			{
				stateMachineSoldier.setState(SOLDIER_STATE.FIGHT);
			}
		}
	}
	
	stateMachineSoldier = new StateMachine
	(
		SOLDIER_STATE.IDLE,
		idle,
		latency,
		move,
		fight,
		panic
	);

	/// EVENTS
	function step()
	{
		script_execute(stateMachineSoldier.update());
	}
	
	function alarm0()
	{
		// LATENCY : end of latency and start moving
		stateMachineSoldier.setState(SOLDIER_STATE.MOVE);
		sprite_index = spriteWalk;
		image_index = irandom(sprite_get_number(sprite_index));
		//image_xscale = image_xscale * sign(x - mouse_x); --> bug change l'ordre des personnages dans la troupe
	}

	function draw()
	{
		draw_self();
		
		if (not DEBUG) exit;
		
		draw_set_color(#99ff99);
		draw_circle(x, y, panicRange, not stateMachineSoldier.isState(SOLDIER_STATE.PANIC));
		
		//draw_set_color(c_white);
		//draw_text(x, y, stateMachineSoldier.getState());
	}
	
	// Public functions
	function moveToPoint(_x, _y)
	{
		moveTargetX = _x + random_range(-6, 6);
		moveTargetY = _y + random_range(-6, 6);
		
		moveSpeed = random_range(2.7, 2.8);
		
		stateMachineSoldier.setState(SOLDIER_STATE.LATENCY); // Temps de réponse variable selon les soldats
		alarm_set(0, irandom_range(3, 10));
	}
	
	function isPanicking()
	{
		return stateMachineSoldier.isState(SOLDIER_STATE.PANIC);
	}
}
