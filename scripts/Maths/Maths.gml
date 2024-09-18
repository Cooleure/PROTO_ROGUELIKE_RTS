// Fonction pour appliquer la rotation (par exemple 45 degrés pour former un losange)
function rotate(_x, _y, _angle)
{
	_angle = degtorad(_angle)
	var cosA = cos(_angle);
	var sinA = sin(_angle);
	var newX = _x * cosA - _y * sinA;
	var newY = _x * sinA + _y * cosA;
	
	return [newX, newY];
}

// Fonction pour obtenir l'ordre des positions d'une grille en diagonale
function getDiagOrder(_sizeX, _sizeY)
{
    var _order = array_create(_sizeX * _sizeY);
    
    // L'ordre de lecture des indices basé sur la hauteur
	var _count = 0;
	
    for (var d = 0; d < (_sizeX + _sizeY - 1); d++)
	{
        for (var i = 0; i < _sizeX; i++)
		{
            var j = d - i;
            if (j >= 0 && j < _sizeY)
			{
                _order[_count] = [i, j];
				_count++;
            }
        }
    }
    
    return _order;
}