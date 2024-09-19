function TroopMonster()
{
	/// INIT
	generateTroop(oMonster, "Monsters", oMonster, "Monsters");
	
	// Attacking
	fightRange = 400;
	fightDetected = false;
	previousFightDetected = fightDetected;
	
	/// EVENTS
	function step()
	{
		// Fighting detection
		enemyTroop = collision_circle(x, y, fightRange, oTroopSoldier, true, true);
		fightDetected = enemyTroop != noone;
		
		// Each soldier of the troop is assigned to a monster that the troop can see in his detection area
		if (fightDetected and previousFightDetected != fightDetected)
		{
			previousFightDetected = fightDetected;

			for (var i = 0; i < ds_list_size(soldiersList); i++)
			{
				var _soldier = soldiersList[| i];
				_soldier.targetMonster = enemyTroop.soldiersList[| i];
			}
		}
	}
	
	function leftPressed()
	{
		
	}
	
	function globalRightPressed()
	{
		if (selected)
		{
			
		}
	}

	function draw()
	{
		if (not DEBUG) exit;
		
		draw_self();
		
		//for (var i = 0; i < ds_list_size(soldiersList); i++)
		//{
		//    draw_text(x + i* 50, y, soldiersList[| i]);
		//}
		
		draw_set_color(#FF9999);
		draw_circle(x, y, fightRange, not isFighting());
	}
	
	// Public functions
	function isFighting()
	{
		return fightDetected;
	}
}
