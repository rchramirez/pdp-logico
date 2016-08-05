pokemon(pikachu, electrico(220)).
pokemon(charmander, fuego([ascuas, lanzallamas])).
pokemon(slowpoke, agua(42, 130)).

posicion(aula404, blastoise).
posicion(buffet, raichu).
posicion(aulaMagna, gyarados).
posicion(aula404, fede).
posicion(aulaMagna, maggie).
posicion(entradaMedrano, bianca).

piso(aula404, 4).
piso(buffet, 4).
piso(aulaMagna, 0).

tiene(erwin, vulpix).
tiene(erwin, chharmander).
tiene(maggie, electrode).
tiene(maggie, golduck).
%...etc
% PUNTO UNO
esUnZoologico(Lugar):-
	posicion(Lugar, Pokemon),
	pokemon(Pokemon,_),
	not(tiene(Pokemon,_)).

