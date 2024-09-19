enum TROOP_SOLDIER_STATE
{
	IDLE,
	FIGHT
}

function TroopSoldier()
{
	/// INIT
	generateTroop(oLeader, "Soldiers", oSoldier, "Soldiers");
	
	// Attacking
	fightRange = 400;
	
	// State machine
	function idle()
	{
		// Fighting detection
		var _fightDetected = assignSoldiersToEnnemies();
		
		if (_fightDetected)
		{
			stateMachineTroopSoldier.setState(TROOP_SOLDIER_STATE.FIGHT);
			alarm_set(0, 30);
		}
	}
	
	function fight()
	{
		// Fighting detection
		var _fightDetected = collision_circle(x, y, fightRange, oTroopMonster, true, true) != noone;

		// No fighting anymore
		if (not _fightDetected)
		{
			stateMachineTroopSoldier.setState(TROOP_SOLDIER_STATE.IDLE);
			alarm_set(0, -1);
		}
	}
	
	function alarm0()
	{
		assignSoldiersToEnnemies();
		alarm_set(0, 30);
	}
	
	stateMachineTroopSoldier = new StateMachine
	(
		TROOP_SOLDIER_STATE.IDLE,
		idle,
		fight
	);
	
	
	/// EVENTS
	function step()
	{
		script_execute(stateMachineTroopSoldier.update());
	}
	
	function leftPressed()
	{
		with (oTroop)
		{
			selected = false;
		}
		
		selected = not selected;
	}
	
	function globalRightPressed()
	{
		if (selected)
		{
			for (var i = 0; i < sizeX; i++)
			{
			    for (var j = 0; j < sizeY; j++)
				{
					var _soldier = ds_grid_get(soldiersGrid, i, j);
				
					var _posX = i - centerX;
					var _posY = j - centerY;
					//show_debug_message(_soldier.no);

					var rotated = rotate(_posX, _posY, angle);

					var _destX = mouse_x + rotated[0] * (spacing + _soldier.sprite_width / 2);
					var _destY = mouse_y + rotated[1] * (spacing + _soldier.sprite_height / 2);
					
					_soldier.moveToPoint(_destX, _destY);
				}
			}
		}
	}

	function draw()
	{
		//for (var i = 0; i < 3; i++)
		//{
		//    for (var j = 0; j < 3; j++)
		//	{
		//		draw_set_color(c_black);
		//	    draw_text(30 + i * 30, 30 + j * 30, soldiersGrid[# i, j].no);
		//	}
		//}
		
		if (DEBUG)
		{
			// Draw detection attacking range
			draw_set_color(#FF9999);
			draw_circle(x, y, fightRange, not isFighting());
		
			draw_set_color(c_black);
			draw_text(x - 150, y - 150, stateMachineTroopSoldier.getState());
		}
		
		if (selected)
		{
			draw_set_color(c_green);
			draw_rectangle(bbox_left - 1, bbox_top, bbox_right, bbox_bottom, true);
		}
	}
	
	// Public functions
	function assignSoldiersToEnnemies()
	{
		// Créer une liste pour tous les ennemis
		var _allEnemies = ds_list_create();

		// Chercher toutes les troupes ennemies dans le périmètre de détection
		var _enemyTroops = ds_list_create();
		var _numTroops = collision_circle_list(x, y, fightRange, oTroopMonster, true, true, _enemyTroops, false);

		// Si on détecte des troupes ennemies
		if (_numTroops > 0)
		{
		    // Récupérer tous les soldats ennemis de chaque troupe et les ajouter à _allEnemies
		    for (var t = 0; t < _numTroops; t++)
		    {
		        var _enemyTroop = _enemyTroops[| t]; // Récupérer la troupe ennemie
		        var _enemySoldiers = _enemyTroop.soldiersList; // Récupérer la liste des soldats ennemis

		        // Ajouter chaque soldat ennemi à la liste _allEnemies
		        for (var k = 0; k < ds_list_size(_enemySoldiers); k++)
		        {
		            var _enemy = _enemySoldiers[| k];
		            ds_list_add(_allEnemies, _enemy);
		        }
		    }

		    // Pour chaque soldat de notre troupe
		    for (var j = 0; j < ds_list_size(soldiersList); j++)
		    {
		        var _soldier = soldiersList[| j]; // Récupérer un soldat de notre troupe

		        // Variables pour garder la trace de l'ennemi le plus proche
		        var _closestEnemy = undefined;
		        var _closestDistance = infinity; // Une distance initiale plus grande que le périmètre

		        // Chercher l'ennemi le plus proche parmi tous les ennemis
		        for (var e = 0; e < ds_list_size(_allEnemies); e++)
		        {
		            var _enemy = _allEnemies[| e];
					
					//// ALERT : potentiel bug : est-on sûrs que l'enemy toujours vivant au moment de check ça ? Vérifier que l'ennemi est toujours existant
					

		            // Calculer la distance entre notre soldat et cet ennemi
		            var _distance = point_distance(_soldier.x, _soldier.y, _enemy.x, _enemy.y);

		            // Si cet ennemi est plus proche que le précédent
		            if (_distance < _closestDistance)
		            {
		                _closestEnemy = _enemy; // Cet ennemi devient la nouvelle cible
		                _closestDistance = _distance; // Mettre à jour la distance la plus proche
		            }
		        }
					

		        // Assigner l'ennemi le plus proche trouvé comme cible pour notre soldat
		        if (_closestEnemy != undefined)
		        {
		            _soldier.targetMonster = _closestEnemy;
		        }
		    }
		}

		// Détruire les listes temporaires
		ds_list_destroy(_enemyTroops);
		ds_list_destroy(_allEnemies);
		
		return (_numTroops > 0)
	}
	
	function isIdle()
	{
		return stateMachineTroopSoldier.isState(TROOP_SOLDIER_STATE.IDLE);
	}
	
	function isFighting()
	{
		return stateMachineTroopSoldier.isState(TROOP_SOLDIER_STATE.FIGHT);
	}
}
