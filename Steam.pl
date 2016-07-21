/*
accion(NombreDelJuego)
mmorpg(NombreDelJuego, CantidadDeUsuarios)
puzzle(NombreDelJuego, CantidadDeNiveles, Dificultad)
*/

juego(accion(callOfDuty), 5).
juego(accion(batmanAA), 10).
juego(mmorpg(wow, 5000000), 30).
juego(mmorpg(lineage2, 6000000), 15).
juego(puzzle(plantsVsZombies, 40, media), 10).
juego(puzzle(tetris, 10, facil), 0).

oferta(callOfDuty, 10).
oferta(plantsVsZombies, 50).
oferta(lineage2, 60).

usuario(nico, [batmanAA, plantsVsZombies, tetris], [compra(lineage2)]).
usuario(fede, [], [regalo(callOfDuty,nico),regalo(wow, nico)]).
usuario(rasta, [lineage2], []).
usuario(agus, [], []).
usuario(felipe, [plantsVsZombies], [compra(tetris)]).

nombreDelJuego(accion(Nombre), Nombre).
nombreDelJuego(mmorpg(Nombre, _), Nombre).
nombreDelJuego(puzzle(Nombre, _, _), Nombre).

cuantoSale(Juego, Precio):-
	juego(Juego,_),
	precioDe(Juego, Precio).

precioDe(Juego, Precio):-
	juego(Juego, PrecioU),
	nombreDelJuego(Juego, Nombre),
	oferta(Nombre, Porcentaje),
	Precio is PrecioU - (PrecioU * (Porcentaje / 100)).

precioDe(Juego, Precio):-
	juego(Juego, Precio).

juegoPopular(Juego):-
	juego(Juego,_),
	tipoDe(Juego).

tipoDe(accion(_)).
tipoDe(mmorpg(_, Usuarios)):-
	Usuarios > 1000000.
tipoDe(puzzle(_, 25, _)).
tipoDe(puzzle(_, _, facil)).

tieneUnBuenDescuento(Juego):-
	juego(Juego, _),
	nombreDelJuego(Juego, Nombre),
	granDescuento(Nombre).

granDescuento(Nombre):-
	oferta(Nombre, Porcentaje),
	Porcentaje > 50.


listaDe(regalo(Nombre,_), Nombre).
listaDe(compra(Nombre), Nombre).

adictoALosDescuentos(Usuario):-
	usuario(Usuario, _, Lista),
	forall(member(Adquisicion,Lista), (listaDe(Adquisicion,Nombre), granDescuento(Nombre))).
/*
fanaticoDe(Usuario, Juego):-
	usuario(Usuario, _, Lista).
	juego(Juego),
	nombreDelJuego(Juego, Nombre).

monotematico(Usuario, Juego):-
	.

buenosAmigos(Usuario, OtroUsuario):-
	.
*/
cuantoGastara(Usuario, Dinero):-
	usuario(Usuario, _, Lista),
	findall(Adquisicion,member(Adquisicion,Lista),Adquisiciones),
	findall(Nombre,(member(Nombre,Adquisiciones), granDescuento(Nombre)),Nombres),
