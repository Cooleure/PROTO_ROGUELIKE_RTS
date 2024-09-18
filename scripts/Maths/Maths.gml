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