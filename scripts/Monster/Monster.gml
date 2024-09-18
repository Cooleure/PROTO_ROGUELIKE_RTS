///////////////////////////////
///// STATE MACHINE MODEL /////
///////// EVENT CLASS /////////
///////////////////////////////

enum MONSTER_STATE
{
	IDLE,
	LATENCY,
	MOVE
}

function Monster()
{
	/// INIT
	// Appareance
	spriteIdle = sMonstreIdle;
	spriteWalk = sMonstreWalk;
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
	no = undefined;
	
	// State Machine
	function idle()
	{
		
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
	
	stateMachineSoldier = new StateMachine(SOLDIER_STATE.IDLE,
		idle,
		latency,
		move
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
		
		draw_set_color(c_white);
		draw_text(x, y, no);
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
}
